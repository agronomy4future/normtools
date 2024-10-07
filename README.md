<!-- README.md is generated from README.Rmd. Please edit that file -->

# normtools

<!-- badges: start -->
<!-- badges: end -->

The goal of normtools package is to normalize data using various methods for data scaling

□ Code summary: https://github.com/agronomy4future/r_code/blob/main/Normalization_Methods_for_Data_Scaling.ipynb

□ Code explained: https://agronomy4future.org/archives/23225

## Installation

You can install the development version of fwrmodel like so:

Before installing, please download Rtools (https://cran.r-project.org/bin/windows/Rtools)

``` r
if(!require(remotes)) install.packages("remotes")
if (!requireNamespace("normtools", quietly = TRUE)) {
  remotes::install_github("agronomy4future/normtools")
}
library(remotes)
library(normtools)
```

## Example

This is a basic code to normalize data using various methods

``` r
# Using method=1 for Z-test normalization
z_test= normtools(df, c("Env1", "Env2",""), c("y1","y1",""), 
                  method= 1) # 1 or "z_test"

# Using method=2 for Robust Scaling
robust_scaling= normtools(df, c("Env1", "Env2",""), c("y1","y1",""), 
                          method= "2") # 2 or "robust_scaling"

# Using method=3 for Min-Max Scaling
min_max= normtools(df, c("Env1", "Env2",""), c("y1","y1",""), 
                   method= 3) # 3 or "min_max_saling"

# Using method=4 for Log Transformation
log_transformation= normtools(df, c("Env1", "Env2",""), c("y1","y1",""), 
                              method= 4) # 4 or "log_transformation"
```

## Let’s practice with actual dataset

``` r
# to uplaod data
if(!require(readr)) install.packages("readr")
library(readr)
github="https://raw.githubusercontent.com/agronomy4future/raw_data_practice/main/biomass_N_P.csv"
df= data.frame(read_csv(url(github), show_col_types=FALSE))

head(df,5)
  season cultivar treatment rep biomass nitrogen phosphorus
1   2022      cv1        N0   1    9.16     1.23       0.41
2   2022      cv1        N0   2   13.06     1.49       0.45
3   2022      cv1        N0   3    8.40     1.18       0.31
4   2022      cv1        N0   4   11.97     1.42       0.48
5   2022      cv1        N1   1   24.90     1.77       0.49
.
.
.

# to normalize using Z-test
z_test= normtools(df, c("season", "cultivar"), c("biomass","nitrogen","phosphorus"), 
                  method= 1) # 1 or "z_test"

head(z_test,5)
  season cultivar treatment   rep biomass nitrogen phosphorus Normalized_biomass mean_biomass sd_biomass
  <fct>  <fct>    <chr>     <dbl>   <dbl>    <dbl>      <dbl>              <dbl>        <dbl>      <dbl>
1 2022   cv1      N0            1    9.16     1.23       0.41             -1.62          32.0       14.1
2 2022   cv1      N0            2   13.1      1.49       0.45             -1.34          32.0       14.1
3 2022   cv1      N0            3    8.4      1.18       0.31             -1.67          32.0       14.1
4 2022   cv1      N0            4   12.0      1.42       0.48             -1.42          32.0       14.1
5 2022   cv1      N1            1   24.9      1.77       0.49             -0.505         32.0       14.1
# ℹ 6 more variables: Normalized_nitrogen <dbl>, mean_nitrogen <dbl>, sd_nitrogen <dbl>,
#   Normalized_phosphorus <dbl>, mean_phosphorus <dbl>, sd_phosphorus <dbl>
.
.
.

# to normalize using Robust Scaling
robust_scaling= normtools(df, c("season", "cultivar"), c("biomass","nitrogen","phosphorus"), 
                          method= 2) # 2 or "robust_scaling"

head(robust_scaling,5)
  season cultivar treatment   rep biomass nitrogen phosphorus Normalized_biomass quantile_25_biomass
  <fct>  <fct>    <chr>     <dbl>   <dbl>    <dbl>      <dbl>              <dbl>               <dbl>
1 2022   cv1      N0            1    9.16     1.23       0.41             -1.25                 24.4
2 2022   cv1      N0            2   13.1      1.49       0.45             -1.05                 24.4
3 2022   cv1      N0            3    8.4      1.18       0.31             -1.29                 24.4
4 2022   cv1      N0            4   12.0      1.42       0.48             -1.11                 24.4
5 2022   cv1      N1            1   24.9      1.77       0.49             -0.441                24.4
# ℹ 7 more variables: quantile_75_biomass <dbl>, Normalized_nitrogen <dbl>, quantile_25_nitrogen <dbl>,
#   quantile_75_nitrogen <dbl>, Normalized_phosphorus <dbl>, quantile_25_phosphorus <dbl>,
#   quantile_75_phosphorus <dbl>
.
.
.

# to normalize using Min-Max Scaling
min_max_scaling= normtools(df, c("season", "cultivar"), c("biomass","nitrogen","phosphorus"), 
                           method= 3) # 3 or "min_max_saling"

head(min_max_scaling,5)
  season cultivar treatment   rep biomass nitrogen phosphorus Normalized_biomass min_biomass max_biomass
  <fct>  <fct>    <chr>     <dbl>   <dbl>    <dbl>      <dbl>              <dbl>       <dbl>       <dbl>
1 2022   cv1      N0            1    9.16     1.23       0.41             0.0172         8.4        52.5
2 2022   cv1      N0            2   13.1      1.49       0.45             0.106          8.4        52.5
3 2022   cv1      N0            3    8.4      1.18       0.31             0              8.4        52.5
4 2022   cv1      N0            4   12.0      1.42       0.48             0.0810         8.4        52.5
5 2022   cv1      N1            1   24.9      1.77       0.49             0.374          8.4        52.5
# ℹ 6 more variables: Normalized_nitrogen <dbl>, min_nitrogen <dbl>, max_nitrogen <dbl>,
#   Normalized_phosphorus <dbl>, min_phosphorus <dbl>, max_phosphorus <dbl>
.
.
.

# to normalize using Log Transformation
log_transformation= normtools(df, c("season", "cultivar"), c("biomass","nitrogen","phosphorus"), 
                              method= 4) # 4 or "log_transformation"

head(log_transformation,5)
  season cultivar treatment   rep biomass nitrogen phosphorus Normalized_biomass Normalized_nitrogen
  <fct>  <fct>    <chr>     <dbl>   <dbl>    <dbl>      <dbl>              <dbl>               <dbl>
1 2022   cv1      N0            1    9.16     1.23       0.41              1.01                0.348
2 2022   cv1      N0            2   13.1      1.49       0.45              1.15                0.396
3 2022   cv1      N0            3    8.4      1.18       0.31              0.973               0.338
4 2022   cv1      N0            4   12.0      1.42       0.48              1.11                0.384
5 2022   cv1      N1            1   24.9      1.77       0.49              1.41                0.442
# ℹ 1 more variable: Normalized_phosphorus <dbl>
.
.
.
```
