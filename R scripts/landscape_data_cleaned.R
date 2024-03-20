# required packages installation
if(!require(pacman)) install.packages("pacman")
 
pacman::p_load(
  sf, 
  sp, 
  dplyr, 
  ggplot2,
  ggpubr,
  readxl, 
  tidyverse,
  terra,
  rgeos,
  rgdal,
  plyr
)

# Set the below to your own local file source
source("C:/Users/m1011479/OneDrive - Defra/Documents/R - Analysis of sample/summary_stats_config_local_JJ.R")

## QA explore

## importing HR Ponds Properties data

landscape <- sf::read_sf(landscape_properties_2023_path)
summary(landscape)

## no QA id for landscape - need to investigate more
#landscape_no_QA <- subset(landscape, (as.character(landscape_id) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel(test_monads_2023_path)

landscape_2 <- landscape[!(landscape$monad_ref %in% test_monads$Sample),]

landscape_2 <- landscape_2 %>% filter(!(last_edite=='James.Buckle_NE'))
landscape_2 <- landscape_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
landscape_2 <- landscape_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
landscape_2 <- landscape_2[!grepl('NS', landscape_2$monad_ref),]

## assessing numbers

length(unique(landscape_2$feature_re))
length(unique(landscape_2$monad_ref))

## so we have - 1233 squares over 210 monads in total

st_write(landscape_2, "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/landscape_properties.shp")

## below I'm trying to get the fake pond_ids (dummy monads, test monads etc)

fake_landscape_ids <- setdiff(landscape$landscape_, landscape_2$landscape_)

# importing related tables data 
library(readxl)
setwd("landscape_related_2023_filepath")
landscape.related <- list.files(pattern='landscape_jan24')
landscape.related_2 <- lapply(landscape.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids

install.packages("qdapRegex")
library(qdapRegex)

landscape.related_2[[1]] <- landscape.related_2[[1]][!landscape.related_2[[1]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[2]] <- landscape.related_2[[2]][!landscape.related_2[[2]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[3]] <- landscape.related_2[[3]][!landscape.related_2[[3]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[4]] <- landscape.related_2[[4]][!landscape.related_2[[4]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[5]] <- landscape.related_2[[5]][!landscape.related_2[[5]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[6]] <- landscape.related_2[[6]][!landscape.related_2[[6]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[7]] <- landscape.related_2[[7]][!landscape.related_2[[7]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[8]] <- landscape.related_2[[8]][!landscape.related_2[[8]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[9]] <- landscape.related_2[[9]][!landscape.related_2[[9]]$'Landscape survey ID' %in% fake_landscape_ids, ]
landscape.related_2[[10]] <- landscape.related_2[[10]][!landscape.related_2[[10]]$'Landscape survey ID' %in% fake_landscape_ids, ]

# now exporting

write.csv(landscape.related_2[[1]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/boundary_trees.csv")
write.csv(landscape.related_2[[2]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/field_boundary.csv")
write.csv(landscape.related_2[[3]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/historic_feature.csv")
write.csv(landscape.related_2[[4]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/infrastructure_renewables.csv")
write.csv(landscape.related_2[[5]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/landform.csv")
write.csv(landscape.related_2[[6]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/land_use.csv")
write.csv(landscape.related_2[[7]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/natural_noise.csv")
write.csv(landscape.related_2[[8]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/pressure_of_change.csv")
write.csv(landscape.related_2[[9]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/settlement_development.csv")
write.csv(landscape.related_2[[10]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Landscape/water.csv")

