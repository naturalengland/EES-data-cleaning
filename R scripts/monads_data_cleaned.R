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

monads <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/monads_properties_jan24/Monad.shp")
summary(monads) 

# no QA for monads
# monads <- subset(monads, (as.character(tree_in_fe) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

monads_2 <- monads[!(monads$monad_ref %in% test_monads$Sample),]

monads_3 <- monads_2 %>% filter(!(last_edite=='James.Buckle_NE'))
monads_3 <- monads_3 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
monads_3 <- monads_3 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
monads_3 <- monads_3[!grepl('NS', monads_3$monad_ref),]

## assessing numbers - hard to do as monads exist in here even if they weren't surveyed

length(unique(monads_3$monad_ref))

## so we have - 260 monads

st_write(monads_3, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Monads/monads_properties.shp")

# THERE ARE NO RELATED TABLES FOR SQUARES ###


