#packages
install.packages("targets")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("visNetwork")
install.packages("here")
library(targets)
library(ggplot2)
library(dplyr)
library(medicaldata)
library(visNetwork)
library(here)

# folders example
P <- ggplot(supraclavicular, aes(x = factor(group), y = onset_sensory)) +
  geom_boxplot(fill = "lightblue") +
  labs(
    title = "Sensory Block Onset by Anesthetic Group",
    x = "Group (1 = Mixture, 2 = Sequential)",
    y = "Onset Time (minutes)"
  ) +
  theme_minimal()
ggsave(here("plots", "barplot.png"), plot = p)

# Functionalizing code example:

# nonfunction
supraclavicular %>%
  group_by(group) %>%
  summarize(
    median_onset = median(onset_sensory, na.rm = TRUE),
    IQR_onset = IQR(onset_sensory, na.rm = TRUE)
  )

# function version 
summarize_median_iqr <- function(data, variable) {
  data %>%
    group_by(group) %>%
    summarize(
      median = median(.data[[variable]], na.rm = TRUE),
      IQR = IQR(.data[[variable]], na.rm = TRUE),
      .groups = "drop"
    )
}

# Example 1: Sensory block onset time
summarize_median_iqr(supraclavicular, "onset_sensory")

# Example 2: Pain score at rest
summarize_median_iqr(supraclavicular, "vps_rest")


