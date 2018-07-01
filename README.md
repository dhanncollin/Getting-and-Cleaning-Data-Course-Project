## GETTING AND CLEANING DATA COURSE PROJECT

This repository contains the following files:

* README.md which provides an overview of the data set and how it was created.
* CodeBook.md (Code Book) which describes the contents of the data, data variables, tranformations details that are used to generate the data.
* run_analysis.R which contains R script that was used to create the data set.

The data set was obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones while the data set for the project was obatined from https://d396qusza40orc.cloudfront.net/detdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip which describes how the data was initially collected.

### Transformation Details

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
