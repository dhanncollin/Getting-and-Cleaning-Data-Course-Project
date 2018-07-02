# Define the path where the data that will be used is located
      pathdata <- file.path("./Module3Data", "UCI HAR Dataset")

# Creating and organizing the files
    # Create list of Dataset files with file path
      Datasets <- list.files(pathdata, pattern="txt", recursive=TRUE, full.names = TRUE)

    # Remove the not needed files
      Datasets <- Datasets[-(3:4)]

    # Also remove the "Inertial Signals"
      Datasets <- Datasets[c(-(3:11),-(15:23))]

    # Create list of dataset
      datalist <- NULL
        for (i in 1:length(Datasets)) {
              datalist[[i]] <- read.table(Datasets[i])
        }

    # Create a filelist without full path for names of list
      DatasetNames <- gsub(".txt", "", list.files(pathdata,pattern="txt", recursive=TRUE, full.names = FALSE))

    # Remove the not needed files
      DatasetNames <- DatasetNames[-(3:4)]

    # Also remove the "Inertial Signals"
      DatasetNames <- DatasetNames[c(-(3:11),-(15:23))]

    # Create and set the list names
      names(datalist) <- DatasetNames

## OBJECTIVE 1: Merges the training and the test sets to create one data set.

    # Load the needed packages
      library(dplyr)
      library(tidyr)

    # Read the test data 
      dataset_test <- datalist$`test/X_test`
      colnames(dataset_test) <- datalist$features[,2]

    # Create a data frame for test data
      dataset_test <- data.frame(subject = datalist$`test/subject_test`[,1],
                           type = "test",
                           label = datalist$`test/y_test`[,1],
                           dataset_test,
                           stringsAsFactors = FALSE)

    # Organized data frame of test data
      dataset_test2 <- dataset_test %>%
                      as_data_frame %>%
                      gather(key = features,value = value,-c(subject,type,label))

    # Read the train data
      dataset_train <- datalist$`train/X_train`
      colnames(dataset_train) <- datalist$features[,2]

    # Create a data frame for train data
      dataset_train <- data.frame(subject = datalist$`train/subject_train`[,1],
                            type = "train",
                            label = datalist$`train/y_train`[,1],
                            dataset_train,
                            stringsAsFactors = FALSE)

    # Organized data frame of train data
      dataset_train2 <- dataset_train %>%
                        as_data_frame %>%
                        tidyr::gather(key = features,value = value,-c(subject,type,label))


    # Merges the train and the test data 
      Mergedataset <- NULL
      merge_by <- names(dataset_test2)
      Mergedataset <- dplyr::full_join(dataset_test2,dataset_train2,by=merge_by) %>%
          arrange(subject)

    # Read the Mergedataset
      Mergedataset

## OBJECTIVE 2: Extracts only the measurements on the mean and standard deviation for each measurement.

    # Filter the Mergedataset by measurements on the mean and standard deviation
      dataset_mean_std <- Mergedataset %>%
        filter(grepl("mean|std", Mergedataset$features))

    # Read the dataset_mean_std
      dataset_mean_std
      
## OBJECTIVE 3: Uses descriptive activity names to name the activities in the data set.

    # Factorize the mergedataset and label
      Mergedataset$label <- factor(Mergedataset$label)

    # Factorize the mergedataset and label using the "activity_labels"
      levels(Mergedataset$label) <- as.character(datalist$activity_labels$V2)

    # Change to as.character
      Mergedataset$label <- as.character(Mergedataset$label)

    # Read the Mergedataset again  
      Mergedataset

## OBJECTIVE 4: Appropriately labels the data set with descriptive variable names.

    # Set appropriately labels 
      names(Mergedataset) <- c("ID","train/test","activity","features","value")

      Mergedataset$features <- gsub("^t", "time", Mergedataset$features)
      Mergedataset$features <- gsub("^f", "frequency", Mergedataset$features)  
      Mergedataset$features <- gsub("Acc", "Accelerometer", Mergedataset$features)  
      Mergedataset$features <- gsub("Gyro", "Gyroscope", Mergedataset$features)  
      Mergedataset$features <- gsub("Mag", "Magnitude", Mergedataset$features)  
      Mergedataset$features <- gsub("BodyBody", "Body", Mergedataset$features) 

    # Read the Mergedataset again  
      Mergedataset

## OBJECTIVE 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    # Create a tidy data of Mergedataset
      Mergedataset2 <- Mergedataset %>%
      group_by(ID,activity) %>%
      summarize(Mean = mean(value))

    # Read the Mergedataset2  
      Mergedataset2

    # Write table and create a "tidydata.txt"
      write.table(Mergedataset2,"tidydata.txt",row.name=FALSE)