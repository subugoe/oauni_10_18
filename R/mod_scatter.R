#' scatter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom plotly plotlyOutput renderPlotly
mod_scatter_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(4, 
           selectInput(ns("sect"), "Sector", 
                       choices = unique(oa_shares_inst_sector$sector), 
                       selected = "Universities")
     ),
     column(4, 
            selectInput(ns("inst"), "Institution", 
                        choices = NULL))), 
    fluidRow(
      column(12, tableOutput("sector"))
    )
  )
}
    
#' scatter Server Function
#'
#' @noRd 
mod_scatter_server <- function(input, output, session){
  ns <- session$ns
  sector <- reactive(
    {
      oa_shares_inst_sector[oa_shares_inst_sector$sector %in% input$sector,]
    })
  
  observeEvent(sector(), {
    choices <- unique(sector()$INST_NAME)
    updateSelectInput(session, "inst", choices = choices) 
  })
  renderTable(sector())
}
    
## To be copied in the UI
# mod_scatter_ui("scatter_ui_1")
    
## To be copied in the server
# callModule(mod_scatter_server, "scatter_ui_1")
 
