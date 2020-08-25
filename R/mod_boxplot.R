#' boxplot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @importFrom plotly plotlyOutput
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_boxplot_ui <- function(id){
  ns <- NS(id)
  
  fluidRow(
      box(
        title = "Highlight institutions",
        selectInput(ns("inst"),
                    "Choose insitutions",
                    choices = select_inst_sector,
                    multiple = TRUE),
        sliderInput(ns("pubyear"), label = "Pick Year Range", 
                    min = 2010, max = 2018, value = c(2010, 2018), sep = ""
        ),
        width = 4
      ),
      box(
        plotly::plotlyOutput(ns("boxplot")), width = 8
      )
  )
}
    
#' boxplot Server Function
#' 
#' @importFrom dplyr filter between group_by summarise mutate
#' @importFrom plotly ggplotly style config layout
#'
#' @noRd 
mod_boxplot_server <- function(input, output, session) {
  ns <- session$ns
  
  output$boxplot <- renderPlotly({
    req(input$pubyear)
    
    boxplot_df <-
      oa_shares_inst_sec_boxplot %>%
      dplyr::filter(between(PUBYEAR, min(input$pubyear), max(input$pubyear))) %>%
      dplyr::group_by(INST_NAME, sec_abbr, sector_cat) %>%
      dplyr::summarise(oa_articles = sum(oa_articles),
                       articles = sum(articles)) %>%
      dplyr::mutate(prop = oa_articles / articles)
    
    if (is.null(input$inst)) {
      p <- boxplot_oa(boxplot_df)
    } else {
      p <- boxplot_oa(boxplot_df,
                      insts = dplyr::filter(boxplot_df, INST_NAME %in% input$inst))
      NULL
    }
    
    p <- plotly::ggplotly(p, tooltip = "text") %>%
      plotly::style(hoverlabel = list(bgcolor = "white"),
                    hoveron = "fill") %>%
      plotly::config(toImageButtonOptions = list(format = "svg")) %>%
      plotly::layout(legend = list(
        orientation = "h",
        x = 0.4,
        y = -0.2
      ))
  })
}
    
## To be copied in the UI
# mod_boxplot_ui("boxplot_ui_1")
    
## To be copied in the server
# callModule(mod_boxplot_server, "boxplot_ui_1")
 
