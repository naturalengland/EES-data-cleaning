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

hedgerow_point <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/hedgerow_point_properties_jan24/Hedgerow_Plot_Point.shp")
summary(hedgerow_point)

# removing QA
hedgerow_point <- subset(hedgerow_point, (as.character(hedgerow_p) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

# hedgerow points have no monad ref - need to bind with hedgerow plot data to get monads
# importing hedgerow plot data
hedgerow_plot <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Hedgerow_Plot_properties_jan_24/Hedgerow_Plots.shp")
# extracting monad ref and hedgerow refs & dropping geometry
hedgerow_plot_stripped <- hedgerow_plot[ , c('monad_ref', 'hedgerow_p')] %>% sf::st_drop_geometry(hedgerow_plot_stripped)
# renaming hedgerow ref to match the hedgerow points ref 
hedgerow_plot_stripped <- dplyr::rename(hedgerow_plot_stripped, hedgerow_1 = hedgerow_p) 
#merging datasets
hedgerow_point <- full_join(hedgerow_point, hedgerow_plot_stripped, by = "hedgerow_1")   

hedgerow_point_2 <- hedgerow_point[!(hedgerow_point $monad_ref %in% test_monads$Sample),]

hedgerow_point_2 <- hedgerow_point_2 %>% filter(!(last_edite=='James.Buckle_NE'))
hedgerow_point_2 <- hedgerow_point_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
hedgerow_point_2 <- hedgerow_point_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
hedgerow_point_2 <- hedgerow_point_2[!grepl('NS', hedgerow_point_2$monad_ref),]

## assessing numbers

length(unique(hedgerow_point_2$feature_re))
length(unique(hedgerow_point_2$monad_ref))

## so we have - 441 hedgerow plots over 160 monads in total

st_write(hedgerow_point_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Hedgerow points/hedgerow_point_properties.shp")

## below I'm trying to get the fake pond_ids (dummy monads, test monads etc)

fake_hedgerow_point_ids <- setdiff(hedgerow_point$hedgerow_p, hedgerow_point_2$hedgerow_p)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/Hedgerow point related tables")
hedgerow_point_related <- list.files(pattern='hedgerow_point_jan24')
hedgerow_point_related_2 <- lapply(hedgerow_point_related, read_excel)

# now i want to remove rows from the related tables which contain fake hedgerow ids

install.packages("qdapRegex")
library(qdapRegex)

hedgerow_point_related_2[[1]] <- hedgerow_point_related_2[[1]][!hedgerow_point_related_2[[1]]$'Hedgerow Plot Point ID' %in% fake_hedgerow_point_ids, ]
#hedgerow_plot_related_2[[2]] <- hedgerow_plot_related_2[[2]][!hedgerow_plot_related_2[[2]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]

# now exporting

write.csv(hedgerow_point_related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Hedgerow points/vascularplants.csv")
#write.csv(hedgerow_plot_related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Hedgerow plots/fencing.csv")
