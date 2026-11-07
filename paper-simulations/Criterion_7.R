# ==============================================================================
# NormGen: Comprehensive Reproducible Simulation and Benchmarking Suite
# Author: Piotr Sulewski
# Seed Anchor: 2026 (Standardized Environment)
# Criterion 7
# ==============================================================================

library(NormGen)
library(microbenchmark)
library(ggplot2)
library(RcppParallel)
library(openxlsx)

# ==============================================================================
# 7. Computational performance and scaling efficiency
# ==============================================================================

# Global configuration constants
set.seed(2026) # initialize the pseudo-random number generator
sizes <- c(10^3, 10^4, 10^5, 10^6, 10^7)

# Create output folder if missing due to Windows path resets
if (!dir.exists("C:/NormGen")) dir.create("C:/NormGen", recursive = TRUE)

# ==============================================================================
# A. Descriptive statistics and quartile distribution of execution times
# (in milliseconds) for the triad generator comparison (as illustrated in Table 7)
# ==============================================================================
print("--- Extracting Empirical Descriptive Metrics for the Full Triad ---")
table_sizes <- c(10^3, 10^4, 10^5, 10^6, 10^7)
compiled_table_data <- data.frame()

for (n_t in table_sizes) {
  print(paste("Calculating quantiles for full triad table layout at n =", n_t))

  # Reduced replicates for the massive n=10^7 to secure execution stability
  current_reps <- if(n_t == 10^7) 10 else 100

  mb_table <- microbenchmark(
    rnorm       = rnorm(n_t, mean = 0, sd = 1),
    Rnorm       = Rnorm(n_t, mean = 0, sd = 1),
    PRnorm      = PRnorm(n_t, mean = 0, sd = 1),
    times = current_reps,
    unit = "ms"
  )

  # Parse out execution vectors for the three targets
  t_R  <- mb_table[["time"]][mb_table[["expr"]] == "rnorm"] / 10^6
  t_RN <- mb_table[["time"]][mb_table[["expr"]] == "Rnorm"] / 10^6
  t_PR <- mb_table[["time"]][mb_table[["expr"]] == "PRnorm"] / 10^6

  # Compile structure row-by-row for the complete triad matrix
  metrics_R <- data.frame(
    Generator = "rnorm", n = n_t, Minimum = min(t_R), Lower_Quartile = quantile(t_R, 0.25)[],
    Median = median(t_R), Mean = mean(t_R), Upper_Quartile = quantile(t_R, 0.75)[], Maximum = max(t_R)
  )

  metrics_RN <- data.frame(
    Generator = "Rnorm", n = n_t, Minimum = min(t_RN), Lower_Quartile = quantile(t_RN, 0.25)[],
    Median = median(t_RN), Mean = mean(t_RN), Upper_Quartile = quantile(t_RN, 0.75)[], Maximum = max(t_RN)
  )

  metrics_PR <- data.frame(
    Generator = "PRnorm", n = n_t, Minimum = min(t_PR), Lower_Quartile = quantile(t_PR, 0.25)[],
    Median = median(t_PR), Mean = mean(t_PR), Upper_Quartile = quantile(t_PR, 0.75)[], Maximum = max(t_PR)
  )

  compiled_table_data <- rbind(compiled_table_data, metrics_R, metrics_RN, metrics_PR)
}

# Export the matrix directly to clean spreadsheet
write.xlsx(compiled_table_data, "C:/NormGen/Table7.xlsx", overwrite = TRUE)
print("--- [SUCCESS] All 3 plots saved. Complete Triad spreadsheet data exported. ---")

# ==============================================================================
# B. Empirical side-by-side runtime density distributions
# for the triad generator comparison (as illustrated in Figure 5)
# ==============================================================================
print("--- Launching Benchmark 3: Multi-Panel Side-by-Side Violin Densities ---")

target_seed <- 2026

