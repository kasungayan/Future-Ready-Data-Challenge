# Air Liquide : Future Ready Data Challenge
# Feature Normalization script
# Gayan Bandara, June 2018

# This script prepares the features (factorizing, normalzing. log transformations), before fed into Lasso regression to impute the missing records


# @input: forecast-complete.csv
# @output: forecast-impute.csv
# @output varibales: Zipcode (factor), dateNumber (factor), Sales (min-max normalization), Energy consumption (Log transformation)

# Reading the forecast-complete.csv file
df_train <- read.csv("forecast-complete.csv", header = TRUE)

#Removing the 'x' variable as 'dateNumber' variable captures the corresponding time stamp factor.
df_train <- df_train[, -7]

# Factorizing the 'Zipcode'
df_train$ZIPcode <- as.factor(df_train$ZIPcode)

# Normalizing the 'Sales Values'.
df_sales <- df_train$Sum.of.Sales_CR
df_sales_normalized <-
  (df_sales - min(df_sales)) / (max(df_sales) - min(df_sales))

df_train$Sum.of.Sales_CR <- df_sales_normalized

# Log transforming the energy consumption.
df_energy <- df_train$MOD_VOLUME_CONSUMPTION
df_energy <- log(df_energy)

#Assigning to the corresponding variable.
df_train$MOD_VOLUME_CONSUMPTION <- df_energy

# Factorizing the 'dateNumber'.
df_train$dateNumber <- as.factor(df_train$dateNumber)

# Writing the processed file to a new file.
write.table(
  df_train,
  file = "forecast-impute.csv",
  sep = ",",
  row.names = F,
  col.names = T,
  quote = F
)
