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
      dashboardHeader(title = "Open Access Uptake"),
      dashboardSidebar(sidebarMenu(
        menuItem(
          "Scatterplot",
          tabName = "scatter",
          icon = icon("dashboard")
        ),
        menuItem("Box Plot", tabName = "boxplot", icon = icon("dashboard"))
      ), collapsed = TRUE),
      dashboardBody(tabItems(
        # Scatterplot
        tabItem(tabName = "scatter",
                fluidRow(
                  box(
                    title = "Choose and highlight",
                    selectInput(
                      "sector",
                      "Choose a sector:",
                      choices = unique(oa_shares_inst_sector$sector),
                      selected = "Universities"
                    ),
                    mod_select_view_ui("select_view_ui_1"),
                    width = 4
                  ),
                  box(
                    title = "Publication volume vs OA Uptake (2010-18)",
                    mod_scatter_plot_ui("scatter_plot_ui_1"),
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
