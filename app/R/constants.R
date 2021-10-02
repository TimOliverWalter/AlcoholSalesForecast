import_data <- function() {
  path <- "data/alcohol_sales.csv"
  
  df <- utils::read.csv(path,
                        na.strings = c("null", ".", ""))
  df <- df %>%
    rename(ds = Date,
           y = Sale) %>%
    mutate(ds = as.Date(ds,
                        format = "%Y-%m-%d"))
  
  return(df)
}