body <- function(){
  dashboardBody(
    fluidRow(
      box(
        width = 12,
        plotlyOutput("plot") %>%
          withSpinner()
      )
    ),
    br(),
    fluidRow(
      box(
        width = 12,
        dataTableOutput("table") %>%
          withSpinner()
      )
    )
  ) 
}