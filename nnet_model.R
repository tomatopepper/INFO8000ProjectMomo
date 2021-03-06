# netural networks algorithm is used for regression and classification. Nnet is like blackbox, it is 
# very hard for human to understand and intepret. 
library(caret)
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
fitControl <- trainControl(
    method="repeatedcv",
    number=10,
    repeats=10,
    verboseIter = FALSE)
# nnet algorithm
Fit_Normalized_nnet<- train(environment~.,data=trainNormalized,method="nnet",trControl=fitControl,verbose=FALSE)
Fit_Normalized_nnet
predict(Fit_Normalized_nnet, newdata = testNormalized)
pred <- predict(Fit_Normalized_nnet, newdata = testNormalized)
truth <- testNormalized$environment
confusionMatrix(pred,truth)
# the accuracy is pretty good.