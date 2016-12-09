library(caret)



prescriberInfo <- data.frame(read.csv("../Datasets/clean/prescriber-info-categorical-cleaned.csv", stringsAsFactors=FALSE))

names <- c('Specialty', 'Gender', 'State', 'Opioid.Prescriber')
names <- c('NumSpeciality', 'NumGender', 'NumState', 'Opioid.Prescriber')

prescriberInfo$Opioid.Prescriber <- factor(ifelse(prescriberInfo$Opioid.Prescriber==0, "Zero", "One"))

inTraining <- createDataPartition(y=prescriberInfo$Opioid.Prescriber, p = 0.75, list = FALSE)
training <- prescriberInfo[inTraining,]
testing <- prescriberInfo[-inTraining,]

# Generates parameters that further control how models are created
myControl <- trainControl(method="CV", number=10, classProbs=TRUE);

set.seed(825)

dummies <- dummyVars(Opioid.Prescriber ~ ., data = prescriberInfo)
head(predict(dummies, newdata = presciberInfo))

randomForest2 <- train(Opioid.Prescriber ~ ., 
                      data=training, 
                      method="ranger", 
                      trControl=myControl,
                      verbose=FALSE)
randomForest2

nb2 <- train(Opioid.Prescriber ~ .,
            data=training,
            method="nb",
            trControl=myControl,
            verbose=FALSE)

nb2

svm2 <- train(Opioid.Prescriber~.,
             data=training,
             method="svmRadial",
             trControl=myControl,
             verbose=FALSE)
svm2

predSVM <- predict(svm2, newdata=head(testing), type="prob")
predForest <- predict(randomForest2, newdata=head(testing))
predNB <- predict(nb2, newdata=head(testing))

predSVM
predForest
predNB

forestMatrix2 <- confusionMatrix(randomForest2, norm = "none")
svmMatrix2 <- confusionMatrix(svm2, norm = "none")
nbMatrix2 <- confusionMatrix(nb2, norm = "none")