# --- Experiment A: Small Scale Dimension (n = 10,000 | neval = 10,000) ---
print("Profiling Density Set A (n = 10^4)...")
n_vA <- 10000
mb_vA <- microbenchmark(
  `rnorm` = rnorm(n_vA, mean = 0, sd = 1),
  `Rnorm` = Rnorm(n_vA),
  `PRnorm` = PRnorm(n_vA, mean = 0, sd = 1, seed = target_seed),
  times = 10000,
  unit = "ms"
)

data_vA <- data.frame(
  Generator = mb_vA[["expr"]],
  Time = mb_vA[["time"]] / 1000, # Convert to microseconds
  Config = "Sample Size: n = 10,000 (Microseconds)"
)

# --- Experiment B: Massive Scale Dimension (n = 10,000,000 | neval = 10) ---
# Limit n_eval to 1e7 to prevent RAM depletion and CPU thermal lockouts
n_eval <- 1e7
print("Profiling Density Set B (n = 10^7)...")
n_vB <- 10000000
mb_vB <- microbenchmark(
  `rnorm` = rnorm(n_vB, mean = 0, sd = 1),
  `Rnorm` = Rnorm(n_vB),
  `PRnorm` = PRnorm(n_vB, mean = 0, sd = 1, seed = target_seed),
  times = 10,
  unit = "ms"
)

data_vB <- data.frame(
  Generator = mb_vB[["expr"]],
  Time = mb_vB[["time"]] / 10^6, # Convert to milliseconds for clear multi-scale visualization
  Config = "Sample Size: n = 10,000,000 (Milliseconds)"
)

# --- Merge and Combine Structures ---
combined_violin_data <- rbind(data_vA, data_vB)

# --- Multi-Panel Side-by-Side Visualization Plot ---
plot_side_by_side <- ggplot(combined_violin_data, aes(x = Time, y = Generator, fill = Generator)) +
  geom_violin(trim = TRUE, scale = "width", color = "black", linewidth = 0.4, alpha = 0.8) +
  scale_x_log10() + # Logarithmic scale handles independent structural dimensions perfectly
  scale_fill_manual(values = c(
    "rnorm" = "#868686FF",
    "Rnorm" = "#3182bd",
    "PRnorm" = "#e7aba7"
  )) +
  # Facet wrap dynamically splits the execution environment into side-by-side structures
  facet_wrap(~ Config, scales = "free_x", ncol = 2) +
  labs(
    title = "Runtime Density Distribution: Scaling Comparison",
    subtitle = "Granular scaling and modal density structures (Seed = 2026)",
    x = "Execution Time (Log Scale)",
    y = ""
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 14),
    plot.subtitle = element_text(size = 10, hjust = 0.5, face = "italic", color = "gray20"),
    legend.position = "none",
    strip.text = element_text(face = "bold", size = 11, color = "black"), # Style for panel headers
    strip.background = element_rect(fill = "#ebebeb", color = NA),
    panel.grid.major.x = element_line(color = "#ebebeb"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black")
  )

# Render side-by-side plot inside active session window
print(plot_side_by_side)

# Save the multi-panel publication asset directly to the package root
ggsave(
  filename = "C:/NormGen/Figure5.png",
  plot = plot_side_by_side,
  width = 11, # Increased width for a neat horizontal layout
  height = 5.5,
  dpi = 300
)
print("Success! Side-by-side multi-panel violin plot saved to C:/NormGen/Figure5.png")

# ==============================================================================
# C. Performance trend and runtime comparison for the triad generator comparison
# (as illustrated in Figure 6)
# ==============================================================================
print("--- Launching Benchmark 1: Runtime Line Trends ---")
trend_results <- data.frame()

for (n in sizes) {
  print(paste("Profiling mean runtimes for sample size n =", n))
  mb <- microbenchmark(
    rnorm  = rnorm(n, mean = 0, sd = 1),
    Rnorm  = Rnorm(n),
    PRnorm = PRnorm(n, mean = 0, sd = 1, seed = target_seed), # Standardized function call
    times = 10,
    unit = "ms"
  )

  tmp <- data.frame(
    SampleSize = n,
    Method = c("rnorm", "Rnorm", "PRnorm"),
    Time = c(mean(mb[["time"]][mb[["expr"]] == "rnorm"]) / 10^6,
             mean(mb[["time"]][mb[["expr"]] == "Rnorm"]) / 10^6,
             mean(mb[["time"]][mb[["expr"]] == "PRnorm"]) / 10^6)
  )
  trend_results <- rbind(trend_results, tmp)
}

