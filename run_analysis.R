

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


##write.table(complete_dataset,file="tidy_dataset.csv",sep=",",row.names = FALSE) 



################DONE!!################
