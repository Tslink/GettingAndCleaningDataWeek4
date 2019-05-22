#Create an R script to do the following:

#1. Merges the training and the test sets to create one data set.

library(dplyr)

#get list of features
feat <- read.table("./data/UCI HAR Dataset/features.txt")

#get the class lables with their activity name
actLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#get the training set information from x_train
trainingSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

#get the training label information from y_train
traingLabels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

#get the subject_train file training data
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#get the testing set inforatmion from x_test
testSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

#get the testing label information from y_test
testLabels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

#get the x_train file training data
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")



#4. Appropriately labels the data set with descriptive variable names.
#update column names
colnames(subjectTrain) <- "subject"
colnames(subjectTest) <- "subject"
colnames(traingLabels) <- "training"
colnames(testLabels) <- "training"
colnames(trainingSet) <- feat[,2]
colnames(testSet) <- feat[,2]

#combined the training sets
fullTraining <- cbind(subjectTrain, traingLabels, trainingSet)
#combined the test sets
fullTest <- cbind(subjectTest, testLabels,testSet)


fullResult <- rbind(fullTraining, fullTest)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.

columns <- colnames(fullResult)

vector <- (grepl("subject",columns) | grepl("training",columns) | grepl("(.*)mean(.*)",columns) | grepl("(.*)std(.*)",columns))

fullResult <- fullResult[vector ==TRUE]


#3. Uses descriptive activity names to name the activities in the data set



fullResult$training[fullResult$training == "1"] <- "WALKING"
fullResult$training[fullResult$training == "2"] <- "WALKING_UPSTAIRS"
fullResult$training[fullResult$training == "3"] <- "WALKING_DOWNSTAIRS"
fullResult$training[fullResult$training == "4"] <- "SITTING"
fullResult$training[fullResult$training == "5"] <- "STANDING"
fullResult$training[fullResult$training == "6"] <- "LAYING"


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

totalMean <- aggregate(. ~subject + training, fullResult,mean)

write.table(totalMean, file = "./data/UCI HAR Dataset/output.txt")

