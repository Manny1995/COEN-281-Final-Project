library(caret)

# Clear workspace
rm(list=ls())

prescriberInfo <- data.frame(read.csv("../Datasets/clean/prescriber-info-cleaned.csv", stringsAsFactors=FALSE))
  
  
for (col in names(prescriberInfo)) {
  prescriberInfo[col] <- factor(ifelse(prescriberInfo[col]==0, 0, 1))
}

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

nb <- train(Opioid.Prescriber ~ .,
            data=training,
            method="nb",
            trControl=myControl,
            verbose=FALSE)

nb

svm <- train(Opioid.Prescriber~.,
             data=training,
             method="svmRadial",
             trControl=myControl,
             verbose=FALSE)
svm

predSVM <- predict(svm, newdata=head(testing), type="prob")
predForest <- predict(randomForest, newdata=head(testing))
predNB <- predict(nb, newdata=head(testing))

predSVM
predForest
predNB

forestMatrix <- confusionMatrix(randomForest, norm = "none")
svmMatrix <- confusionMatrix(svm, norm = "none")
nbMatrix <- confusionMatrix(nb, norm = "none")

