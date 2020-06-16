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
    h2("Open-Access-Anteil und Publikationsaufkommen im Vergleich"),
    plotly::plotlyOutput(ns("plot"))
  )
}
    
#' scatter Server Function
#'
#' @noRd 
mod_scatter_server <- function(input, output, session){
  ns <- session$ns
  p <- scatterplot_oa(oa_shares_inst_sector)
  output$plot <- plotly::renderPlotly({
    plotly::ggplotly(p)
  })
 
}
    
## To be copied in the UI
# mod_scatter_ui("scatter_ui_1")
    
## To be copied in the server
# callModule(mod_scatter_server, "scatter_ui_1")
 