trend_results[["SampleSizeFactor"]] <- factor(
  trend_results[["SampleSize"]], levels = sizes,
  labels = c("10^3", "10^4", "10^5", "10^6", "10^7")
)

plot_trends <- ggplot(trend_results, aes(x = SampleSizeFactor, y = Time, color = Method, group = Method)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3, shape = 21, fill = "white", stroke = 1.5) +
  scale_y_log10() +
  # CRITICAL FIX: The manual color keys now exactly match the Method vector strings
  scale_color_manual(values = c(
    "rnorm"  = "#868686FF",
    "Rnorm"  = "#0073C2FF",
    "PRnorm" = "#CD534CFF"
  )) +
  labs(
    title = "Execution Time Trends: Triad Generator Comparison",
    subtitle = "Performance scaling across increasing sample depths (Seed = 2026)",
    x = "Sample Size (n, Log Scale)",
    y = "Mean Execution Time (Milliseconds, Log Scale)",
    color = "Generator Variant"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, face = "italic"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave("C:/NormGen/Figure6.png", plot = plot_trends, width = 8, height = 5, dpi = 300)

# ==============================================================================
# 4. Multi-threaded scalability curve and empirical speedup factor profile
# for the PR_norm generator executed at n=10^7 observations
# across varying CPU thread allocations (as illustrated in Figure 7)
# ==============================================================================
print("--- Launching Benchmark 2: Thread Scalability & Speedup Curve ---")
n_scale <- 10^7
threads_set <- c(1, 2, 4, 8, 12, 16, 24, 32)
scalability_data <- data.frame()

print("Establishing single-threaded sequential baseline...")
base_mb <- microbenchmark(Sequential = Rnorm(n_scale), times = 5, unit = "ms")
t_sequential <- mean(base_mb[["time"]]) / 10^6

for (t in threads_set) {
  print(paste("Configuring Intel TBB worker pool allocation to threads =", t))
  RcppParallel::setThreadOptions(numThreads = t)

  mb_par <- microbenchmark(
    Parallel = PRnorm(n_scale, mean = 0, sd = 1, seed = target_seed),
    times = 5, unit = "ms"
  )

  t_parallel <- mean(mb_par[["time"]]) / 10^6
  speedup_factor <- t_sequential / t_parallel

  scalability_data <- rbind(
    scalability_data,
    data.frame(Threads = t, MeanTime = t_parallel, Speedup = speedup_factor)
  )
}
RcppParallel::setThreadOptions(numThreads = "auto")

plot_scalability <- ggplot(scalability_data, aes(x = Threads, y = Speedup)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
  geom_line(color = "#CD534CFF", linewidth = 1.2) +
  geom_point(size = 3.5, shape = 21, fill = "white", stroke = 1.5, color = "#CD534CFF") +
  scale_x_continuous(breaks = threads_set) +
  scale_y_continuous(breaks = seq(0, max(scalability_data[["Speedup"]]) + 2, by = 2)) +
  labs(
    title = "Parallel Scalability and Speedup Analysis",
    subtitle = "NormGen PRnorm efficiency curve relative to single-threaded Rnorm baseline",
    x = "Number of CPU Threads (Intel TBB Workers)",
    y = "Speedup Factor (T_sequential / T_parallel)"
  ) +
  annotate("text", x = 12, y = 13, label = "Ideal Linear Scaling (Slope = 1)", color = "gray40", angle = 36, fontface = "italic") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, face = "italic"),
    panel.grid.minor = element_blank()
  )

ggsave("C:/NormGen/Figure7.png", plot = plot_scalability, width = 8, height = 5, dpi = 300)


