Experiment context:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Summary of experiment:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

======================================
Raw data repository:http://archive.ics.uci.edu/ml/machine-learning-databases/00240/.  The dataset includes the following files:

- 'README.txt’
- 'features_info.txt': #Shows information about the variables used on the feature vector.
- 'features.txt': #List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': #Training set.
- 'train/y_train.txt': #Training labels
- 'test/X_test.txt': #Test set
- 'test/y_test.txt': #Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': #Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': #The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': #The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': #The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

======================================
Scripts:


library(data.table)
library(dplyr)
##loading needed libraries


##downloading dataset and capturing download date
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")
dateDownloaded <- date()


##unzipping dataset and reading data into R
unzip("Dataset.zip")

#reading activity labels and features
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",colClasses="character")
features <- read.table("./UCI HAR Dataset/features.txt",colClasses="character")

#reading test and training data
testData <- read.table("./UCI HAR Dataset/test/X_test.txt") 
testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt") ##activities (1-5)
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt") ##participants (1-24)
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt") 
trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt") ##activities (1-5)
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt") ##participants (1-24)

##assigning  activity names to name the activities in both test and training data
testData_act$V1 <- factor(testData_act$V1,levels=act_labels$V1,labels=act_labels$V2) 
trainData_act$V1 <- factor(trainData_act$V1,levels=act_labels$V1,labels=act_labels$V2) 


##assigning friendly column names to both test and training data sets
colnames(testData)<-features$V2 
colnames(trainData)<-features$V2 
colnames(testData_act)<-c("Activity") 
colnames(trainData_act)<-c("Activity") 
colnames(testData_sub)<-c("Subject") 
colnames(trainData_sub)<-c("Subject") 


##adding activity and subject columns to test data and training data respectively
testData1 <- cbind(testData_act, testData) 
testData2 <- cbind(testData_sub, testData1)
trainData1 <- cbind(trainData_act, trainData) 
trainData2 <- cbind(trainData_sub, trainData1)

##combining records from test data and training data into a single dataset
complete_dataset <-rbind(testData2,trainData2) 

##Checking results - looking for "TRUE"
nrow(complete_dataset) == (nrow(trainData2) + nrow(testData2))

##extracting the mean and standard 
measurements_mean <- sapply(complete_dataset,mean,na.rm=TRUE) 
measurements_stddev <- sapply(complete_dataset,sd,na.rm=TRUE) 

##extracting a tidy dataset with the average of each variable by activity and  subject
comp_dateset_DT <- data.table(complete_dataset) 
tidy_dataset <- comp_dateset_DT[,lapply(.SD,mean),by="Activity,Subject"] 
write.table(tidy,file="tidy_dataset.csv",sep=",",row.names = FALSE) 

##for extracting tidy dataset (ungrouped)
##write.table(complete_dataset,file="tidy_dataset.csv",sep=",",row.names = FALSE) 


################DONE!!################
