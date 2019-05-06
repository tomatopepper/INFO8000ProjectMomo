data_model <- read.csv("data_model.csv")
inTraining <- createDataPartition(y=data_model$environment, p=0.8,list=FALSE)
training <- data_model[inTraining,]
testing <- data_model[-inTraining,]
# normalize training and testing datasets
preProcValues <- preProcess(data_model, method = c("center", "scale"))
#trainingProcessed <- predict(preProcValues,training)
trainNormalized<- predict(preProcValues, training)
testNormalized<- predict(preProcValues, testing)
#model for shiny 
svmFit8<- train(environment ~RTP_COUNT+plantmass+TD_AVG,data=trainNormalized,method="svmLinear",tr=fitControl)
#svmFit8
#newRTPCOUNT <- 120
#newplantmass <- 50
#newTD_AVG <- 0.05
newInput <- data.frame(RTP_COUNT=120, plantmass=2.56, TD_AVG=0.06)
newValue <- predict(svmFit8, newdata = newInput)
newValue
