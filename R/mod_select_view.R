#' select_view UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_select_view_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(ns("inst"), label = "Choose an institution:", choices = NULL, multiple = TRUE),
    plotlyOutput(ns("plot"))
  )
}
    
#' select_view Server Function
#'
#' @noRd 
mod_select_view_server <- function(input, output, session, r){
  ns <- session$ns
  
  observe({
    inst <- r$dataset %>% .$INST_NAME
    updateSelectInput( session, "inst", choices = c(All = "", inst))
  })
  
  data <- reactive({
    if(is.null(input$inst)) {
      return(r$dataset)
    } else {
    r$dataset %>%
      dplyr::filter(`INST_NAME` %in% input$inst) 
    }
    }
  )
 output$plot <- renderPlotly({
   p <- scatterplot_oa(r$dataset, data())
   plotly::ggplotly(p) 
 })
}
    
## To be copied in the UI
# mod_select_view_ui("select_view_ui_1")
    
## To be copied in the server
# callModule(mod_select_view_server, "select_view_ui_1")
 
