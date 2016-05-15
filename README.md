### Getting and Cleaning Data Course Project


#### The purpose of this project is to teach me how to collect, work with, and clean a data set. I will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts.


#### The original and open dataset was from "Human Activity Recognition Using Smartphones Data Set (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)". The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

#### Therefore, I would first merge the training and the test sets to create one data set. And extracts only the measurements on the mean and standard deviation for each measurement.Further, I used descriptive activity names to name the activities in the data set and labeled the data set with descriptive variable names. Finally, I created a second, independent tidy data set with the average of each variable for each activity and each subject.



