# National survey of college graduates analysis

library(tidyverse)
library(ggplot2)

# Load National Survey of College Graduates microdata 
## The public use data files and documentation are available here: https://ncses.nsf.gov/explore-data/microdata/national-survey-college-graduates

nscg_23 <- read.csv("pcg23Public/epcg23.csv")

International_students_by_grad_year <- nscg_23 %>%
  filter( # Filter for those earning degrees between 2012 and 2021
    MRYR >2011, MRYR < 2022,
    # Filter for those who first came on a student visa
    FNVSATP == 3,
    # Filter for most recent degree type being BA, MA, or PhD
    MRDG >0 & MRDG <4,
    # Filter for those receiving their most recent degree in the US
    MRST_TOGA == 099) %>%
  group_by(MRYR, MRDG) %>%
  summarise(Total_grads_still_here = sum(WTSURVY)) %>%
  # Add most recent degree labels
  mutate(
    degree_type = case_when(
      MRDG == 1 ~ "Bachelor's",
      MRDG == 2 ~ "Master's",
      MRDG == 3 ~ "Doctor's",
      TRUE      ~ NA_character_   # anything else becomes NA
    )
  )


# Load IPEDS data 
## This file summarizes all Bachelor's, Master's, and Doctoral degrees awarded in the 50 states plus DC from the 2011-12 through the 2022-23 academic years 

IPEDS_data <- read.csv("DataCenter_GroupStatistics (12)/Statistics.csv") %>%
  mutate(year = 2000 + as.integer(str_extract(Variable, "(?<=\\()[0-9]{2}(?=\\))")),
         degree_type = case_when(
             str_detect(Variable, regex("Bachelor's", ignore_case = TRUE)) ~ "Bachelor's",
             str_detect(Variable, regex("Master's",   ignore_case = TRUE)) ~ "Master's",
             str_detect(Variable, regex("Doctor's",   ignore_case = TRUE)) ~ "Doctor's",
             TRUE ~ NA_character_   # keeps rows that match none of the patterns as NA
             ),
             total_graduates = parse_number(SUM))

# Analyze retention by degree type and by graduation year

## Degree type

Graduatate_retention_by_degree <- left_join(IPEDS_data, International_students_by_grad_year, by = c("year" = "MRYR",
                                                                                                 "degree_type" = "degree_type")) %>%
  filter(year < 2022) %>%
  group_by(degree_type) %>%
  summarise(total_grads = sum(total_graduates),
            still_here = sum(Total_grads_still_here)) %>%
  mutate(retention_rate = still_here/total_grads)

## Overall - All degrees

Graduatate_retention_by_degree %>%
  ungroup() %>%
  summarise(total_grads = sum(total_grads),
            still_here = sum(still_here)) %>%
  mutate(retention_rate = still_here/total_grads)

# Graduation year

Lost_graduates_by_year <- left_join(IPEDS_data, International_students_by_grad_year, by = c("year" = "MRYR",
                                                                                            "degree_type" = "degree_type")) %>%
  filter(year < 2022) %>%
  group_by(year) %>%
  summarise(total_grads = sum(total_graduates),
            still_here = sum(Total_grads_still_here)) %>%
  mutate(retention = still_here/total_grads,
         lost_grads = total_grads - still_here)
