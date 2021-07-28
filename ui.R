library(shiny)
library(plotly)

shinyUI(fluidPage(

    titlePanel("Old Faithful Geyser Data"),
    mainPanel(
            plotlyOutput("forecastPlot")
            )
))
