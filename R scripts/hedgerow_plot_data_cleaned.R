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
 
## importing hedgerow_plot data

hedgerow_plot <- sf::read_sf(hedgerow_plot_properties_2023_path)
summary(hedgerow_plot)

# removing QA
hedgerow_plot <- subset(hedgerow_plot, (as.character(hedgerow_p) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel(test_monads_2023_path)

hedgerow_plot_2 <- hedgerow_plot[!(hedgerow_plot$monad_ref %in% test_monads$Sample),]

hedgerow_plot_2 <- hedgerow_plot_2 %>% filter(!(last_edite=='James.Buckle_NE'))
hedgerow_plot_2 <- hedgerow_plot_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
hedgerow_plot_2 <- hedgerow_plot_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
hedgerow_plot_2 <- hedgerow_plot_2[!grepl('NS', hedgerow_plot_2$monad_ref),]

## assessing numbers

length(unique(hedgerow_plot_2$feature_re))
length(unique(hedgerow_plot_2$monad_ref))

## so we have - 441 hedgerow plots over 160 monads in total

st_write(hedgerow_plot_2, "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/hedgerow_plot_properties.shp")

## below I'm trying to get the fake pond_ids (dummy monads, test monads etc)

fake_hedgerow_plot_ids <- setdiff(hedgerow_plot$hedgerow_p, hedgerow_plot_2$hedgerow_p)

# importing related tables data 
library(readxl)
setwd(hedgerow_plot_related_2023_filepath)
hedgerow_plot.related <- list.files(pattern='hedgerow_plot_jan24')
hedgerow_plot.related_2 <- lapply(hedgerow_plot.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids

install.packages("qdapRegex")
library(qdapRegex)

hedgerow_plot.related_2[[1]] <- hedgerow_plot.related_2[[1]][!hedgerow_plot.related_2[[1]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]
hedgerow_plot.related_2[[2]] <- hedgerow_plot.related_2[[2]][!hedgerow_plot.related_2[[2]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]
hedgerow_plot.related_2[[3]] <- hedgerow_plot.related_2[[3]][!hedgerow_plot.related_2[[3]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]
hedgerow_plot.related_2[[4]] <- hedgerow_plot.related_2[[4]][!hedgerow_plot.related_2[[4]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]
hedgerow_plot.related_2[[5]] <- hedgerow_plot.related_2[[5]][!hedgerow_plot.related_2[[5]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]
hedgerow_plot.related_2[[6]] <- hedgerow_plot.related_2[[6]][!hedgerow_plot.related_2[[6]]$'Hedgerow plot ID' %in% fake_hedgerow_plot_ids, ]

# now exporting
# you will have to change filepath to write CSVs as this uses my staff number

write.csv(hedgerow_plot.related_2[[1]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/bioindicator_lichens.csv")
write.csv(hedgerow_plot.related_2[[2]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/fencing.csv")
write.csv(hedgerow_plot.related_2[[3]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/invasive_species.csv")
write.csv(hedgerow_plot.related_2[[4]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/livestock_damage.csv")
write.csv(hedgerow_plot.related_2[[5]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/pests_diseases.csv")
write.csv(hedgerow_plot.related_2[[6]], "C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Data cleaning/cleaned sweet data/Hedgerow plots/woody_species.csv")

