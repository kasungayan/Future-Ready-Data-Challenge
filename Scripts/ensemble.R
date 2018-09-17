# Air Liquide : Future Ready Data Challenge
# Ensemble Forecasting script
# Gayan Bandara, June 2018

# This script ensembles the point forecasts produced by ETS(), ARIMA() and ES() functions.

# @input: Energy-forecast-ets.csv, Energy-forecast-autoarima.csv, Energy-forecast-es.csv.
# @output: Kasun-Submission.csv.


# Reading the generated forecsting files.
ets <- read.table("Energy-forecast-ets.csv", header = TRUE)

ARIMA <- read.table("Energy-forecast-autoarima.csv", header = TRUE)

es <- read.table("Energy-forecast-es.csv", header = TRUE)

# Ensembliing the forecasts by weighting the forecasting
# (Based on the forecasting plots, ETS generated more conservative forecasts, therefore, giving more weight for ETS())
final_forecast <- (ets * 0.84 + ARIMA * 0.08 + es * 0.08)


# Writing the final forecasts
write.table(
  final_forecast,
  file = "Kasun-Submission.csv",
  row.names = F,
  col.names = T,
  quote = F
)