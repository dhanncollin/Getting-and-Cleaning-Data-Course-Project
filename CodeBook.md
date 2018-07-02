# GETTING AND CLEANING DATA COURSE PROJECT


In this file, I will describes the variables, the data, and any transformations or work that I performed to clean up the data.

## Data Set Source

The data set was obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones while the data set for the project was obatined from https://d396qusza40orc.cloudfront.net/detdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## Data Set Information

The experiments have benn varried out with a group of 30 volunteers within an age bracket of 19 to 48 years old. Each person performed six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, while wearing a smartphone which is Samsung Galaxy S II on the waist.

Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50 Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been ramdomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


## Description of Data

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals ('t' to denote time) were captured at a constant rate of 50 Hz and the acceleration signal (tBodyAcc-XYZ) was then separated into body and gravity acceleration signals (tGravityAcc-XYZ) using a low pass Butterworth filter.

The body linear acceleration and angular velocity were derived in time to obtaion Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, and tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag, where 'f' is the frequency domain signals.

Description of abbreviations of measurements:
* t = time
* f = frequency
* Body = related to body movement
* Gravity  = acceleration of gravity
* Acc = accelerator measurement
* Gyro = groscopic measurements
* Gyro = sudden movement acceleration
* Mag = magnitude of movement
* mean and std = are calculated for each subject and activity for each mean and std measurements.

The units given are g's for the accelerometer, and rad/sec for gyro, and g/sec and rad/sec/sec for the corresponding jerks. These signals were used to estimate variables of the feature vector for each pattern: 'XYZ' is used to denote 3-axial signals in the X, Y, and Z directions. They total 33 measurements including the 3 dimensions - the X, Y, and Z axes. There are also a set of variables that are used to estimate from these signals are: mean() for Mean value and std() for Standard deviation.

## Files used though the project

Here is the list of files used through the project, unused files are not included. The dataset includes the following file:

Root Directory
* README.txt - Shorten codebook
* features_info.txt - Shows information about the variables used on the feature vector.
* features.txt - List of all features
* activity_labels.txt - Links the class labels with their activity name.
* run_analysis.R - Contains the script to execute and performed data treatment.
* tidydata.txt - Final result of the treatment of run_analysis.R

Train and Test Directory
* X_train.txt - Training set
* y_train.txt - Training labels
* X_test.txt - Test set
* y_test.txt - Test labels

## Transformation Details

1. Define the path where the data that will be used is located
      pathdata <- file.path("./Module3Data", "UCI HAR Dataset")

2. Creating and organizing the files
    ### Create list of Dataset files with file path
        Datasets <- list.files(pathdata, pattern="txt", recursive=TRUE, full.names = TRUE)

    ### Remove the not needed files
        Datasets <- Datasets[-(3:4)]

    ### Also remove the "Inertial Signals"
        Datasets <- Datasets[c(-(3:11),-(15:23))]

    ### Create list of dataset
        datalist <- NULL
          for (i in 1:length(Datasets)) {
              datalist[[i]] <- read.table(Datasets[i])
          }

    ### Create a filelist without full path for names of list
        DatasetNames <- gsub(".txt", "", list.files(pathdata,pattern="txt", recursive=TRUE, full.names = FALSE))

    ### Remove the not needed files
        DatasetNames <- DatasetNames[-(3:4)]

    ### Also remove the "Inertial Signals"
        DatasetNames <- DatasetNames[c(-(3:11),-(15:23))]

    ### Create and set the list names
        names(datalist) <- DatasetNames

2. Merges the training and the test sets to create one data set.

    ### Load the needed packages
        library(dplyr)
        library(tidyr)

    ### Read the test data 
        dataset_test <- datalist$`test/X_test`
        colnames(dataset_test) <- datalist$features[,2]

    ### Create a data frame for test data
        dataset_test <- data.frame(subject = datalist$`test/subject_test`[,1],
                           type = "test",
                           label = datalist$`test/y_test`[,1],
                           dataset_test,
                           stringsAsFactors = FALSE)

    ### Organized data frame of test data
        dataset_test2 <- dataset_test %>%
                      as_data_frame %>%
                      gather(key = features,value = value,-c(subject,type,label))

    ### Read the train data
        dataset_train <- datalist$`train/X_train`
        colnames(dataset_train) <- datalist$features[,2]

    ### Create a data frame for train data
        dataset_train <- data.frame(subject = datalist$`train/subject_train`[,1],
                            type = "train",
                            label = datalist$`train/y_train`[,1],
                            dataset_train,
                            stringsAsFactors = FALSE)

    ### Organized data frame of train data
        dataset_train2 <- dataset_train %>%
                        as_data_frame %>%
                        tidyr::gather(key = features,value = value,-c(subject,type,label))


    ### Merges the train and the test data 
        Mergedataset <- NULL
        merge_by <- names(dataset_test2)
        Mergedataset <- dplyr::full_join(dataset_test2,dataset_train2,by=merge_by) %>%
            arrange(subject)


    ### Read the Mergedataset
        Mergedataset

3. Extracts only the measurements on the mean and standard deviation for each measurement.

    ### Filter the Mergedataset by measurements on the mean and standard deviation
        dataset_mean_std <- Mergedataset %>%
            filter(grepl("mean|std", Mergedataset$features))

    ### Read the dataset_mean_std
        dataset_mean_std
      
4. Uses descriptive activity names to name the activities in the data set.

    ### Factorize the mergedataset and label
        Mergedataset$label <- factor(Mergedataset$label)

    ### Factorize the mergedataset and label using the "activity_labels"
        levels(Mergedataset$label) <- as.character(datalist$activity_labels$V2)

    ### Change to as.character
        Mergedataset$label <- as.character(Mergedataset$label)

    ### Read the Mergedataset again  
        Mergedataset

5. Appropriately labels the data set with descriptive variable names.

    ### Set appropriately labels 
        names(Mergedataset) <- c("ID","train/test","activity","features","value")

        Mergedataset$features <- gsub("^t", "time", Mergedataset$features)
        Mergedataset$features <- gsub("^f", "frequency", Mergedataset$features)  
        Mergedataset$features <- gsub("Acc", "Accelerometer", Mergedataset$features)  
        Mergedataset$features <- gsub("Gyro", "Gyroscope", Mergedataset$features)  
        Mergedataset$features <- gsub("Mag", "Magnitude", Mergedataset$features)  
        Mergedataset$features <- gsub("BodyBody", "Body", Mergedataset$features) 

    ### Read the Mergedataset again  
        Mergedataset

6. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    ### Create a tidy data of Mergedataset
        Mergedataset2 <- Mergedataset %>%
        group_by(ID,activity) %>%
        summarize(Mean = mean(value))

    ### Read the Mergedataset2  
        Mergedataset2

    ### Write table and create a "tidydata.txt"
        write.table(Mergedataset2,"tidydata.txt",row.name=FALSE)