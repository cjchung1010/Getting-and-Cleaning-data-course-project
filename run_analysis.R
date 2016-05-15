


## Basic Environment Setting
setwd("~/CCJ Coursera/3. Getting and Cleaning Data/Assingment 1 (week 4)")
echo = TRUE
rm ( list = ls (all= "TURE" ) ) 

library(data.table)
library(plyr)
library(dplyr)


## Download the file, process the dataset, and assign column names

temp <- tempfile()
download.file <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

unzip(temp, list = TRUE) 
YTest <- read.table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"))
XTest <- read.table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"))
SubjectTest <- read.table(unzip(temp, "UCI HAR Dataset/test/subject_test.txt"))
YTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"))
XTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"))
SubjectTrain <- read.table(unzip(temp, "UCI HAR Dataset/train/subject_train.txt"))
Features <- read.table(unzip(temp, "UCI HAR Dataset/features.txt"))
unlink(temp) 

colnames(XTrain) <- t(Features[2])
colnames(XTest) <- t(Features[2])

XTrain$activities <- YTrain[, 1]
XTrain$participants <- SubjectTrain[, 1]
XTest$activities <- YTest[, 1]
XTest$participants <- SubjectTest[, 1]


### Goal 1. Merges the training and the test sets to create one data set.

## Merge the train and test datasets to one dataset (Analysisdata) 
Analysisdata <- rbind(XTrain, XTest)
duplicated(colnames(Analysisdata))
Analysisdata <- Analysisdata[, !duplicated(colnames(Analysisdata))]


### Goal 2. Extracts only the measurements on the mean and standard deviation for each measurement.


## Mean
Mean <- grep(mean(), names(Analysisdata), value = FALSE, fixed = TRUE)
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- Analysisdata[Mean]

## Standard Deviation
STD <- grep(std(), names(Analysisdata), value = FALSE)
InstrumentSTDMatrix <- Analysisdata[STD]


### Goal 3. Uses descriptive activity names to name the activities in the data set.

Analysisdata$activities <- as.character(Analysisdata$activities)
table(Analysisdata$activities)
##    1    2    3    4    5    6 
##  1722 1544 1406 1777 1906 1944

Analysisdata$activities[Analysisdata$activities == 1] <- "Walk"
Analysisdata$activities[Analysisdata$activities == 2] <- "Walk Upstairs"
Analysisdata$activities[Analysisdata$activities == 3] <- "Walk Downstairs"
Analysisdata$activities[Analysisdata$activities == 4] <- "Sit"
Analysisdata$activities[Analysisdata$activities == 5] <- "Stand"
Analysisdata$activities[Analysisdata$activities == 6] <- "Lay"

### Goal 4. Appropriately labels the data set with descriptive variable names.

names(Analysisdata)<-gsub("^t", "time", names(Analysisdata))
names(Analysisdata)<-gsub("^f", "frequency", names(Analysisdata))
names(Analysisdata)<-gsub("Acc", "Accelerometer", names(Analysisdata))
names(Analysisdata)<-gsub("Gyro", "Gyroscope", names(Analysisdata))
names(Analysisdata)<-gsub("Mag", "Magnitude", names(Analysisdata))
names(Analysisdata)<-gsub("BodyBody", "Body", names(Analysisdata))
names(Analysisdata)


### Goal 5. To create a second, independent tidy data set with the average of each variable for each activity and each subject.
Analysisdata.dt <- data.table(Analysisdata)
TidyData <- Analysisdata.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = Tidy.txt, row.names = FALSE)

