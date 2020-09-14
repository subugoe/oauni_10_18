#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    dashboardPage(
      dashboardHeader(title = "Open Access in Germany 2010-18",
                      titleWidth = 270),
      dashboardSidebar(sidebarMenu(
        menuItem(
          "OA uptake in Germany",
          tabName = "uptake"
        ),
        menuItem(
          "OA percentage vs. productivity",
          tabName = "scatter"
        ),
        menuItem("OA variations", tabName = "boxplot")
      ),
      collapsed = FALSE,
      width = 270),
      dashboardBody(tabItems(
        # Uptake (national level)
        tabItem(tabName = "uptake",
                mod_areaplot_is_oa_ui("areaplot_is_oa_ui_1")),
        # Scatterplot
        tabItem(tabName = "scatter",
                fluidRow(
                  box(
                    title = "OA percentage vs. publication volume (2010-18)",
                    mod_scatter_plot_ui("scatter_plot_ui_1"),
                    width = 8
                  ),
                  box(
                    title = NULL,
                    selectInput(
                      "sector",
                      "Pick sector:",
                      choices = unique(oa_shares_inst_sector$sector),
                      selected = "Universities"
                    ),
                    mod_select_view_ui("select_view_ui_1"),
                    width = 4
                  ),
                  box(
                    title = NULL,
                    mod_display_caption_ui("display_caption_ui_1"),
                    width = 8
                  )
                )),
        # Box Plot
        tabItem(
          tabName = "boxplot",
            mod_boxplot_ui("boxplot_ui_1")
      )))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path('www', app_sys('app/www'))
  
  tags$head(favicon(),
            bundle_resources(path = app_sys('app/www'),
                             app_title = 'oadash')
            # Add here other external resources
            # for example, you can add shinyalert::useShinyalert() 
            )
}
