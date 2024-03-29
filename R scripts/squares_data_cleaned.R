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

## importing veg_plot data

squares <- sf::read_sf(squares_properties_2023_path)
summary(squares) 

# no QA for squares
# squares <- subset(squares, (as.character(tree_in_fe) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel(test_monads_2023_path)

squares_2 <- squares[!(squares$monad_ref %in% test_monads$Sample),]

squares_2 <- squares_2 %>% filter(!(last_edite=='James.Buckle_NE'))
squares_2 <- squares_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
squares_2 <- squares_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
squares_2 <- squares_2[!grepl('NS', tree_in_feature_2$monad_ref),]

setdiff(squares_2$monad_ref, squares_3$monad_ref)

## assessing numbers

length(unique(squares_2$feature_re))
length(unique(squares_2$monad_ref))

## so we have - 935 squares over 215 monads in total

st_write(squares_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Squares/squares_properties.shp")

# THERE ARE NO RELATED TABLES FOR SQUARES ###


