# Air Liquide : Future Ready Data Challenge
# Feature Augmentation script
# Gayan Bandara, June 2018

# This script combines the Year and the Month columns of the train-dataset.csv.
# The combined column is represented by 'x', which is converted to a factor variable.

# @input: train-dataset.csv
# @output: train-features.csv


# Reading the raw input training file.
df_train <- read.csv("train-dataset.csv", header = TRUE)

# Combining the Year and the Month columns into one column.
df_train$x <-
  paste(df_train$TIMESTAMP...Year, df_train$TIMESTAMP...Month, sep = "-")

# Factorizing the variable.
df_date <- factor(
  df_train$x,
  levels = c(
    "2015-November",
    "2015-December",
    "2016-January",
    "2016-February",
    "2016-March",
    "2016-April",
    "2016-May",
    "2016-June",
    "2016-July",
    "2016-August",
    "2016-September",
    "2016-October",
    "2016-November",
    "2016-December",
    "2017-January",
    "2017-February",
    "2017-March",
    "2017-April",
    "2017-May",
    "2017-June",
    "2017-July",
    "2017-August",
    "2017-September",
    "2017-October",
    "2017-November",
    "2017-December",
    "2018-January"
  )
)


# Converting the factors as integers.
df_date <- as.integer(df_date)
df_train$dateNumber <- cbind(df_date)

# Writing the processed file to a new file.
write.table(
  df_train,
  file = "train-features.csv",
  sep = ",",
  row.names = F,
  col.names = T,
  quote = F
)