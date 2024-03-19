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

## importing riparian data

riparian <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Riparian properties data jan24/Riparian_Plots.shp")
summary(riparian)

# removing QA
riparian <- subset(riparian, (as.character(riparian_p) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

riparian_2 <- riparian[!(riparian$monad_ref %in% test_monads$Sample),]

riparian_2 <- riparian_2 %>% filter(!(last_edite=='James.Buckle_NE'))
riparian_2 <- riparian_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
riparian_2 <- riparian_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
riparian_2 <- riparian_2[!grepl('NS', riparian_2$monad_ref),]

## assessing numbers

length(unique(riparian_2$feature_re))
length(unique(riparian_2$monad_ref))

## so we have - 244 riparian plots over 113 monads in total

st_write(riparian_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/riparian_properties.shp")

## below I'm trying to get the fake riparian ids (dummy monads, test monads etc)

fake_riparian_ids <- setdiff(riparian$riparian_p, riparian_2$riparian_p)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/riparian related tables")
riparian.related <- list.files(pattern='riparian_jan24')
riparian.related_2 <- lapply(riparian.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids

install.packages("qdapRegex")
library(qdapRegex)

riparian.related_2[[1]] <- riparian.related_2[[1]][!riparian.related_2[[1]]$'Riparian plot ID' %in% fake_riparian_ids, ]
riparian.related_2[[2]] <- riparian.related_2[[2]][!riparian.related_2[[2]]$'Riparian plot ID' %in% fake_riparian_ids, ]
riparian.related_2[[3]] <- riparian.related_2[[3]][!riparian.related_2[[3]]$'Riparian plot ID' %in% fake_riparian_ids, ]
riparian.related_2[[4]] <- riparian.related_2[[4]][!riparian.related_2[[4]]$'Riparian plot ID' %in% fake_riparian_ids, ]

# now exporting

write.csv(riparian.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/invasive_species.csv")
write.csv(riparian.related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/modification_management.csv")
write.csv(riparian.related_2[[3]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/sward_structure.csv")
write.csv(riparian.related_2[[4]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/vascular_plants.csv")


