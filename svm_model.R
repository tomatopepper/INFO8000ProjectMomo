





# since we partition into trainning and testing dataset
# make train model control
fitControl <- trainControl(
    method="repeatedcv",
    number=10,
    repeats=10,
    verboseIter = FALSE)
set.seed(981395)
svmFit1 <- train(environment ~TAP_DIA+plantmass+TD_AVG+RTP_COUNT+HYP_DIA+DIA_STM,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit1
svmFit2 <- train(environment ~TAP_DIA+plantmass+TD_AVG+RTP_COUNT+HYP_DIA+DIA_STM+AREA,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit2
# add area variable didn't increase the accuracy 
svmFit3 <- train(environment ~TAP_DIA+plantmass+TD_AVG+RTP_COUNT+HYP_DIA+DIA_STM+AVG_DENSITY,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit3
# add AVG_DENSITY decrease the accuracy 
svmFit4 <- train(environment ~TAP_DIA+plantmass+TD_AVG+RTP_COUNT+HYP_DIA,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit4
# delete DIA_STM didn't decrease much accuracy
svmFit5 <- train(environment ~TAP_DIA+plantmass+TD_AVG+HYP_DIA,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit5
# delete RTP_COUNT reduce accuracy, so I keep it in the model
svmFit6<- train(environment ~TAP_DIA+plantmass+TD_AVG+RTP_COUNT,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit6
# delete HYP_DIA didn't reduce accuracy
svmFit7<- train(environment ~TAP_DIA+TD_AVG+RTP_COUNT,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit7
# delete plantmass reduce accuracy, so I keep plantmass in the model 
svmFit7<- train(environment ~TAP_DIA+RTP_COUNT+plantmass,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit7
# delete TD_AVG largely reduce the accuracy. must include
svmFit8<- train(environment ~RTP_COUNT+plantmass+TD_AVG,data=trainNormalized,method="svmLinear",tr=fitControl)
svmFit8
# delete TAP_DIA didn't reduce the accuray.
# svmFit8 is our final svm model with 3 variables. Seems very good, may not overfitting problem.