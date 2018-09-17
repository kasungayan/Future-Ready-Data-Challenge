# Air Liquide : Future Ready Data Challenge
# ETS Forecasting script
# Gayan Bandara, June 2018

# This script uses the energy consumption values of each customer (including the imputed values)
# From 2015-November to 2017 May (only) and forecast the future values (2017 June - 2018 January)
# However, for some customers the forecasting horizon is a bit different (lesser than 8 months) according to test data.
# This script handles that issue by filtering and only writing approporate forecasts for each customer as requested in the test dataset.

# @input: imputed_timeseries.csv, test-forecast.csv
# @output: Energy-forecast-ets.csv


# Please uncomment the below command, in case you haven't installed the following pakcage in your enviornment.
# install.packages("forecast")

# Loading the required libraries.
# (https://cran.r-project.org/web/packages/forecast/forecast.pdf)
require(forecast)
library(forecast)

# Loading the imputed dataset and the target test dataset.
df <- read.csv("imputed_timeseries.csv", header = TRUE)
df_test <- read.csv("test-forecast.csv", header = TRUE)

# Retreving the unique Ids in training and testing data.
cust_id_train <- unique(df$DP_ID)
cust_id_test <- unique(df_test$ID)

###################ETS#######################################

# Data frames to store the generated forecasts
forecast_vector <- vector()
forecast = data.frame()

# Generating forecasting plots to improve the interpretability of the forecasts.
pdf("ETS_Forecasts.pdf")


# For loop that iterates through the customer ids of the test set and generate forecasts.
for (i in 1:length(cust_id_test)) {
  print(i)
  df_id <- cust_id_test[i]
  
  # Loading the complete training energy consumption values of a customer.
  df_cust_id <- df[df$DP_ID == df_id, ]
  df_volume <- as.numeric(df_cust_id$MOD_VOLUME_CONSUMPTION)
  
  # Use only first 19 data points (2015-November to 2017 May)
  df_volume <- df_volume[1:19]
  
  # Retransforming the original scale before applying the forecasts.
  df_volume <- exp(df_volume)
  
  # Applying ETS function for monthly data (i.e hence the frequency is 12).
  model <- ets(ts(df_volume, frequency = 12))
  forecast_model <- forecast(model, h = 8)
  
  # Generating forecasting plots.
  Title <- paste0("ETS Forecast Customer ID:", i)
  plot(forecast_model, main =  Title)
  
  # Generating point forecasts.
  forecast_values <- as.numeric(forecast_model$mean)
  forecast_values <- append(df_volume, forecast_values)
  
  # Filtering only required forecasts for a given customer (According to test set).
  df_cust_test_id <- df_test[df_test$ID == df_id, ]
  dateNumbers <- df_cust_test_id$dateNumber
  
  forecast_order <- forecast_values[dateNumbers]
  
  if (is.null(forecast_vector)) {
    forecast_vector <- forecast_order
  } else{
    forecast_vector <- append(forecast_vector, forecast_order)
  }
}

# Complete generating the plots.
dev.off()

forecast <- cbind(forecast_vector)

# Writing the generated forecasts
colnames(forecast)[1] <- "MOD-volume-consumption"
write.table(
  forecast,
  file = "Energy-forecast-ets.csv",
  row.names = F,
  col.names = T,
  quote = F
)