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
mod_boxplot_ui <- function(id) {
  ns <- NS(id)
  fluidPage(fluidRow(
    box(title = "OA Uptake across sectors",
      plotly::plotlyOutput(ns("boxplot")), width = 8),
    box(
      title = "Benchmark OA uptake",
      selectInput(
        ns("inst"),
        "German research institutions",
        choices = c("Select ..." = "", select_inst_sector),
        multiple = TRUE,
        selected = "Select ..."
      ),
      sliderInput(
        ns("pubyear"),
        label = "Publication period",
        min = 2010,
        max = 2018,
        value = c(2010, 2018),
        sep = ""
      ),
      width = 4
    )
  ))
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
        y = -0.4
      ))
  })
}

## To be copied in the UI
# mod_boxplot_ui("boxplot_ui_1")

## To be copied in the server
# callModule(mod_boxplot_server, "boxplot_ui_1")
