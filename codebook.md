Getting and Cleaning Data: Assignment 
========================================
#### by CHI-JUNG CHUNG   
##### Date: 2016-05-15
        
        
### Synonpsis  

I will be required in this course to submit: 
1) a tidy data set
2) a link to a Github repository with your script for performing the analysis
3) a code book called CodeBook.md and also a README.md in the repo with your scripts. 

The goals in this assignment as following:

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


```r
## Basic Environment Setting
setwd("~/CCJ Coursera/3. Getting and Cleaning Data/Assingment 1 (week 4)")
echo = TRUE
rm(list=ls(all= "TURE"" ))

library(data.table)
library(plyr)
library(dplyr)
```

```r
## Download the file, process the dataset, and assign column names
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

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
```

### Goal 1. Merges the training and the test sets to create one data set.

```r
## Merge the train and test datasets to one dataset (Analysisdata) 
Analysisdata <- rbind(XTrain, XTest)
duplicated(colnames(Analysisdata))
Analysisdata <- Analysisdata[, !duplicated(colnames(Analysisdata))]

## List the first two variables
head(str(Analysisdata),2)
```
```
Analysisdata 'data.frame': 10299 obs. of  479 variables:
 $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 
```

### Goal 2. Extracts only the measurements on the mean and standard deviation for each measurement.

```r
## Mean
Mean <- grep("mean()", names(Analysisdata), value = FALSE, fixed = TRUE)
Mean <- append(Mean, 471:477)
InstrumentMeanMatrix <- Analysisdata[Mean]
```
```
print (Mean)
## [1]   1   2   3  41  42  43  81  82  83 121 122 123 161 162 163 201 214 227 240
[20] 253 266 267 268 317 318 319 368 369 370 419 432 445 458 471 472 473 474 475
[39] 476 477
```

```r
## Standard Deviation
STD <- grep("std()", names(Analysisdata), value = FALSE)
InstrumentSTDMatrix <- Analysisdata[STD]
```
```
print (STD)
## [1]   4   5   6  44  45  46  84  85  86 124 125 126 164 165 166 202 215 228 241
[20] 254 269 270 271 320 321 322 371 372 373 420 433 446 459
```

### Goal 3. Uses descriptive activity names to name the activities in the data set.

```r
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

```

### Goal 4. Appropriately labels the data set with descriptive variable names.


After reviewing the existing format of variables, I will lables the data set with descriptive variable names as following:

1. prefix t or f are respectively replaced by time or frequency
2. Acc is replaced by Accelerometer
3. Gyro is replaced by Gyroscope
4. Mag is replaced by Magnitude
5. BodyBody is replaced by Body

