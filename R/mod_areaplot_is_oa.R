#' areaplot_is_oa UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @importFrom plotly plotlyOutput
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_areaplot_is_oa_ui <- function(id){
  ns <- NS(id)
  fluidPage(fluidRow(
    box(title = "Open Access uptake in Germany 2010-2018: Interactive Supplement",
        htmlOutput(ns("about")), width = 12),
    box(title = "OA uptake in Germany (2010-2018)",
        plotly::plotlyOutput(ns("areaplot")), width = 12),
    box(title = NULL,
        radioButtons(
          ns("rel_numbers"),
          "Display figure containing either",
          choiceValues = c(FALSE, TRUE),
          choiceNames = c("total number of articles, or", "relative proportions."),
          selected = FALSE
        ),
        width = 12),
    box(title = NULL,
        textOutput(ns("caption_area")),
        width = 12)
  ))
}
    
#' areaplot_is_oa Server Function
#'
#' @noRd 
mod_areaplot_is_oa_server <- function(input, output, session){
  ns <- session$ns
  
  output$about <- renderUI(HTML(paste("This dashboard illustrates the development of Open Access (OA) to journal articles from authors affiliated with German universities and non-university research institutions in the period 2010 - 2018. It serves as interactive supplementary material for a study performed in the first half of 2020 which was submitted to Scientometrics. A preprint is available on <a href='https://zenodo.org/record/3892951'>Zenodo</a>.",
                                   "The development of the OA uptake is analysed for the different research sectors in Germany (universities, non-university research institutes of the Helmholtz Association, Fraunhofer Society, Max Planck Society, Leibniz Association, and government research agencies). Beyond determining the overall share of openly available articles, a systematic classification of distinct categories of OA publishing allows to identify different patterns of adoption to OA.",
                                   sep = "<br/>")))
  
  output$areaplot <- renderPlotly({
    req(input$rel_numbers)

    p <- areaplot_is_oa(pubs_oa_year, input$rel_numbers)

    p <- plotly::ggplotly(p, tooltip = "text") %>%
      plotly::style(hoverlabel = list(bgcolor = "white"),
                    hoveron = "y") %>%
      plotly::config(toImageButtonOptions = list(format = "svg")) %>%
      plotly::layout(legend = list(
        orientation = "h",
        x = 0.4,
        y = -0.4
      ))
  })
  output$caption_area <- renderText({
    # ifelse(input$rel_numbers,
    #        "Open access to journal articles from German research institutions according to Unpaywall. Blue area represents proportion of journal articles with at least one freely available full-text, grey area represents proportion of toll-access articles.",
    #        "Open access to journal articles from German research institutions according to Unpaywall. Blue area represents number of journal articles with at least one freely available full-text, grey area represents number of toll-access articles.")
    #
    req(input$rel_numbers)
    if(input$rel_numbers == FALSE){
      caption_str <- "Open access to journal articles from German research institutions according to Unpaywall. Blue area represents number of journal articles with at least one freely available full-text, grey area represents number of toll-access articles."
    } else {
      caption_str <- "Open access to journal articles from German research institutions according to Unpaywall. Blue area represents proportion of journal articles with at least one freely available full-text, grey area represents proportion of toll-access articles."
    }
  })
}
    
## To be copied in the UI
# mod_areaplot_is_oa_ui("areaplot_is_oa_ui_1")
    
## To be copied in the server
# callModule(mod_areaplot_is_oa_server, "areaplot_is_oa_ui_1")
 
