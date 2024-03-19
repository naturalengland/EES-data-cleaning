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

## importing veg_plot data

stands <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/stands_properties_jan24/Stands.shp")
summary(stands)

# no QA for stands
# stands <- subset(stands, (as.character(tree_in_fe) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

stands_2 <- stands[!(stands$monad_ref %in% test_monads$Sample),]

stands_2 <- stands_2 %>% filter(!(last_edite=='James.Buckle_NE'))
stands_2 <- stands_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
stands_2 <- stands_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
stands_2 <- stands_2[!grepl('NS', tree_in_feature_2$monad_ref),]

## assessing numbers

length(unique(stands_2$feature_re))
length(unique(stands_2$monad_ref))


stands_3 <- stands_2[ , c(4, 9)]
stands_3 <- na.omit(stands_3)
length(unique(stands_3$monad_ref))

## so we have - 1844 stands over 216 monads in total

st_write(stands_3, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/stands_properties.shp")

## below I'm trying to get the fake riparian ids (dummy monads, test monads etc)

fake_stands_ids <- setdiff(stands$stand_id, stands_2$stand_id)

# importing related tables data 
# REMEMBER TO DOWNLOAD 'SURFACES' TABLE
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/stands related tables")
stands.related <- list.files(pattern='stands_jan24')
stands.related_2 <- lapply(stands.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids 

install.packages("qdapRegex") 
library(qdapRegex)

stands.related_2[[1]] <- stands.related_2[[1]][!stands.related_2[[1]]$'Stand ID' %in% fake_stands_ids, ]
stands.related_2[[2]] <- stands.related_2[[2]][!stands.related_2[[2]]$'Stand ID' %in% fake_stands_ids, ]
stands.related_2[[3]] <- stands.related_2[[3]][!stands.related_2[[3]]$'Stand ID' %in% fake_stands_ids, ]
stands.related_2[[4]] <- stands.related_2[[4]][!stands.related_2[[4]]$'Stand ID' %in% fake_stands_ids, ]
stands.related_2[[5]] <- stands.related_2[[5]][!stands.related_2[[5]]$'Stand ID' %in% fake_stands_ids, ]

# now exporting

write.csv(stands.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/component_habitats.csv")
write.csv(stands.related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/dwarf_shrub_age_structure.csv")
write.csv(stands.related_2[[3]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/evidence_of_plastics.csv")
write.csv(stands.related_2[[4]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/roundrat.csv")
write.csv(stands.related_2[[5]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Stands/land_use.csv")
## NEED TO DO THE SURFACES TOO

