library(caret)

prescriberInfo$Opioid.Prescriber <- factor(ifelse(prescriberInfo$Opioid.Prescriber==0, "Zero", "One"))

inTraining <- createDataPartition(y=prescriberInfo$Opioid.Prescriber, p = 0.75, list = FALSE)
training <- prescriberInfo[inTraining,]
testing <- prescriberInfo[-inTraining,]

# Generates parameters that further control how models are created
myControl <- trainControl(method="CV", number=10, classProbs=TRUE);

set.seed(825)
randomForest <- train(Opioid.Prescriber ~ ., 
                      data=training, 
                      method="ranger", 
                      trControl=myControl,
                      verbose=FALSE)
randomForest

svm <- train(Opioid.Prescriber~.,
             data=training,
             method="svmRadial",
             trControl=myControl,
             verbose=FALSE)
#svm

#predSVM <- predict(svm, newdata=head(testing), type="prob")
predForest <- predict(randomForest, newdata=head(testing))

#predSVM
predForest

forestMatrix <- confusionMatrix(randomForest, norm = "none")
svmMatrix <- confusionMatrix(svm, norm = "none")

