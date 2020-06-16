#' Create OA / Overall Scatterplot
#'
#' @param oa_shares_inst_sector data
#'
#' @import ggplot2
#' @importFrom forcats fct_rev fct_reorder
#' @importFrom scales percent_format number_format
#' @importFrom cowplot theme_minimal_grid
#' @return
#' @export
#'
scatterplot_oa <- function(oa_shares_inst_sector) {
  ggplot(oa_shares_inst_sector, aes(x = n_total, y = oa_share, label = INST_NAME)) +
    geom_point(color = "#56b4e9", alpha = .7)  +
    scale_x_log10(labels = scales::number_format(big.mark = ","),
                  expand = expansion(mult = c(0.05, 0.1))) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 5L),
                       expand = expansion(mult = c(0, 0.05)),
                       limits = c(0,1)) +
    geom_smooth(color = "#999999a0", method = "lm") +
    facet_wrap(~ forcats::fct_rev(forcats::fct_reorder(sector, n_total_sec)),
               ncol = 2,
               scales = "free_x") +
    geom_hline(aes(yintercept = median_oa_share),
               colour = "#d55e00", linetype ="dashed", size = 1) +
    geom_vline(aes(xintercept = median_pub_volume),
               colour = "#E69F00", linetype ="dashed", size = 1) +
    labs(x = "Total Articles (logarithmic scale)", y = "OA percentage") +
    theme_minimal_grid() +
    theme(legend.position = "none") +
    # bold facet labels
    theme(strip.text = element_text(face = "bold"))+
    theme(axis.text=element_text(size=10))
}
