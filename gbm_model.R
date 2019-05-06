# since we partition into trainning and testing dataset
# make train model control
fitControl <- trainControl(
    method="repeatedcv",
    number=10,
    repeats=10,
    verboseIter = FALSE)
Fit_Normalized <- train(environment~.,data=trainNormalized,method="gbm",trControl=fitControl,verbose=FALSE)
Fit_Normalized
predict(Fit_Normalized, newdata = testNormalized)
