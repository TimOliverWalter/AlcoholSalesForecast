get_forecast <- function(pred_date, end_date) {
  df <- import_data()
  future_df <- get_future_df(pred_date)
  
  m <- prophet(
    df,
    yearly.seasonality = TRUE,
    weekly.seasonality = FALSE,
    daily.seasonality = FALSE,
    changepoint.prior.scale = 0.5,
    seasonality.prior.scale = 0.1,
    holidays.prior.scale = 0.01,
    seasonality.mode = "multiplicative",
    changepoint.range = 0.8
  )
  
  pred <- predict(m,
                  future_df)
  pred <- pred %>%
    mutate(ds = as.Date(ds,
                        format = "%Y-%m-%d")) %>%
    select(ds,
           yhat,
           yhat_upper,
           yhat_lower)
  
  forecast <- df %>%
    full_join(pred,
              by = "ds")
  
  forecast <- forecast[forecast$ds >= end_date,]
  
  return(forecast)
}