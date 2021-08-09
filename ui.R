library(shiny)
library(plotly)

shinyUI(fluidPage(
  titlePanel("Forecasting Alcohol Sales"),
  mainPanel(plotlyOutput("forecastPlot"))
))
