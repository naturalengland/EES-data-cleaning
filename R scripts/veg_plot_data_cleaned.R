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

veg_plot <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/vegplot_properties_jan24/Vegetation_Plot.shp")
summary(veg_plot)

# no QA for veg plots in Sweet
# veg_plot <- subset(veg_plot, (as.character(veg_plot_i) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- readxl::read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

veg_plot_2 <- veg_plot[!(veg_plot$monad_ref %in% test_monads$Sample),]

veg_plot_2 <- veg_plot_2 %>% filter(!(last_edite=='James.Buckle_NE'))
veg_plot_2 <- veg_plot_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
veg_plot_2 <- veg_plot_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
veg_plot_2 <- veg_plot_2[!grepl('NS', veg_plot_2$monad_ref),]

## assessing numbers

vegplots_23 <- length(unique(veg_plot_2$feature_re))
monads_2023 <- length(unique(veg_plot_2$monad_ref))

write.csv()

## so we have - 949 veg_plot plots over 250 monads in total

st_write(veg_plot_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Veg plots/veg_plot_properties.shp")

## below I'm trying to get the fake riparian ids (dummy monads, test monads etc)

fake_veg_plot_ids <- setdiff(veg_plot$veg_plot_i, veg_plot_2$veg_plot_i)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/veg plot related tables")
veg_plot.related <- list.files(pattern='vegplot_jan24')
veg_plot.related_2 <- lapply(veg_plot.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids

install.packages("qdapRegex") 
library(qdapRegex)

veg_plot.related_2[[1]] <- veg_plot.related_2[[1]][!veg_plot.related_2[[1]]$'Veg plot ID' %in% fake_veg_plot_ids, ]
veg_plot.related_2[[2]] <- veg_plot.related_2[[2]][!veg_plot.related_2[[2]]$'Veg plot ID' %in% fake_veg_plot_ids, ]
veg_plot.related_2[[3]] <- veg_plot.related_2[[3]][!veg_plot.related_2[[3]]$'Veg plot ID' %in% fake_veg_plot_ids, ]
# veg_plot.related_2[[4]] <- veg_plot.related_2[[4]][!veg_plot.related_2[[4]]$'veg_plot plot ID' %in% fake_veg_plot_ids, ]

# now exporting

write.csv(veg_plot.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Veg plots/invasive_species.csv")
write.csv(veg_plot.related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Veg plots/vascular_plants.csv")
write.csv(veg_plot.related_2[[3]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Veg plots/vegetation_surface.csv")
#write.csv(riparian.related_2[[4]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Riparian/vascular_plants.xls")


veg_plots_EPM <- veg_plot_2 %>% filter((feature_re=='NY8523_V2'))
write.csv(veg_plots_EPM, "C:/Users/m1011479/Documents/Data for EPM/NY8523_V2/NY8523_V2_properties.csv")

