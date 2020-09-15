#' sector_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @importFrom reactable reactableOutput renderReactable
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sector_table_ui <- function(id){
  ns <- NS(id)
  
  fluidPage(fluidRow(
    tabBox(title = "OA summaries per sector (2010-18)",
        tabPanel("Overview sectors", 
                 reactableOutput(ns("s2all"))),
        tabPanel("Universities", 
                 reactableOutput(ns("s2uni"))),
        tabPanel("Helmholtz Association", 
                 reactableOutput(ns("s2helmholtz"))),
        tabPanel("Max Planck Society", 
                 reactableOutput(ns("s2mpg"))),
        tabPanel("Leibniz Society", 
                 reactableOutput(ns("s2leibniz"))),
        tabPanel("Government Research Agencies", 
                 reactableOutput(ns("s2gov"))),
        tabPanel("Fraunhofer Society", 
                 reactableOutput(ns("fraunhofer"))),
        width = 12
  ))
  )
}
    
#' sector_table Server Function
#'
#' @noRd 
mod_sector_table_server <- function(input, output, session){
  ns <- session$ns
  output$s2all <- renderReactable({
    s2_react_table(s2_all, all = TRUE)
  })
  output$s2uni <- renderReactable({
    s2_react_table(s2_uni)
  })
  output$s2helmholtz <- renderReactable({
    s2_react_table(s2_helmholtz)
  })
  output$s2mpg <- renderReactable({
    s2_react_table(s2_mpg)
  })
  output$s2leibniz <- renderReactable({
    s2_react_table(s2_leibniz)
  })
  output$s2gov <- renderReactable({
    s2_react_table(s2_gra)
  })
  output$fraunhofer <- renderReactable({
    s2_react_table(s2_fraunhofer)
  })
  
}
    
## To be copied in the UI
# mod_sector_table_ui("sector_table_ui_1")
    
## To be copied in the server
# callModule(mod_sector_table_server, "sector_table_ui_1")
 