## The goals of this script are: 1 fix the experiment tag format of biomass data 2. Commbine L88_57_ww and L88_57_ws and add environment factor ww(well water) and ws(water stress) in the combined file 3. match the biomass data with root data by experiment tag 4. exclude the duplicates data due human or computer error 5. exclude the NAs missing data
# read the csv files
setwd("/users/limengxie/Desktop/INFO8000ProjectMomo//")
# regular expression to replace . with _ for experimental tag
biomass <- read.csv("2016PlantBiomass.csv")
tag <- biomass$plot.ID
Experiment.Tag <- gsub("\\.","_",tag)
plantmass<- biomass$dry.weight.1.shoot.plus.bag
biomass_revised <- cbind(Experiment.Tag, plantmass)
# read L88_57 data and add one column of plant environment well-water(ww) and water-stress(ws)
L88ws <- read.csv("L88 57_ws_2016.csv")
summary(L88ws)
L88ws["environment"] <- "ws"
ncol(L88ws)
L88ww <- read.csv("L88 57_ww_2016.csv")
summary(L88ww)
L88ww["environment"] <- "ww"
ncol(L88ww)
# combine two datasets together by rows
L88 <- rbind(L88ws,L88ww)
# match the biomass data with root data by experiment_tag
# note the biomass data also consist of other species biomass. I only match common bean genotype L88_57.
biomass_merge <- merge(x=L88,y=biomass_revised,by="Experiment.Tag",all=T)
biomass_merge <- biomass_merge[complete.cases(biomass_merge[,2]),]
summary(biomass_merge)
# I notice there are duplicates for the experiment_tag and root images, which are not expected.
# I need to remove thoese duplicates and double check root images we took.
n_occur <- data.frame(table(biomass_merge$Experiment.Tag))
duplicates <- n_occur [n_occur$Freq>1,]
duplicates
duplicate_list <- duplicates$Var1
duplicate_df <- biomass_merge[biomass_merge$Experiment.Tag %in% duplicate_list,]
# use the uniq function to remove one of the duplicates 
deduped_df <- unique(duplicate_df[,c(1,3)])
# Go to check mages we took for roots, because each image has its own label tag inside the image.
# The wrong label maybe because of people mistakely input the tag or computer mistakely extract the wrong tag.
# Fix following label errors:
# DCS_0781 should be 53_40_2, no images found for DSC_9346 and DSC_9345(delete)
# DSC_9672 the label is 40-24-10. 9642, 9641 are the same picture, delete one. # DSC_9682.JPG,SC_9683.JPG are the same images,delete one. delete 9729 no image found 
# delete DSC_9670.JPG delete 9669,9670,9671,9651 because there are two experimental tags for them in each pitcure
# fix biomass_merge with wrong entry
biomass_merge$Experiment.Tag[biomass_merge$Image.name=="DSC_0781.JPG"] <-"53_40_2"
biomass_merge$Experiment.Tag[biomass_merge$Image.name=="DSC_9676.JPG"] <-"42_24_10"
L88_57_fixed <- biomass_merge[!(biomass_merge$Image.name %in% c("DSC_9346.JPG","DSC_9345.JPG", "DSC_9641.JPG", "DSC_9682.JPG",
"DSC_9729.JPG","DSC_9670.JPG","DSC_0882.JPG","DSC_0502.JPG","DSC_0099.JPG","DSC_9669.JPG","DSC_9671.JPG","DSC_9651.JPG")),]
#double check if there are duplicates
summary(L88_57_fixed)
n_occur <- data.frame(table(L88_57_fixed $Experiment.Tag))
duplicates <- n_occur [n_occur$Freq>1,]
duplicates
str(L88_57_fixed)
# considering 35/667=0.052 NAs, which is a very small portion of whole dataset, I can drop those NAs
L88_57_fixed <- L88_57_fixed[complete.cases(L88_57_fixed),]
summary(L88_57_fixed)
# now there is no missing data for each observations
# here we get 12 variables of 632 observation 
write.csv(L88_57_fixed, file="L88_57_2016_fixed.csv")
