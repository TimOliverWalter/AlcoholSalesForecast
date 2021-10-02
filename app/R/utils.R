get_future_df <- function(pred_date){
  ds <- seq.Date(from = as.Date("2019-02-01"),
                 to = pred_date,
                 by = "month")
  df <- data.frame(ds)
  return(df)
}