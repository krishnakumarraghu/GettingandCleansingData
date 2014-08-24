## Script Name : run_analysis.R
## Author: KrishnaKumar Raghunathan
## Version : 1.0
## Date Created : 25-Aug-2014
## Description: 
## This Script will perform the following activities:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Adds descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Module : 1 - Downloading Content for Cleansing

  # Check the Working Directory and set it to the folder where we will download the 
  # datasets for further analysis.
  pwdir <- getwd()
  setwd("E:\\R-Coursera\\data")

  # Check if the the Zip file has been downloaded successfully. If not 
  # download and unzip.
  if(!file.exists("./UCI HAR Dataset.zip"))
     {
     #Download the Training and Test datasets (if not available)
     Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(url, destfile = "UCI HAR Dataset.zip")
     unzip("UCI HAR Dataset.zip")
     }

## Module : 2 - Read required files into Dataframes

  ## Set the Directory to unzipped directory
  directory <- "E:\\R-Coursera\\data\\UCI HAR Dataset"
  
  # Read feature
  dffeature <- read.table(paste(directory, 'features.txt', sep = '\\'),header = FALSE)
  names(dffeature) <- c('feature_id', 'feature_name')
  
  # Read activity 
  dfactivity <- read.table(paste(directory, 'activity_labels.txt', sep = '\\'),header = FALSE)
  names(dfactivity) <- c('activity_id', 'activity_name')

  ## Set the Directory to test files directory
  directory <- "E:\\R-Coursera\\data\\UCI HAR Dataset\\test"
  
  # Read test_subject 
  dfsubject_test <- read.table(paste(directory, 'subject_test.txt', sep = '\\'),header = FALSE)
  names(dfsubject_test) <- c('subject_id')
  
  # Read X_test
  dfX_test <- read.table(paste(directory, 'X_test.txt', sep = '\\'),header = FALSE)
  names(dfX_test) <- dffeature$feature_name
  
  # Read Y_test
  dfY_test <- read.table(paste(directory, 'Y_test.txt', sep = '\\'),header = FALSE)
  names(dfY_test) <- c('activity_id')

  ## Set the Working Directory to training files directory
  directory <- "E:\\R-Coursera\\data\\UCI HAR Dataset\\train"
  
  # Read train_subject 
  dfsubject_train <- read.table(paste(directory, 'subject_train.txt', sep = '\\'),header = FALSE)
  names(dfsubject_train) <- c('subject_id')
  
  # Read X_train
  dfX_train <- read.table(paste(directory, 'X_train.txt', sep = '\\'),header = FALSE)
  names(dfX_train) <- dffeature$feature_name
  
  # Read Y_train
  dfY_train <- read.table(paste(directory, 'Y_train.txt', sep = '\\'),header = FALSE)
  names(dfY_train) <- c('activity_id')

## Module : 3 - Merge the training and temp data , filter for Mean & SD Columns

  # Merge Y_train/Y_test with Activity to generate meaningful activity
  dfY_trainact <- merge(dfY_train,dfactivity,by='activity_id',all=TRUE)
  dfY_testact <- merge(dfY_test,dfactivity,by='activity_id',all=TRUE)
  
  # Merge train and test tables
  dfmergeX <- rbind(dfX_train,dfX_test)
  dfmergeY <- rbind(dfY_trainact['activity_name'],dfY_testact['activity_name'])
  dfmergeSub <- rbind(dfsubject_train,dfsubject_test)
  
  # Prepare extract filter for Mean and Standard Deviation columns
  meanstdfilter <- grepl("mean|std", dffeature$feature_name)
  
  # Apply filter to merged train and test X dataset
  dfmergeXft <- dfmergeX[,meanstdfilter]

## Module : 4 - Publish Tidy dataset aggregated over subject & activity
  # Prepare tidy Dataset - non aggregate
  dftidy <- cbind(dfmergeSub,dfmergeY,dfmergeXft)
  
  # Prepare tidy Dataset aggregated by Subject and Activity
  dftidyavg <- aggregate(dftidy[,3:81],list(dftidy$subject_id,dftidy$activity_name),mean)
  names(dftidyavg)[1:2] <- c('subject', 'activity')
  
  # Set directory to the tidy dataset placement directory and export
  directory <- "E:\\R-Coursera\\data"
  write.table(dftidyavg,file=paste(directory, 'tidy.txt', sep = '\\'), sep="\t", row.names=FALSE)