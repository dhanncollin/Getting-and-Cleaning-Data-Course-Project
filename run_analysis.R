## Define the path where the data that will be used is located
    pathdata <- file.path("./Module3Data", "UCI HAR Dataset")
    files <- list.files(pathdata, recursive = TRUE)

## Read data from the files into the variables
    # Read the Activity Files
    ActivityTest <- read.table(file.path(pathdata, "test", "Y_test.txt"), header = FALSE)
    ActivityTrain <- read.table(file.path(pathdata, "train", "Y_train.txt"), header = FALSE)  

    # Read the Subject Files
    SubjectTrain <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)
    SubjectTest <- read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)  

    # Read the Features Files
    FeaturesTest <- read.table(file.path(pathdata, "test", "x_test.txt"), header = FALSE)
    FeaturesTrain <- read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)  

## OBJECTIVE 1: Merges the training and the test sets to create one data set.
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

## OBJECTIVE 2: Extracts only the measurements on the mean and standard deviation for each measurement.
    # Subset features names by measurements on the mean and standard deviation
    subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

    # Subset the CombinedData by selected names of features
    selectedNames <- c(as.character(subFeaturesNames), "subject", "activity" )

## OBJECTIVE 3: Uses descriptive activity names to name the activities in the data set.
    # Read the activity names
    activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)

    # Factorize variable "activity" in the data frame "Data" using descriptive names
    Data$activity <- factor(Data$activity, labels = activityLabels[,2])

    # test print
    head(Data$activity, 30)

## OBJECTIVE 4: Appropriately labels the data set with descriptive variable names.
    names(Data) <- gsub("^t", "time", names(Data))
    names(Data) <- gsub("^f", "frequency", names(Data))  
    names(Data) <- gsub("Acc", "Accelerometer", names(Data))  
    names(Data) <- gsub("Gyro", "Gyroscope", names(Data))  
    names(Data) <- gsub("Mag", "Magnitude", names(Data))  
    names(Data) <- gsub("BodyBody", "Body", names(Data))  

    # Check
    names(Data)

## OBJECTIVE 5: From the data set in step 4, creates a second, independent tidy data set
    ## with the average of each variable for each activity and each subject.

    # Load the "plyr" packages and create a new sataset. Then, used write.table to create a tidy data set.
    library(plyr)
    Data2 <- aggregate(. ~subject + activity, Data, mean)
    Data2 <- Data2[order(Data2$subject,Data2$activity),]
    write.table(Data2, file = "tidydata.txt", row.name=FALSE)