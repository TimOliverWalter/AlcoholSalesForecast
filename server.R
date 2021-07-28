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
            y = ~ yhat,
            name = "Price",
            type = "scatter",
            mode = "lines",
            line = list(color = "rgba(49,130,189,1)")
        )
        
    })
    
})

import_data <- function() {
    path <- "data\\eth_data.csv"
    df <- read.csv(path,
                   na.strings = c("null", ".", ""))
    df <- df %>% rename(
        ds = Date,
        y = Open,
        high = High,
        low = Low,
        clsoe = Close,
        adj.close = Adj.Close,
        volume = Volume
    )
    return(df)
}

get_forecast <- function() {
    df <- import_data()
    m <- prophet(df)
    future <- make_future_dataframe(m, periods = 365)
    forecast <- predict(m, future)
    return(forecast)
}
