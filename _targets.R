library(targets)
library(ggplot2)
library(dplyr)
library(medicaldata)
library(visNetwork)

source("functions.R")

list(
  tar_target(
    supraclavicular_data,
    read.csv("data/supraclavicular.csv")
  ),
  
  tar_target(age_cat,
             categorize_variable(
               supraclavicular_data,
               new_var_name = age_category,
               case_when_expr = dplyr::case_when(
                 age < 25 ~ "young adult",
                 age >= 25 & age < 40 ~ "adult",
                 age >= 40 & age < 65 ~ "middle age",
                 age >= 65 ~ "elderly"
               )
             )
  ),
  
  tar_target(bmi_cat,
             categorize_variable(
               supraclavicular_data,
               new_var_name = bmi_category,
               case_when_expr = dplyr::case_when(
                 bmi < 18.5 ~ "underweight",
                 bmi >= 18.5 & bmi < 25 ~ "normal",
                 bmi >= 25 ~ "overweight"
               )
             )
  ),
  
  tar_target(
    bmi_by_age_summary,
    summarize_by_group(age_cat, age_category, bmi)
  ),
  
  tar_target(
    bmi_by_age_plot,
    plot_summary(bmi_by_age_summary, age_category, title = "Mean BMI by Age Group", y_label = "Mean BMI")
  ),
  
  tar_target(
    vps_rest_by_bmi_summary,
    summarize_by_group(bmi_cat, bmi_category, vps_rest)
  )
  
  
)