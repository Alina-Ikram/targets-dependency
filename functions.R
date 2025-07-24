categorize_variable <- function(data, new_var_name, case_when_expr) {
  new_var_name <- rlang::ensym(new_var_name)
  data <- dplyr::mutate(data, !!new_var_name := !!rlang::enquo(case_when_expr))
  return(data)
}


summarize_by_group <- function(data, group_var, summary_var) {
  group_var <- rlang::ensym(group_var)
  summary_var <- rlang::ensym(summary_var)
  
  data %>%
    dplyr::group_by(!!group_var) %>%
    dplyr::summarize(
      mean = mean(!!summary_var, na.rm = TRUE),
      sd = sd(!!summary_var, na.rm = TRUE),
      .groups = "drop"
    )
}

plot_summary <- function(summary_df, category_var, title = "Summary Plot", y_label = "Mean") {
  category_var <- rlang::ensym(category_var)
  
  ggplot(summary_df, aes(x = !!category_var, y = mean)) +
    geom_col(fill = "lightblue") +
    geom_errorbar(
      aes(ymin = mean - sd, ymax = mean + sd),
      width = 0.2
    ) +
    labs(title = title, x = rlang::as_label(category_var), y = y_label) +
    theme_minimal()
}