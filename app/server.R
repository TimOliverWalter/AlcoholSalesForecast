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
        forecast <- rename_fcst(forecast=forecast)
        
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




