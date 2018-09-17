# Air Liquide : Future Ready Data Challenge
# Lasso imputing script
# Gayan Bandara, June 2018

# This script imputes the 'NA' values of the Energy consumption of each customer (Based on the incomplete records).
# Lasso-regression is used to impute the 'NA' values, which
# considers the available features (gas, domain, time period, sales, zip code) of each customer.

# @input: forecast-impute.csv
# @output: imputed_timeseries.csv (Ready to forecast)

# Please uncomment the below command, in case you haven't installed the following pakcage in your enviornment.
# install.packages("imputeR")

# Loading the required libraries.
# (https://cran.r-project.org/web/packages/imputeR/imputeR.pdf)
require(imputeR)
library(imputeR)

# Setting the seed value for reproduibility.
set.seed(8888)

# Reading the feauture normalised file.
df <- read.csv("forecast-impute.csv", header = TRUE)

# Factorizing before applying lazo regression.
df$ZIPcode <- as.factor(df$ZIPcode)
df$dateNumber <- as.factor(df$dateNumber)

# Applying lasso regression to impute the values.
# Using both lmFun and lassoC functions as our dataset contains categorical and numeric data.
imputed_data <- impute(df[,-1], lmFun = "lassoR", cFun = "lassoC")

# Assigning and constructing a dataframe with the imputed values.
imputed_data <- imputed_data$imp
DP_ID <- df$DP_ID
df_imputed <- cbind(DP_ID, imputed_data)

# Writing the processed file to a new file.
write.table(
  df_imputed,
  file = "imputed_timeseries.csv",
  sep = ",",
  row.names = F,
  col.names = T,
  quote = F
)
