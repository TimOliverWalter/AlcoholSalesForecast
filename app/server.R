df <- import_data()

shinyServer(function(input, output) {
    
    forecast <- reactive({
        get_forecast(pred_date = input$pred_date,
                     end_date = input$end_date)
    })
    
    output$plot <- renderPlotly({
        get_figure(forecast = forecast())
    })
    
    output$table <- renderDataTable({
        forecast <- forecast()
        forecast <- forecast %>%
            select(ds,
                   y,
                   yhat) %>%
            arrange(-row_number()) %>%
            rename(Date = ds,
                   Actual = y,
                   Forecast = yhat)
        
        datatable(
            forecast,
            extensions = "Buttons",
            options = list(
                dom = "Bfrtip",
                buttons = c("csv", "excel", "pdf")
            )
        )
    })
})

get_forecast <- function(pred_date, end_date) {
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