```r
names(Analysisdata)<-gsub("^t", "time", names(Analysisdata))
names(Analysisdata)<-gsub("^f", "frequency", names(Analysisdata))
names(Analysisdata)<-gsub("Acc", "Accelerometer", names(Analysisdata))
names(Analysisdata)<-gsub("Gyro", "Gyroscope", names(Analysisdata))
names(Analysisdata)<-gsub("Mag", "Magnitude", names(Analysisdata))
names(Analysisdata)<-gsub("BodyBody", "Body", names(Analysisdata))
names(Analysisdata)
```
```
## just show the first 50 variables
## before rename

  [1] "tBodyAcc-mean()-X"                   
  [2] "tBodyAcc-mean()-Y"                   
  [3] "tBodyAcc-mean()-Z"                   
  [4] "tBodyAcc-std()-X"                    
  [5] "tBodyAcc-std()-Y"                    
  [6] "tBodyAcc-std()-Z"                    
  [7] "tBodyAcc-mad()-X"                    
  [8] "tBodyAcc-mad()-Y"                    
  [9] "tBodyAcc-mad()-Z"                    
 [10] "tBodyAcc-max()-X"                    
 [11] "tBodyAcc-max()-Y"                    
 [12] "tBodyAcc-max()-Z"                    
 [13] "tBodyAcc-min()-X"                    
 [14] "tBodyAcc-min()-Y"                    
 [15] "tBodyAcc-min()-Z"                    
 [16] "tBodyAcc-sma()"                      
 [17] "tBodyAcc-energy()-X"                 
 [18] "tBodyAcc-energy()-Y"                 
 [19] "tBodyAcc-energy()-Z"                 
 [20] "tBodyAcc-iqr()-X"                    
 [21] "tBodyAcc-iqr()-Y"                    
 [22] "tBodyAcc-iqr()-Z"                    
 [23] "tBodyAcc-entropy()-X"                
 [24] "tBodyAcc-entropy()-Y"                
 [25] "tBodyAcc-entropy()-Z"                
 [26] "tBodyAcc-arCoeff()-X,1"              
 [27] "tBodyAcc-arCoeff()-X,2"              
 [28] "tBodyAcc-arCoeff()-X,3"              
 [29] "tBodyAcc-arCoeff()-X,4"              
 [30] "tBodyAcc-arCoeff()-Y,1"              
 [31] "tBodyAcc-arCoeff()-Y,2"              
 [32] "tBodyAcc-arCoeff()-Y,3"              
 [33] "tBodyAcc-arCoeff()-Y,4"              
 [34] "tBodyAcc-arCoeff()-Z,1"              
 [35] "tBodyAcc-arCoeff()-Z,2"              
 [36] "tBodyAcc-arCoeff()-Z,3"              
 [37] "tBodyAcc-arCoeff()-Z,4"              
 [38] "tBodyAcc-correlation()-X,Y"          
 [39] "tBodyAcc-correlation()-X,Z"          
 [40] "tBodyAcc-correlation()-Y,Z"          
 [41] "tGravityAcc-mean()-X"                
 [42] "tGravityAcc-mean()-Y"                
 [43] "tGravityAcc-mean()-Z"                
 [44] "tGravityAcc-std()-X"                 
 [45] "tGravityAcc-std()-Y"                 
 [46] "tGravityAcc-std()-Z"                 
 [47] "tGravityAcc-mad()-X"                 
 [48] "tGravityAcc-mad()-Y"                 
 [49] "tGravityAcc-mad()-Z"                 
 [50] "tGravityAcc-max()-X"
 
## after rename

  [1] "timeBodyAccelerometer-mean()-X"                    
  [2] "timeBodyAccelerometer-mean()-Y"                    
  [3] "timeBodyAccelerometer-mean()-Z"                    
  [4] "timeBodyAccelerometer-std()-X"                     
  [5] "timeBodyAccelerometer-std()-Y"                     
  [6] "timeBodyAccelerometer-std()-Z"                     
  [7] "timeBodyAccelerometer-mad()-X"                     
  [8] "timeBodyAccelerometer-mad()-Y"                     
  [9] "timeBodyAccelerometer-mad()-Z"                     
 [10] "timeBodyAccelerometer-max()-X"                     
 [11] "timeBodyAccelerometer-max()-Y"                     
 [12] "timeBodyAccelerometer-max()-Z"                     
 [13] "timeBodyAccelerometer-min()-X"                     
 [14] "timeBodyAccelerometer-min()-Y"                     
 [15] "timeBodyAccelerometer-min()-Z"                     
 [16] "timeBodyAccelerometer-sma()"                       
 [17] "timeBodyAccelerometer-energy()-X"                  
 [18] "timeBodyAccelerometer-energy()-Y"                  
 [19] "timeBodyAccelerometer-energy()-Z"                  
 [20] "timeBodyAccelerometer-iqr()-X"                     
 [21] "timeBodyAccelerometer-iqr()-Y"                     
 [22] "timeBodyAccelerometer-iqr()-Z"                     
 [23] "timeBodyAccelerometer-entropy()-X"                 
 [24] "timeBodyAccelerometer-entropy()-Y"                 
 [25] "timeBodyAccelerometer-entropy()-Z"                 
 [26] "timeBodyAccelerometer-arCoeff()-X,1"               
 [27] "timeBodyAccelerometer-arCoeff()-X,2"               
 [28] "timeBodyAccelerometer-arCoeff()-X,3"               
 [29] "timeBodyAccelerometer-arCoeff()-X,4"               
 [30] "timeBodyAccelerometer-arCoeff()-Y,1"               
 [31] "timeBodyAccelerometer-arCoeff()-Y,2"               
 [32] "timeBodyAccelerometer-arCoeff()-Y,3"               
 [33] "timeBodyAccelerometer-arCoeff()-Y,4"               
 [34] "timeBodyAccelerometer-arCoeff()-Z,1"               
 [35] "timeBodyAccelerometer-arCoeff()-Z,2"               
 [36] "timeBodyAccelerometer-arCoeff()-Z,3"               
 [37] "timeBodyAccelerometer-arCoeff()-Z,4"               
 [38] "timeBodyAccelerometer-correlation()-X,Y"           
 [39] "timeBodyAccelerometer-correlation()-X,Z"           
 [40] "timeBodyAccelerometer-correlation()-Y,Z"           
 [41] "timeGravityAccelerometer-mean()-X"                 
 [42] "timeGravityAccelerometer-mean()-Y"                 
 [43] "timeGravityAccelerometer-mean()-Z"                 
 [44] "timeGravityAccelerometer-std()-X"                  
 [45] "timeGravityAccelerometer-std()-Y"                  
 [46] "timeGravityAccelerometer-std()-Z"                  
 [47] "timeGravityAccelerometer-mad()-X"                  
 [48] "timeGravityAccelerometer-mad()-Y"                  
 [49] "timeGravityAccelerometer-mad()-Z"                  
 [50] "timeGravityAccelerometer-max()-X"
```

### Goal 5. To create a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
Analysisdata.dt <- data.table(Analysisdata)
TidyData <- Analysisdata.dt[, lapply(.SD, mean), by = 'participants,activities']
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)

```
