## code to prepare `oa_shares_inst_sector` dataset goes here

tt <- readr::read_csv("data-raw/fig_scatter.csv")

oa_shares_inst_sector_stats <- tt %>% 
  dplyr::filter(n_total >= 100) %>% 
  dplyr::group_by(sector) %>% 
  dplyr::summarise(mean_oa_share = mean(oa_share), 
            median_oa_share = median(oa_share),
            mean_pub_volume = mean(n_total),
            median_pub_volume = median(n_total),
            sd_oa_share = sd(oa_share),
            sd_pub_volume = sd(n_total)
  )

oa_shares_inst_sector <- oa_shares_inst_sector %>%
  dplyr::filter(n_total >= 100) %>%
  dplyr::left_join(oa_shares_inst_sector_stats, by = "sector")

usethis::use_data(oa_shares_inst_sector, overwrite = TRUE)
