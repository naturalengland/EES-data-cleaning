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

lone_trees <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/lonetrees_properties_jan24/Lone_Trees.shp")
summary(lone_trees)

# removing QA
lone_trees <- subset(lone_trees, (as.character(lone_tree_) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

lone_trees_2 <- lone_trees[!(lone_trees$monad_ref %in% test_monads$Sample),]

lone_trees_2 <- lone_trees_2 %>% filter(!(last_edite=='James.Buckle_NE'))
lone_trees_2 <- lone_trees_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
lone_trees_2 <- lone_trees_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
lone_trees_2 <- lone_trees_2[!grepl('NS', lone_trees_2$monad_ref),]

## assessing numbers

length(unique(lone_trees_2$feature_re))
length(unique(lone_trees_2$monad_ref))

## so we have - 1610 trees over 203 monads in total

st_write(lone_trees_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/lone_tree_properties.shp")

## below I'm trying to get the fake riparian ids (dummy monads, test monads etc)

fake_lone_trees_ids <- setdiff(lone_trees$lone_tree_, lone_trees_2$lone_tree_)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/lone tree related tables")
lone_trees.related <- list.files(pattern='lonetrees_jan24')
lone_trees.related_2 <- lapply(lone_trees.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids 

install.packages("qdapRegex") 
library(qdapRegex)

lone_trees.related_2[[1]] <- lone_trees.related_2[[1]][!lone_trees.related_2[[1]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[2]] <- lone_trees.related_2[[2]][!lone_trees.related_2[[2]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[3]] <- lone_trees.related_2[[3]][!lone_trees.related_2[[3]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[4]] <- lone_trees.related_2[[4]][!lone_trees.related_2[[4]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[5]] <- lone_trees.related_2[[5]][!lone_trees.related_2[[5]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[6]] <- lone_trees.related_2[[6]][!lone_trees.related_2[[6]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[7]] <- lone_trees.related_2[[7]][!lone_trees.related_2[[7]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[8]] <- lone_trees.related_2[[8]][!lone_trees.related_2[[8]]$'Tree ID' %in% fake_lone_trees_ids, ]
lone_trees.related_2[[9]] <- lone_trees.related_2[[9]][!lone_trees.related_2[[9]]$'Tree ID' %in% fake_lone_trees_ids, ]

# now exporting

write.csv(lone_trees.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/accesslimitations.csv")
write.csv(lone_trees.related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/deadwood_attached.csv")
write.csv(lone_trees.related_2[[3]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/epiphytes.csv")
write.csv(lone_trees.related_2[[4]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/fungi.csv")
write.csv(lone_trees.related_2[[5]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/bioindicator_lichens.csv")
write.csv(lone_trees.related_2[[6]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/tree_disease.csv")
write.csv(lone_trees.related_2[[7]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/tree_health.csv")
write.csv(lone_trees.related_2[[8]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/tree_management.csv")
write.csv(lone_trees.related_2[[9]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Lone trees/tree_fauna.csv")
