#' Normalization Methods for Data Scaling
#'
#' This function performs normalization on specified independent variables based on various methods, such as z-test, robust scaling, min-max scaling, and log transformation.
#'
#' @param df A data frame containing the data to normalize.
#' @param env_cols A character vector specifying the environmental columns used for grouping during normalization.
#' @param yield_cols A character vector specifying the yield columns to normalize.
#' @param method An integer or string specifying the normalization method. It can be either:
#' \describe{
#'   \item{1}{z-test: Normalization by z-score, subtracting the mean and dividing by the standard deviation.}
#'   \item{2}{Robust scaling: Normalization by subtracting the median and dividing by the interquartile range (IQR).}
#'   \item{3}{Min-max scaling: Normalization by rescaling the values to a range.}
#'   \item{4}{Log transformation: Normalization using the log transformation with a shift of 1 to handle zero values.}
#' }
#'
#' @return A data frame with normalized independent variables along with relevant statistical columns (mean, standard deviation, min, max, or quantiles), depending on the normalization method applied.
#' New columns are added next to the existing columns and named according to the normalization type, such as `Normalized_yield_col`, `mean_yield_col`, `sd_yield_col`, etc.
#'
#' @export
#'
#' @examples
#' # Example usage with z-test normalization
#' df= data.frame(
#'     season= c(2020, 2020, 2021, 2021),
#'     cultivar= c("A", "B", "A", "B"),
#'     biomass= c(10, 20, 15, 25),
#'     nitrogen= c(1.5, 2.5, 1.8, 2.8)
#' )
#' result= normtools(df, c("season", "cultivar"), c("biomass", "nitrogen"), method= 1)
normtools= function(df, env_cols, yield_cols, method=1) {

  # Ensure the necessary packages are installed and loaded
  if (!requireNamespace("dplyr", quietly=TRUE)) install.packages("dplyr", dependencies=TRUE)
  library(dplyr)

  # Ensure the env_cols columns are treated as factors and yield_cols are numeric
  df[env_cols]= lapply(df[env_cols], as.factor)

  for (yield_col in yield_cols) {
    df[[yield_col]]= as.numeric(df[[yield_col]])
  }

  # Map numeric method values to corresponding normalization types
  if (is.numeric(method)) {
    method= switch(as.character(method),
                   "1" = "z_test",
                   "2" = "robust_scaling",
                   "3" = "min_max_scaling",
                   "4" = "log_transformation",
                   stop("Invalid numeric method specified. Choose 1 for 'z_test', 2 for 'robust_scaling', 3 for 'min_max_scaling', 4 for 'log_transformation'."))
  }

  # Iterate over each yield_col for normalization and reorder columns accordingly
  for (yield_col in yield_cols) {
    df= switch(method,
               z_test= {
                 df= df %>%
                   group_by(across(all_of(env_cols))) %>%
                   mutate(
                     !!paste0("Normalized_", yield_col):= (get(yield_col)-mean(get(yield_col), na.rm=TRUE)) / sd(get(yield_col), na.rm=TRUE),
                     !!paste0("mean_", yield_col):= mean(get(yield_col), na.rm=TRUE),
                     !!paste0("sd_", yield_col):= sd(get(yield_col), na.rm=TRUE)
                   ) %>%
                   ungroup() %>%
                   select(all_of(env_cols), everything(),
                          paste0("Normalized_", yield_col),
                          paste0("mean_", yield_col),
                          paste0("sd_", yield_col))
               },

               min_max_scaling= {
                 df= df %>%
                   group_by(across(all_of(env_cols))) %>%
                   mutate(
                     !!paste0("Normalized_", yield_col):= (get(yield_col)-min(get(yield_col), na.rm=TRUE)) /
                       (max(get(yield_col), na.rm= TRUE) - min(get(yield_col), na.rm=TRUE)),
                     !!paste0("min_", yield_col):= min(get(yield_col), na.rm=TRUE),
                     !!paste0("max_", yield_col):= max(get(yield_col), na.rm=TRUE)
                   ) %>%
                   ungroup() %>%
                   select(all_of(env_cols), everything(),
                          paste0("Normalized_", yield_col),
                          paste0("min_", yield_col),
                          paste0("max_", yield_col))
               },

               robust_scaling= {
                 df= df %>%
                   group_by(across(all_of(env_cols))) %>%
                   mutate(
                     !!paste0("Normalized_", yield_col):= (get(yield_col)-median(get(yield_col), na.rm=TRUE)) /
                       (quantile(get(yield_col), 0.75, na.rm= TRUE) -
                          quantile(get(yield_col), 0.25, na.rm= TRUE)),
                     !!paste0("quantile_25_", yield_col):= quantile(get(yield_col), 0.25, na.rm=TRUE),
                     !!paste0("quantile_75_", yield_col):= quantile(get(yield_col), 0.75, na.rm=TRUE)
                   ) %>%
                   ungroup() %>%
                   select(all_of(env_cols), everything(),
                          paste0("Normalized_", yield_col),
                          paste0("quantile_25_", yield_col),
                          paste0("quantile_75_", yield_col))
               },

               log_transformation = {
                 df= df %>%
                   group_by(across(all_of(env_cols))) %>%
                   mutate(!!paste0("Normalized_", yield_col):= log10(get(yield_col) + 1))  # Adding 1 to avoid log(0)
                 df= df %>%
                   ungroup() %>%
                   select(all_of(env_cols), everything(),
                          paste0("Normalized_", yield_col))
               },

               stop("Invalid method specified. Choose from 'z_test', 'min_max_scaling', 'robust_scaling', or 'log_transformation'")
    )
  }

  return(df)
}
