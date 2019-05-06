setwd("/users/limengxie/Desktop/INFO8000_Project_Momo/")
# get the packages we need to use 
library(caret)
library(ggplot2)
require(reshape2)
# read the fixed dataset 
data <- read.csv("L88_57_2016_fixed.csv")
head(data)
ncol(data)
# since columns before DIA_STM are just computing parameters or identifications for samples,
#, which is not useful to build models, I need delete them
data_model <- data[,-(1:11)]
str(data_model)
write.csv(data_model,file="data_model.csv")


# start to explore these 12 variables
# transform to tydedata

melt_data<- melt(data_model,id.var="environment")
head(melt_data)
p <- ggplot(data=melt_data, aes(x=variable, y=value))+
    geom_boxplot(aes(fill=environment))+
    facet_wrap( ~ variable, scales="free")

p
# explore the scatterplot 
# featurePlot(x=data_model[,1:6], y=data_model$environment,plot="pairs",auto.key=list(colums=3))
# featurePlot(x=data_model[,7:12], y=data_model$environment,plot="pairs",auto.key=list(colums=3))
# 
# # explore the density plot 
# featurePlot(x=data_model[,1:6], y=data_model$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")), 
#             adjust = 1.5, 
#             pch = "|", 
#             layout = c(2, 3))
# featurePlot(x=data_model[,c(7:10,12)], y=data_model$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")), 
#             adjust = 1.5, 
#             pch = "|", 
#             layout = c(2, 3))
# decide which variable to delete : TD_MED,ADVT_COUNT,BASAL_COUNT
data_model <- data_model[,-c(4,7,8)]
write.csv(data_model, file = "data_model")
# since variables are at different scales, I will normalize dataset
# start to divide them into training dataset and testing dataset at a ratio of 8:2
set.seed(96)
inTraining <- createDataPartition(y=data_model$environment, p=0.8,list=FALSE)
training <- data_model[inTraining,]
testing <- data_model[-inTraining,]
# normalize training and testing datasets
preProcValues <- preProcess(data_model, method = c("center", "scale"))
#trainingProcessed <- predict(preProcValues,training)
trainNormalized<- predict(preProcValues, training)
testNormalized<- predict(preProcValues, testing)
# visualze normalized training dataset and test dataset
# featurePlot(x=trainNormalized[,-8], y=trainNormalized$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")), 
#             adjust = 1.5, 
#             pch = "|", 
#             layout = c(3, 3))
# featurePlot(x=testNormalized[,-8], y=testNormalized$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")), 
#             adjust = 1.5, 
#             pch = "|", 
#             layout = c(3, 3))

# start to work on train 3 different models
