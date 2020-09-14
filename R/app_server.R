#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  r <- reactiveValues()
  observe({
    r$dataset <- oa_shares_inst_sector %>%
      dplyr::filter(sector %in% input$sector)
  })
  callModule(mod_areaplot_is_oa_server, "areaplot_is_oa_ui_1")
  callModule(mod_select_view_server, "select_view_ui_1", session = session, r = r)
  callModule(mod_scatter_plot_server, "scatter_plot_ui_1", session = session, r = r)
  callModule(mod_display_caption_server, "display_caption_ui_1")
  callModule(mod_boxplot_server, "boxplot_ui_1")
}
