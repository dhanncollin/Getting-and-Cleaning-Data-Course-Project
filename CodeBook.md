## GETTING AND CLEANING DATA COURSE PROJECT


In this file, I will describes the variables, the data, and any transformations or work that I performed to clean up the data.

### Data Set Source

The data set was obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones while the data set for the project was obatined from https://d396qusza40orc.cloudfront.net/detdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### Data Set Information

The experiments have benn varried out with a group of 30 volunteers within an age bracket of 19 to 48 years old. Each person performed six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, while wearing a smartphone which is Samsung Galaxy S II on the waist.

Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50 Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been ramdomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Description of Data

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

### Files used though the project

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

### Transfromation Details

1. Define the path where the data that will be used is located
    
    pathdata <- file.path("./Module3Data", "UCI HAR Dataset")
    files <- list.files(pathdata, recursive = TRUE)

2. Read data from the files into the variables
    
    # Read the Activity Files
    ActivityTest <- read.table(file.path(pathdata, "test", "Y_test.txt"), header = FALSE)
    ActivityTrain <- read.table(file.path(pathdata, "train", "Y_train.txt"), header = FALSE)  

    # Read the Subject Files
    SubjectTrain <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)
    SubjectTest <- read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)  

    # Read the Features Files
    FeaturesTest <- read.table(file.path(pathdata, "test", "x_test.txt"), header = FALSE)
    FeaturesTrain <- read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)  

3. OBJECTIVE 1: Merges the training and the test sets to create one data set.
    
    # Creating data tables by rows
    Subject <- rbind(SubjectTrain, SubjectTest)
    Activity <- rbind(ActivityTrain, ActivityTest)  
    Features <- rbind(FeaturesTrain, FeaturesTest)  

    # Setting the names of variables
    names(Subject) <- c("subject")
    names(Activity) <- c("activity") 
    FeaturesNames <- read.table(file.path(pathdata, "features.txt"),head=FALSE)  
    names(Features) <- FeaturesNames$V2  

    # Merge the test and train dataset into one dataframe
    CombinedData <- cbind(Subject, Activity)
    Data <- cbind(Features, CombinedData)  

4. OBJECTIVE 2: Extracts only the measurements on the mean and standard deviation for each measurement.
    
    # Subset features names by measurements on the mean and standard deviation
    subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

    # Subset the CombinedData by selected names of features
    selectedNames <- c(as.character(subFeaturesNames), "subject", "activity" )

5. OBJECTIVE 3: Uses descriptive activity names to name the activities in the data set.
    
    # Read the activity names
    activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)

    # Factorize variable "activity" in the data frame "Data" using descriptive names
    Data$activity <- factor(Data$activity, labels = activityLabels[,2])

6. OBJECTIVE 4: Appropriately labels the data set with descriptive variable names.
    
    names(Data) <- gsub("^t", "time", names(Data))
    names(Data) <- gsub("^f", "frequency", names(Data))  
    names(Data) <- gsub("Acc", "Accelerometer", names(Data))  
    names(Data) <- gsub("Gyro", "Gyroscope", names(Data))  
    names(Data) <- gsub("Mag", "Magnitude", names(Data))  
    names(Data) <- gsub("BodyBody", "Body", names(Data))  

7. OBJECTIVE 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    # Load the "plyr" packages and create a new sataset. Then, used write.table to create a tidy data set.
    library(plyr)
    Data2 <- aggregate(. ~subject + activity, Data, mean)
    Data2 <- Data2[order(Data2$subject,Data2$activity),]
    write.table(Data2, file = "tidydata.txt", row.name=FALSE)