setwd("/users/limengxie/Desktop/INFO8000ProjectMomo/")
# get the packages we need to use 
library(caret)
library(ggplot2)
require(reshape2)
# read the fixed dataset 
data <- read.csv("L88_57_2016_fixed.csv")
head(data)
ncol(data)
# since columns before DIA_STM are just computing parameters or identifications for samples,
#, which are not useful to build models, I delete them
data_model <- data[,-(1:11)]
str(data_model)


# start to explore these 12 variables
# transfer to tidydata 
melt_data<- melt(data_model,id.var="environment")
head(melt_data)
p <- ggplot(data=melt_data, aes(x=variable, y=value))+
    geom_boxplot(aes(fill=environment))+
    facet_wrap( ~ variable, scales="free")
p
# we can see the scale of variables is quite different, which may need to normalize data
# explore the scatterplot 
featurePlot(x=data_model[,1:6], y=data_model$environment,plot="pairs",auto.key=list(colums=3))
featurePlot(x=data_model[,7:12], y=data_model$environment,plot="pairs",auto.key=list(colums=3))
# explore the density plot 
featurePlot(x=data_model[,1:6], y=data_model$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(2, 3))
featurePlot(x=data_model[,c(7:10,12)], y=data_model$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(2, 3))
# decide which variable to delete : TD_MED,ADVT_COUNT,BASAL_COUNT
data_model <- data_model[,-c(4,7,8)]
write.csv(data_model, file = "data_model.csv")
