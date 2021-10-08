get_future_df <- function(pred_date){
  ds <- seq.Date(from = as.Date("2019-02-01"),
                 to = pred_date,
                 by = "month")
  df <- data.frame(ds)
  
  return(df)
}

rename_fcst <- function(forecast){
  forecast <- forecast %>%
    select(ds,
           y,
           yhat) %>%
    arrange(-row_number()) %>%
    rename(Date = ds,
           Actual = y,
           Forecast = yhat)
  return(forecast)
}