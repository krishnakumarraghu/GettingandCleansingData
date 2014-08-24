## CodeBook

This code book describes the variables, the data, and any transformations or work that we have performed to clean up the data 

# Background

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Dataset Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

## Data Cleansing Implementation

The script ```run_analysis.R``` is implemented to perform the following activities on the datasets

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Adds descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The Implementation is performed in a 4 module approach. Note that through the code is modular, no explicit functions are used for performing the
module activities.

# Module : 1 

Here a check for the Working Directory is performed and is set to the folder where we have downloaded the datasets for further analysis.
  
  ```pwdir <- getwd()
  setwd("E:\\R-Coursera\\data")```

Further a check is performed to see ,if we have not accidentally removed the zip file and re-download in case there was an issue earlier.Once the Zip file has been downloaded successfully we proceed to unzip.
 
```if(!file.exists("./UCI HAR Dataset.zip"))
     {
     #Download the Training and Test datasets (if not available)
     Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     download.file(url, destfile = "UCI HAR Dataset.zip")
     unzip("UCI HAR Dataset.zip")
     }```

# Module : 2 

Here we proceed to read required files into intermedite Dataframes of our choice, from the .txt files.
We read the feature.txt and activity.txt files followed by all the text files under the /test and /train folders respectively. 

Note: All the variables used in this module will have a prefix of df* to indicate that they are dataframes. Each text file name is appended
to df to identify the corresponding dataframes for the files. (ie) From the example below when the file feature.txt is read as a dataframe,
the name of the dataframe will be dffeature. 

```dffeature <- read.table(paste(directory, 'features.txt', sep = '\\'),header = FALSE)
  names(dffeature) <- c('feature_id', 'feature_name')```


# Module : 3 

Here we merge the training and temp dataframes created under module 2 and filter for Mean & SD Columns. We also add descriptive names to the activities in the dataset.

For filtering out mean and SD columns we use grepl on the feature dataframe and obtain a logical vector for further processing.

```  meanstdfilter <- grepl("mean|std", dffeature$feature_name) ```
 
# Module : 4 

Here we create the tidy dataset aggregated over subject & activity and using the write.table generate the necessary file for upload.
We implement the aggregation using the the aggregate function.

``` dftidyavg <- aggregate(dftidy[,3:81],list(dftidy$subject_id,dftidy$activity_name),mean)
  names(dftidyavg)[1:2] <- c('subject', 'activity') ```