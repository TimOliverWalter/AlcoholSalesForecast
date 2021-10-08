body <- function(){
  dashboardBody(
    fluidRow(
      box(
        width = 12,
        plotlyOutput("plot")
      )
    ),
    br(),
    fluidRow(
      box(
        width = 12,
        dataTableOutput("table")
      )
    )
  )
}