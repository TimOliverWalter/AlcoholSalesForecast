library(shiny)
library(plotly)
library(DT)

shinyUI(fluidPage(
  titlePanel("Forecasting Alcohol Sales"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "pred_date",
        "Prediction period:",
        min = as.Date("2019-02-01", "%Y-%m-%d"),
        max = as.Date("2020-02-01", "%Y-%m-%d"),
        value = as.Date("2019-08-01"),
        timeFormat = "%Y-%m-%d"
      ),
      sliderInput(
        "end_date",
        "Observation period:",
        min = as.Date("1992-01-01", "%Y-%m-%d"),
        max = as.Date("2018-11-01", "%Y-%m-%d"),
        value = as.Date("1992-01-01"),
        timeFormat = "%Y-%m-%d"
      )
    ),
    mainPanel(plotlyOutput("plot"),
              DT::dataTableOutput("table"))
  )
))
