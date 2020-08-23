#' Box plot
#' 
#' @param oa_shares_inst_sec_boxplot dataset 
#' @param insts institutions that you want to highlight
#'
#' @import ggplot2
#' @importFrom forcats fct_rev fct_reorder
#' @importFrom scales percent_format number_format
#' @importFrom cowplot theme_minimal_hgrid
#' 
#' @return 
#' @export
boxplot_oa <- function(oa_shares_inst_sec_boxplot) {

  ggplot(oa_shares_inst_sec_boxplot, aes(x = fct_rev(fct_reorder(
    sec_abbr, articles
  )), y = prop)) +
    geom_boxplot(
      aes(color = sector_cat),
      varwidth = FALSE,
    #  size = 1,
      notch = TRUE,
      outlier.shape = NA
    ) +
    geom_jitter(alpha = 0.1, width = 0.2,
                aes(
                text = paste("<b>", INST_NAME, "</b>\n OA Share:", round(prop * 100, 2), "%\n Publications:", articles))) +
    scale_y_continuous(
      labels = scales::percent_format(accuracy = 5L),
      expand = expansion(mult = c(0, 0.05)),
      limits = c(0, 1)
    ) +
  scale_color_manual(values = c("#684747", "#f68f46ff", "#a65c85ff", "#051461")) +
    labs(x = "",
         y = "OA percentage",
         color = "")  +
    theme_minimal_hgrid() +
    guides(color = guide_legend(nrow = 2)) +
    theme(legend.position = "top",
          legend.justification = "right") 
}