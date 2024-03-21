##=================##
#### Information ####
## 
## A script to setup required directories and file paths.
##
## >>> DO NOT COMMIT/PUSH CUSTOM CHANGES TO THIS FILE TO GITHUB. <<<
## It is intended to stay `blank` so users can easily configure it to their own local setup.
## To use this file, create a local copy called "config_local.R" and edit the path variables in that version.
## ("config_local.R" is ignored by GitHub)
## Relevant scripts are already set up to source the "config_local.R" version.
##
##=================##

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

# Downloaded data from AGOL

hedgerow_plot_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Hedgerow_Plot_properties_jan_24/Hedgerow_plots.shp"
if(!file.exists(hedgerow_plot_properties_2023_path)) stop("The hedgerow_plot_properties_2023 file cannot be found")
hedgerow_point_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/hedgerow_point_properties_jan24/Hedgerow_Plot_Point.shp"
if(!file.exists(hedgerow_point_properties_2023_path)) stop("The hedgerow_point_properties_2023 file cannot be found")
landscape_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/landscape_properties_jan24/Landscape_Surveys.shp"
if(!file.exists(landscape_properties_2023_path)) stop("The landscape_properties_2023 file cannot be found")
lone_trees_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/lonetrees_properties_jan24/Lone_Trees.shp"
if(!file.exists(lone_trees_properties_2023_path)) stop("The lone_trees_properties_2023 file cannot be found")
monads_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/monads_properties_jan24/Monad.shp"
if(!file.exists(monads_properties_2023_path)) stop("The monads_properties_2023 file cannot be found")
ponds_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/HR ponds properties jan 24/HR_ponds.shp"
if(!file.exists(ponds_properties_2023_path)) stop("The ponds_properties_2023 file cannot be found")
riparian_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Riparian properties data jan24/Riparian_Plots.shp"
if(!file.exists(riparian_properties_2023_path)) stop("The riparian_properties_2023 file cannot be found")
stands_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/stands_properties_jan24/Stands.shp"
if(!file.exists(stands_properties_2023_path)) stop("The stands_properties_2023 file cannot be found")
squares_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/squares_properties_jan24/Squares.shp"
if(!file.exists(squares_properties_2023_path)) stop("The squares_properties_2023 file cannot be found")
tree_in_feature_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/tree_in_feature_properties/Tree_in_Feature.shp"
if(!file.exists(tree_in_feature_properties_2023_path)) stop("The tree_in_feature_properties_2023 file cannot be found")
veg_plot_properties_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/vegplot_properties_jan24/Vegetation_Plot.shp"
if(!file.exists(veg_plot_properties_2023_path)) stop("The veg_plot_properties_2023 file cannot be found")

# Test monad file
test_monads_2023_path <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Test_monads.xls"
if(!file.exists(test_monads_2023_path)) stop("The test_monads_2023 file cannot be found")

# function to remove test monads
clean_data_EES <- function(data, test_monads_file){
  data <- data[!(data$monad_ref %in% test_monads$Sample),]
  data <- data %>% filter(!(last_edite=='James.Buckle_NE')) %>% filter(!(last_edite=='Ruth.Oatway_NE')) %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
  data <- data[!grepl('NS', data$monad_ref),]
}


# related tables filepaths  
hedgerow_point_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/Hedgerow point related tables"
if(!file.exists(hedgerow_point_related_2023_filepath)) stop("The hedgerow_point_related__2023 folder cannot be found")
tree_in_feature_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/Tree in feature related tables"
if(!file.exists(tree_in_feature_related_2023_filepath)) stop("The tree_in_feature_related_2023 folder cannot be found")
stands_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/stands related tables"
if(!file.exists(stands_related_2023_filepath)) stop("The stands_related_2023 folder cannot be found")
riparian_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/riparian related tables"
if(!file.exists(riparian_related_2023_filepath)) stop("The riparian_related_2023 folder cannot be found")
ponds_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/HR ponds related tables"
if(!file.exists(ponds_related_2023_filepath)) stop("The ponds_related_2023 folder cannot be found")
lone_trees_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/lone tree related tables"
if(!file.exists(lone_trees_related_2023_filepath)) stop("The lone_trees_related_2023 folder cannot be found")
landscape_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/Landscape related tables"
if(!file.exists(landscape_related_2023_filepath)) stop("The landscape_related_2023_folder cannot be found")
veg_plot_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/veg plot related tables"
if(!file.exists(veg_plot_related_2023_filepath)) stop("The veg_plot_related_2023 folder cannot be found")
hedgerow_plot_related_2023_filepath <- "...XXXXX/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/Jan_24_snapshot_related_tables/Hedgerow plot related tables"
if(!file.exists(hedgerow_plot_related_2023_filepath)) stop("The hedgerow_plot_related_2023 folder cannot be found")
