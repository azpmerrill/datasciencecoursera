
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

