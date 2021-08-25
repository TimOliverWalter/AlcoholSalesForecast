library(shiny)
library(plotly)
library(prophet)
library(dplyr)
library(DT)

shinyServer(function(input, output) {
    forecast <- reactive({
        forecast <- get_forecast(pred_date = input$pred_date,
                                 end_date = input$end_date)
        
        
    })
    
    output$plot <- renderPlotly({
        fore <- forecast()
        get_figure(forecast = fore)
    })
    
    output$table <- DT::renderDataTable({
        forecast()
    })
    
})

import_data <- function() {
    path <- "data\\alcohol_sales.csv"
    
    df <- read.csv(path,
                   na.strings = c("null", ".", ""))
    df <- df %>%
        rename(ds = Date,
               y = Sale) %>%
        mutate(ds = as.Date(ds,
                            format = "%Y-%m-%d"))
    
    return(df)
}

get_forecast <- function(pred_date, end_date) {
    df <- import_data()
    
    ds <- seq.Date(from = as.Date("2019-02-01"),
                   to = pred_date,
                   by = "month")
    
    future_dataframe <- data.frame(ds)
    
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
    
    pred <- predict(m, future_dataframe)
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
    
    forecast <- forecast[forecast$ds >= end_date, ]
    
    return(forecast)
}

get_figure <- function(forecast) {
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
        add_trace(
            y = ~ yhat_upper,
            line = list(color = "rgba(230,0,0,0)"),
            showlegend = FALSE
        )
    
    fig <- fig %>%
        add_trace(
            y = ~ yhat_lower,
            fill = "tonexty",
            fillcolor = "rgba(230,0,0,0.4)",
            line = list(color = "rgba(230,0,0,0)"),
            name = "Confidence interval"
        )
    
    fig <- fig %>%
        layout(
            #title = "Alcohol sales forecast",
            xaxis = list(type = "date",
                         title = "Date"),
            yaxis = list(type = "linear",
                         title = "Sale"),
            legend = list(x = 0.01, y = 1.01)
        )
    
    return(fig)
}
