library(shiny)
library(plotly)
library(prophet)
library(tidyverse)

shinyServer(function(input, output) {
    output$forecastPlot <- renderPlotly({
        forecast <- get_forecast()
        
        fig <- plot_ly(
            forecast,
            x = ~ ds,
            y = ~ y,
            name = "Price",
            type = "scatter",
            mode = "lines",
            line = list(color = "rgba(49,130,189,1)")
        )
        
        fig <- fig %>%
            add_trace(
                y = ~ yhat,
                name = "Forecast",
                line = list(color = "rgba(230,0,0,1)")
            )
        
        fig <- fig %>%
            layout(
                title = "Close Price",
                xaxis = list(type = "date", title = "Date"),
                yaxis = list(type = "linear", title = "Close Price")
            )
        
    })
    
})

import_data <- function() {
    path <- "data\\Alcohol_Sales.csv"
    
    df <- read.csv(path,
                   na.strings = c("null", ".", ""))
    df <- df %>% rename(ds = Date,
                        y = Sale) %>%
        mutate(ds = as.Date(ds,
                            format = "%Y-%m-%d"))
    
    return(df)
}

get_forecast <- function() {
    df <- import_data()
    
    split_date <- "2017-12-01"
    train <- df[df$ds <= split_date,]
    test <- df[df$ds > split_date,]
    
    m <- prophet(
        train,
        yearly.seasonality = TRUE,
        weekly.seasonality = FALSE,
        daily.seasonality = FALSE,
        changepoint.prior.scale = 0.5,
        seasonality.prior.scale = 0.1,
        holidays.prior.scale = 0.01,
        seasonality.mode = "multiplicative",
        changepoint.range = 0.01
    )
    
    pred <- predict(m, test)
    pred <- pred %>%
        mutate(ds = as.Date(ds,
                            format = "%Y-%m-%d")) %>%
        select(ds,
               yhat)
    
    forecast <- df %>%
        full_join(pred,
                  by = "ds")
    
    return(forecast)
}
