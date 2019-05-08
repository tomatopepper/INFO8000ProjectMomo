library(caret)
# since variables are at different scales, I will normalize dataset
# start to divide them into training dataset and testing dataset at a ratio of 8:2
setwd("/Users/limengxie/Desktop/INFO8000ProjectMomo/")
data_model <- read.csv("data_model.csv")
data_model <- data_model[,-1]
set.seed(96)
inTraining <- createDataPartition(y=data_model$environment, p=0.8,list=FALSE)
training <- data_model[inTraining,]
testing <- data_model[-inTraining,]
# normalize training and testing datasets
preProcValues <- preProcess(data_model, method = c("center", "scale"))
# trainingProcessed <- predict(preProcValues,training)
trainNormalized<- predict(preProcValues, training)
testNormalized<- predict(preProcValues, testing)
# visualze normalized training dataset and test dataset
featurePlot(x=trainNormalized[,-8], y=trainNormalized$environment, plot="density", scales = list(x = list(relation="free"),                                                                         y = list(relation="free")),
             adjust = 1.5,
             pch = "|",
             layout = c(3, 3))
