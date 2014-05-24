Getting and Cleaning Data Project
=================================

This R script is written for Windows
All code is contained in run_analysis.R
The Tidy Data results are in AvgData.txt

In order for the script to run properly, it must be in the working directory along 
with the UCI HAR Dataset folder containing all the datasets and subfolders.

I took the approach of combining all the datasets like to like (subject train to subject test, X to X & Y to Y)
then combining that all together along with the features, labels and activities.
Then I created 2 datasets off of that combined one - one for each of the requirements.
Lastly I wrote the resulting datasets out to a TXT file.

The assignment was:
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 You should create one R script called run_analysis.R that does the following. 

1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive activity names. 
5.	Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Further comments are contained within the R script:

###############################################
#Getting and Cleaning Data Course Project 

#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive activity names. 
#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#setwd("~/R_Class/Getting_and_Cleaning_Data/Project")

###############################################
#Read in all the Test & Train Core Data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")

features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")       #List of all features.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")  #Links the class labels with their activity name

###############################################
#Merge the Subject Datasets  
#Each row identifies the subject who performed the activity for each window sample. 
#Its range is from 1 to 30.
DataSubject <- rbind(subject_test, subject_train)
colnames(DataSubject) <- "SubjectID"

#Merge the Results Datasets
DataSet <- rbind(X_test, X_train)
colnames(DataSet) <- features[,2]

#Merge the Label Datasets  
DataLabel <- rbind(y_test, y_train)
colnames(DataLabel) <- "Label"

#Tie the class labels to the activity name
LabelActivity <- merge(DataLabel, activity_labels, by=1) 
LabelActivity <- LabelActivity[,-1]

#Now merge it all together into one
DataAll <- cbind(DataSubject, LabelActivity, DataSet)

###############################################
#Extracts only the measurements on the mean and standard deviation for each measurement
#Define what to Match
MeanStd <- c("mean\\(\\)", "std\\(\\)") 
matched <- grep(paste(MeanStd,collapse="|"), features[,2], value=FALSE)
matched <- matched+2 

#Combine with DataAll to extract Mean & Standard Deviation
DataMeanSD <- DataAll[,c(1,2,matched)]

###############################################
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Create a smaller dataset with only the needed columns
#Must have rshape2 package installed
TidyData = melt(DataAll, id.var = c("SubjectID", "LabelActivity"))

#Create a new variable with the average of each activity & subject
AvgData = dcast(TidyData, SubjectID + LabelActivity ~ variable,mean)

###############################################
#Write out the 2 results to files
write.table(DataMeanSD, "./DataMeanSD.txt" , sep = ";")
write.table(AvgData, "./AvgData.txt" , sep = ";")

