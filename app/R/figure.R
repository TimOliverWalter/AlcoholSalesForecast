get_figure <- function(forecast) {
  fig <- plot_ly(
    forecast,
    x = ~ ds,
    y = ~ y,
    name = "Actual",
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
      xaxis = list(title = "Date"),
      yaxis = list(title = "Sale")#,
      #legend = list(x = 0.01,
      #              y = 1.01)
    )
  
  return(fig)
}