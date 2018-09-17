# Air Liquide : Future Ready Data Challenge
# Instance completion script
# Gayan Bandara, June 2018

# This script process the train-features to generate the incomplete records of each customer
# Here, complete records represents the Monthly data for each customer from 2015-November to 2018-January.
# After processing each customer will have records from 2015-November to 2018-January.
# Unknown Energy consumtions of each completed record is denoted by 'NA' values.
# These NA values are later imputed/intraproplated and extraploated using lasso-regression.

# @input: train-features.csv
# @output: forecast-complete.csv (Each customer has records from 2015-November to 2018-January)

# Reading the previously processed train-features.csv file.
df_train <- read.csv("train-features.csv", header = TRUE)

# Removing the unwanted 'Year' and 'Month' columns (i.e 'x' column already aggregated these 2 featues).
df_train <- df_train[, (-7:-8)]

# Reading unique customer records.
df_uniq <- unique(df_train$DP_ID)

# Potential records that should be for a customer.
days_per_customer <- c(1:27)


# List of aggregated Timestamp indices for each customer.
dayIndex <- list()

dayIndex[[1]] <- "2015-November"
dayIndex[[2]] <- "2015-December"
dayIndex[[3]] <- "2016-January"
dayIndex[[4]] <- "2016-February"
dayIndex[[5]] <- "2016-March"
dayIndex[[6]] <- "2016-April"
dayIndex[[7]] <- "2016-May"
dayIndex[[8]] <- "2016-June"
dayIndex[[9]] <- "2016-July"
dayIndex[[10]] <- "2016-August"
dayIndex[[11]] <- "2016-September"
dayIndex[[12]] <- "2016-October"
dayIndex[[13]] <- "2016-November"
dayIndex[[14]] <- "2016-December"
dayIndex[[15]] <- "2017-January"
dayIndex[[16]] <- "2017-February"
dayIndex[[17]] <- "2017-March"
dayIndex[[18]] <- "2017-April"
dayIndex[[19]] <- "2017-May"
dayIndex[[20]] <- "2017-June"
dayIndex[[21]] <- "2017-July"
dayIndex[[22]] <- "2017-August"
dayIndex[[23]] <- "2017-September"
dayIndex[[24]] <- "2017-October"
dayIndex[[25]] <- "2017-November"
dayIndex[[26]] <- "2017-December"
dayIndex[[27]] <- "2018-January"


# Data frames to store complete records.
df_cust_id <- NULL
final_data_frame <- data.frame()

# For loop that takes each customer ID and generate new tuples to fill the incomplete sequence from 2015-November to 2018-January.
# Unknown Energy consumtions of each completed record is denoted by 'NA' values.
# Remaining variable values are completed using the existing variables values (i.e gas, market and etc. is same for the same customer)
# i.e NA values be only generated for 'Energy consumption' column.

for (i in 1:length(df_uniq)) {
  df_id <- df_uniq[i]
  
  df_cust_id <- df_train[df_train$DP_ID == df_id,]
  unmatchingValues <-
    match(days_per_customer, df_cust_id$dateNumber)
  NAindex <- which(is.na(unmatchingValues))
  
  for (k in 1:length(NAindex)) {
    missing_value <- NAindex[k]
    value <- dayIndex[[missing_value]]
    newRow <- data.frame(
      DP_ID = df_cust_id[1, 1],
      gas = df_cust_id[1, 2],
      MARKET_DOMAIN_DESCR = df_cust_id[1, 3],
      MOD_VOLUME_CONSUMPTION = NA,
      Sum.of.Sales_CR = df_cust_id[1, 5],
      ZIPcode = df_cust_id[1, 6],
      x = value,
      dateNumber = missing_value
    )
    df_cust_id <- rbind(df_cust_id, newRow)
  }
  
  df_cust_id <- df_cust_id[order(df_cust_id$dateNumber),]
  
  if (is.null(final_data_frame)) {
    final_data_frame <- df_cust_id
  } else{
    final_data_frame <- rbind(final_data_frame, df_cust_id)
  }
  
}


# Writing the processed completed record file to a new file.
write.table(
  final_data_frame,
  file = "forecast-complete.csv",
  row.names = F,
  sep = ",",
  col.names = T,
  quote = F
)