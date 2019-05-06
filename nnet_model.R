# since we partition into trainning and testing dataset
# make train model control
fitControl <- trainControl(
    method="repeatedcv",
    number=10,
    repeats=10,
    verboseIter = FALSE)
# nnet algorithm
Fit_Normalized_nnet<- train(environment~.,data=trainNormalized,method="nnet",trControl=fitControl,verbose=FALSE)
Fit_Normalized_nnet
predict(Fit_Normalized, newdata = testNormalized)
# cross_validate the model 