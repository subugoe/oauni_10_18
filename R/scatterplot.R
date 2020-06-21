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
scatterplot_oa <- function(oa_shares_inst_sector, insts = NULL) {
  ggplot(oa_shares_inst_sector, aes(x = n_total, y = oa_share,
                                    text = paste("<b>", INST_NAME, "</b>\n OA Share:", round(oa_share * 100, 2), "%\n Publications:", n_total))) +
    geom_point(color = "grey80", alpha = .7, size = 2)  +
    geom_point(data = insts, color = "#56b4e9",  aes(x = n_total, y = oa_share, label = INST_NAME), size = 3) +
    scale_x_log10(labels = scales::number_format(big.mark = ","),
                  expand = expansion(mult = c(0.05, 0.1))) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 5L),
                       expand = expansion(mult = c(0, 0.05)),
                       limits = c(0,1)) +
     geom_smooth(color = "#999999a0", method = "lm") +
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
