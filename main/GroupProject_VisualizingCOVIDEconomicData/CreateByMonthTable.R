#library(tidyverse)
covid_fci <- readxl::read_xlsx("data/covid-fci-data.xlsx",2)
#Convert Categorical Variables to factors
covid_fci$`Income Level` <- as.factor(covid_fci$`Income Level`)
covid_fci$`Authority` <- as.factor(covid_fci$`Authority`)
covid_fci$`Modification of Parent Measure` <- as.factor(covid_fci$`Modification of Parent Measure`)
covid_fci$`Parent Measure` <- as.factor(covid_fci$`Parent Measure`)
covid_fci$`Level 1 policy measures` <- as.factor(covid_fci$`Level 1 policy measures`)
covid_fci$`Level 2 policy measures` <- as.factor(covid_fci$`Level 2 policy measures`)
covid_fci$`Level 3 policy measures` <- as.factor(covid_fci$`Level 3 policy measures`)
covid_fci$isLv3 <- (covid_fci$`Level 3 policy measures` != 'Blank')
covid_fci$isLv2 <- (covid_fci$`Level 2 policy measures` != 'Blank' && !covid_fci$isLv3)
covid_fci$isLv1 <- (covid_fci$`Level 1 policy measures` != 'Blank' && !covid_fci$isLv2 && !covid_fci$isLv3)


covid_pol_cat_c_m <- covid_fci %>%
  mutate(
    Month = format(Date, format="%m"),
  ) %>%
  group_by(`Country Name`,`Month`,`Level 1 policy measures`) %>%
  summarize(n(), .groups = "drop") %>%
  select(`Country Name`,`Month`,`Level 1 policy measures`,`n()`) %>%
  pivot_wider(names_from=`Level 1 policy measures`,values_from=`n()`)

covid_pol_cat_c_m[is.na(covid_pol_cat_c_m)] <- 0

write_csv(covid_pol_cat_c_m,"data/covid-pol-count-country-month.csv")
