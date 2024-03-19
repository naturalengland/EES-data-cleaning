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

tree_in_feature <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/tree_in_feature_properties/Tree_in_Feature.shp")
summary(tree_in_feature)

# no QA for tree in feature
# tree_in_feature <- subset(tree_in_feature, (as.character(tree_in_fe) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

tree_in_feature_2 <- tree_in_feature[!(tree_in_feature$monad_ref %in% test_monads$Sample),]

tree_in_feature_2 <- tree_in_feature_2 %>% filter(!(last_edite=='NCEAAdmin'))
tree_in_feature_2 <- tree_in_feature_2 %>% filter(!(last_edite=='James.Buckle_NE'))
tree_in_feature_2 <- tree_in_feature_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
tree_in_feature_2 <- tree_in_feature_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
tree_in_feature_2 <- tree_in_feature_2[!grepl('NS', tree_in_feature_2$monad_ref),]

## assessing numbers

length(unique(tree_in_feature_2$feature_re))
length(unique(tree_in_feature_2$monad_ref))

## so we have - 80 trees over 43 monads in total

st_write(tree_in_feature_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Tree in feature/tree_in_feature_properties.shp")

## below I'm trying to get the fake riparian ids (dummy monads, test monads etc)

fake_tree_in_feature_ids <- setdiff(tree_in_feature$tree_in_fe, tree_in_feature_2$tree_in_fe)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/Tree in feature related tables")
tree_in_feature.related <- list.files(pattern='tree_in_feature_jan24')
tree_in_feature.related_2 <- lapply(tree_in_feature.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids 

install.packages("qdapRegex") 
library(qdapRegex)

tree_in_feature.related_2[[1]] <- tree_in_feature.related_2[[1]][!tree_in_feature.related_2[[1]]$'Tree in feature ID' %in% fake_tree_in_feature_ids, ]

# now exporting

write.csv(tree_in_feature.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Tree in feature/fauna.csv")
