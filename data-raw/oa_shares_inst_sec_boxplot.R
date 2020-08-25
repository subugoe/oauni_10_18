## code to prepare boxplot dataset goes here
library(dplyr)
library(readr)

pubs_cat <-
  readr::read_csv("data-raw/pubs_cat.csv", col_types = "dccdcclc")
pubs_cat <- pubs_cat %>%
  mutate(
    sec_abbr = case_when(
      sector == "Hochschulen" ~ "UNI",
      sector == "Helmholtz-Gemeinschaft" ~ "HGF",
      sector == "Max-Planck-Gesellschaft" ~ "MPS",
      sector == "Leibniz-Gemeinschaft" ~ "WGL",
      sector == "Fraunhofer-Gesellschaft" ~ "FhS",
      sector == "Ressortforschung" ~ "GRA"
    ),
    sector = case_when(
      sector == "Hochschulen" ~ "Universities",
      sector == "Helmholtz-Gemeinschaft" ~ "Helmholtz Association",
      sector == "Max-Planck-Gesellschaft" ~ "Max Planck Society",
      sector == "Leibniz-Gemeinschaft" ~ "Leibniz Association",
      sector == "Fraunhofer-Gesellschaft" ~ "Fraunhofer Society",
      sector == "Ressortforschung" ~ "Government Research\n Agencies"
    ),
    oa_category = factor(
      oa_category,
      levels = c(
        "full_oa_journal",
        "other_oa_journal",
        "opendoar_inst",
        "opendoar_subject",
        "opendoar_other",
        "other_repo",
        "not_oa"
      )
    )
  )

# Exlcude institutions from university sector which are not listed in official statistics

excl_from_analysis <-
  readr::read_csv("data-raw/exclude_from_analysis.csv")
pubs_cat <- pubs_cat %>%
  anti_join(excl_from_analysis, by = c("INST_NAME" = "Universitäten"))

## exclusion for inst_level analysis
exclude_from_inst_analysis <-
  readr::read_csv("data-raw/exclude_from_inst_level_analysis.csv")

pubs_cat <- pubs_cat %>%
  anti_join(exclude_from_inst_analysis, by = c("INST_NAME" = "NAME"))

oa_inst_sec <- pubs_cat %>%
  filter(oa_category != "not_oa") %>%
  group_by(PUBYEAR, INST_NAME, sector, sec_abbr) %>%
  summarise(oa_articles = n_distinct(PK_ITEMS))
all_inst_sec <-  pubs_cat %>%
  group_by(PUBYEAR, INST_NAME, sector, sec_abbr) %>%
  summarise(articles = n_distinct(PK_ITEMS))
oa_shares_inst_sec_boxplot <-
  inner_join(oa_inst_sec, all_inst_sec)  %>%
  mutate(prop = oa_articles / articles) %>%
  mutate(sector_cat = case_when(
    sec_abbr == "UNI" ~ "Universities",
    sec_abbr %in% c("MPS", "HGF") ~ "Research-oriented",
    sec_abbr == "WGL" ~ "Diverse missions",
    sec_abbr %in% c("FhS", "GRA") ~ "Practise-oriented"
  )
) %>%
  mutate(sector_cat = factor(
    sector_cat,
    levels = c(
      "Universities",
      "Research-oriented",
      "Diverse missions",
      "Practise-oriented"
    )
  ))
# institutions with less than 100 publications
inst_to_drop <- oa_shares_inst_sec_boxplot %>% 
  group_by(INST_NAME) %>% 
  summarise(n = sum(articles)) %>% 
  filter(n < 100) %>% 
  pull(INST_NAME)

oa_shares_inst_sec_boxplot <- oa_shares_inst_sec_boxplot %>% 
  filter(!INST_NAME %in% inst_to_drop) %>%
  ungroup()

usethis::use_data(oa_shares_inst_sec_boxplot, overwrite = TRUE)
