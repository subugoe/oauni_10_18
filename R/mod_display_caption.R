#' display_caption UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_display_caption_ui <- function(id){
  ns <- NS(id)
  tagList(
    textOutput(ns("caption"))
  )
}
    
#' display_caption Server Function
#'
#' @noRd 
mod_display_caption_server <- function(input, output, session){
  ns <- session$ns
  output$caption <- renderText({ 
    "OA percentages and publication output of German research institutions with at least 100 publications in the observed period from 2010 until 2018, grouped by sectors. Solid gray lines are obtained by linear regression within the sector, shaded gray areas are pointwise symmetric 95% t-distribution confidence bands. Dashed lines represent the median values of the OA percentage (red) and the publication output (orange) of the sectors. Specific institutions may be highlighted for the chosen sector." 
  })
}
    
## To be copied in the UI
# mod_display_caption_ui("display_caption_ui_1")
    
## To be copied in the server
# callModule(mod_display_caption_server, "display_caption_ui_1")
 
