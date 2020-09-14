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
        HTML("<p>This dashboard let you explore the development of Open Access (OA) to journal articles from authors affiliated with German universities and non-university research institutions between 2010 - 2018. It serves as interactive supplementary material for: 
                                      <p>Hobert, Anne, Jahn, Najko, Mayr, Philipp, Schmidt, Birgit, & Taubert, Niels. (2020). Open Access Uptake in Germany 2010-18: Adoption in a diverse research landscape. <a href='http://doi.org/10.5281/zenodo.3892951'>http://doi.org/10.5281/zenodo.3892951</a>[Preprint]</p></p>",
                 "<p>This work is based on bibliographic data from the Web of Science database of Clarivate Analytics, Philadelphia, PA, USA, and was supported by the German Federal Ministry of Education and Research within the funding stream “Quantitative research on the science sector”, projects OASE (grant number 01PU17005A) and OAUNI (grant numbers 01PU17023A and 01PU17023B).</p>"),
        width = 12,
        collapsible = TRUE)),
    fluidRow(
    box(title = "OA uptake in Germany (2010-2018)",
        plotly::plotlyOutput(ns("areaplot")), width = 8),
    box(title = NULL,
        radioButtons(
          ns("rel_numbers"),
          "Show",
          choiceValues = c(FALSE, TRUE),
          choiceNames = c("total number of articles, or", "relative proportions."),
          selected = FALSE
        ),
        width = 4)),
    fluidRow(
    box(title = NULL,
        textOutput(ns("caption_area")),
        width = 12))
  )
}
    
#' areaplot_is_oa Server Function
#'
#' @noRd 
mod_areaplot_is_oa_server <- function(input, output, session){
  ns <- session$ns
  
 
  output$areaplot <- renderPlotly({
    req(input$rel_numbers)

    p <- areaplot_is_oa(pubs_oa_year, input$rel_numbers)

    p <- plotly::ggplotly(p, tooltip = "text") %>%
      plotly::style(hoverlabel = list(bgcolor = "white")) %>%
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
 
