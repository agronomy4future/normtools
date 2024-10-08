% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normtools.R
\name{normtools}
\alias{normtools}
\title{Normalization Methods for Data Scaling}
\usage{
normtools(df, env_cols, yield_cols, method = 1)
}
\arguments{
\item{df}{A data frame containing the data to normalize.}

\item{env_cols}{A character vector specifying the environmental columns used for grouping during normalization.}

\item{yield_cols}{A character vector specifying the yield columns to normalize.}

\item{method}{An integer or string specifying the normalization method. It can be either:
\describe{
\item{1}{z-test: Normalization by z-score, subtracting the mean and dividing by the standard deviation.}
\item{2}{Robust scaling: Normalization by subtracting the median and dividing by the interquartile range (IQR).}
\item{3}{Min-max scaling: Normalization by rescaling the values to a range.}
\item{4}{Log transformation: Normalization using the log transformation with a shift of 1 to handle zero values.}
}}
}
\value{
A data frame with normalized independent variables along with relevant statistical columns (mean, standard deviation, min, max, or quantiles), depending on the normalization method applied.
New columns are added next to the existing columns and named according to the normalization type, such as \code{Normalized_yield_col}, \code{mean_yield_col}, \code{sd_yield_col}, etc.
}
\description{
This function performs normalization on specified independent variables based on various methods, such as z-test, robust scaling, min-max scaling, and log transformation.
}
\examples{
# Example usage with z-test normalization
df= data.frame(
    season= c(2020, 2020, 2021, 2021),
    cultivar= c("A", "B", "A", "B"),
    biomass= c(10, 20, 15, 25),
    nitrogen= c(1.5, 2.5, 1.8, 2.8)
)
result= normtools(df, c("season", "cultivar"), c("biomass", "nitrogen"), method= 1)
}
