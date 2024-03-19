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

## QA explore

## importing HR Ponds Properties data

ponds_data <- sf::read_sf("C:/Users/m1011479/OneDrive - Defra/Working Group - Data Analysis/Data Analysis Planning Group/Datasets/HR ponds properties jan 24/HR_Ponds.shp")
summary(ponds_data)

## removing QA monads

ponds_no_QA <- subset(ponds_data, (as.character(pond_id) == as.character(qa_source_))) 
 
## removing test monads and fake monads
library(readxl)
test_monads <- read_excel("C:/Users/m1011479/Documents/Data analysis/Test_monads.xlsx")

ponds_data_2 <- ponds_no_QA[!(ponds_no_QA$monad_ref %in% test_monads$Sample),]

ponds_data_2 <- ponds_data_2 %>% filter(!(last_edite=='James.Buckle_NE'))
ponds_data_2 <- ponds_data_2 %>% filter(!(last_edite=='Ruth.Oatway_NE'))
ponds_data_2 <- ponds_data_2 %>% filter(!(last_edite=='SJacobs@esriuk.com_EsriUK'))
ponds_data_2 <- ponds_data_2[!grepl('NS', ponds_data_2$monad_ref),]

## assessing numbers

length(unique(ponds_data_2$feature_re))
length(unique(ponds_data_2$pond_id))
length(unique(ponds_data_2$monad_ref))

## so we have - 112 ponds in total (edna yes and no)

st_write(ponds_data_2, "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_properties.shp")

## now looking at eNDA = YES only

ponds_edna <- subset(ponds_data_2, ponds_data_2$edna == "YES")
length(unique(ponds_edna$feature_re))
length(unique(ponds_edna$monad_ref))


#importing pond match file
fera_doc <- read_xlsx("C:/Users/m1011479/Documents/fera_edna.xlsx")
fera_doc <- fera_doc[, c(1,2)]
setdiff(fera_doc$Monad, ponds_edna$monad_ref)
setdiff(ponds_edna$monad_ref, fera_doc$Monad)

## so here we have 46 ponds with eDNA samples taken, over 37 monads

## below I'm trying to get the fake pond_ids (dummy monads, test monads etc)

fake_pond_ids <- setdiff(ponds_data$pond_id, ponds_data_2$pond_id)

# importing related tables data 
library(readxl)
setwd("C:/Users/m1011479/Documents/Data analysis/HR ponds related tables")
ponds.related <- list.files(pattern='ponds_jan24_')
ponds.related_2 <- lapply(ponds.related, read_excel)

# now i want to remove rows from the related tables which contain fake pond ids

install.packages("qdapRegex")
library(qdapRegex)

ponds.related_2[[1]] <- ponds.related_2[[1]][!ponds.related_2[[1]]$'Pond ID' %in% fake_pond_ids, ]
ponds.related_2[[2]] <- ponds.related_2[[2]][!ponds.related_2[[2]]$'Pond ID' %in% fake_pond_ids, ]
ponds.related_2[[3]] <- ponds.related_2[[3]][!ponds.related_2[[3]]$'Pond ID' %in% fake_pond_ids, ]
ponds.related_2[[4]] <- ponds.related_2[[4]][!ponds.related_2[[4]]$'Pond ID' %in% fake_pond_ids, ]
ponds.related_2[[5]] <- ponds.related_2[[5]][!ponds.related_2[[5]]$'Pond ID' %in% fake_pond_ids, ]

# now exporting

write.csv(ponds.related_2[[1]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_invasive_species.csv")
write.csv(ponds.related_2[[2]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_pond_management.csv")
write.csv(ponds.related_2[[3]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_tree_surrounding_pond.csv")
write.csv(ponds.related_2[[4]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_tree_within_pond.csv")
write.csv(ponds.related_2[[5]], "C:/Users/m1011479/Documents/Data analysis/Cleaned data/Ponds/ponds_vegetation_species.csv")

# just checking how many ponds I have here and if it's correct. Should be about 64 I think

pond_ids <- as.data.frame(ponds.related_2[[1]]$'Pond ID')
pond_ids2 <- as.data.frame(ponds.related_2[[2]]$'Pond ID')
pond_ids3 <- as.data.frame(ponds.related_2[[3]]$'Pond ID')
pond_ids4 <- as.data.frame(ponds.related_2[[4]]$'Pond ID')
pond_ids5 <- as.data.frame(ponds.related_2[[5]]$'Pond ID')

pond_ids <- subset(pond_ids, select = c('Pond ID'))
pond_ids2 <- subset(pond_ids2, select = c('Pond ID'))
pond_ids3 <- subset(pond_ids3, select = c('Pond ID'))
pond_ids4 <- subset(pond_ids4, select = c('Pond ID'))
pond_ids5 <- subset(pond_ids5, select = c('Pond ID'))
pond_ids6 <- subset(pond_ids6, select = c('Pond ID'))


all_pond_ids <- rbind(pond_ids, pond_ids2, pond_ids3, pond_ids4, pond_ids5, pond_ids6)
all_pond_ids_unique <- (unique(all_pond_ids$pond_id_2))
length(all_pond_ids_unique)

## the current issue is that I have 61 ponds here, whereas the properties dataset said I have 63.
## so I need to find out where the missing 3 are
## to do this, I can compare the pond_ids here with the pond ids in fake_pond_ids?

setdiff(ponds_data_2$pond_id, all_pond_ids_unique)

# I've checked and these have no related tables data within the GDB. So that's ok and it's execpted that those two
## ponds wouldn't show up here.


# exporting eDNA bits for FERA - done and no longer that relevant but will keep code in case

ponds_fera <- subset(ponds_data_5[ , c('created_da', 'monad_ref', 'pond_ref', 'feature_re', 'edna', 'edna_id', 'edna_volum',  'created_us')])
ponds_fera <- st_drop_geometry(ponds_fera)
write.csv(ponds_fera, "C:/Users/m1011479/Documents/Data analysis/Ponds_fera.csv")

# LA function to add brackets to feature_layr pond id
add_external_brackets <- function(my_string){
  new_string <- paste0("{",my_string,"}")
}

#example
ponds_data_2$pond_id <- add_external_brackets(ponds_data_2$pond_id)

#can also use the apply function to apply to function across the dataframe

