# Getting_And_Cleaning_Data_project
Repo for project of Coursera "Getting and Cleaning Data" course

## Tasks
This R script, run_analysis.R, will read given test and train data sets, and complete the following 5 tasks:  

1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Data files
The data files can be downloaded from the following URL:  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

In order to run this script, data file directory should be present in the same directory as this script.
To do so, unzip the project files in the root directory of the project.

An example of the directory tree is as the following:  
./run_analysis.R  
./README.md  
./UCI HAR Dataset/README.txt  
......

## Output
The output of the script is a table of mean values with 180 observations and 67 variables in .txt format. 
The table can be extracted from R by read.table(path_to_file, header=TRUE)

Each observation represents a unique combination of 1 of 6 activity types and 1 of 30 subjects.
The first two columns of the table represent activity types and subject numbers, the rest 65 columns are the means of measurements (means or standard deviations) obtained from original data files.

See CookBook.md for more detils on descriptions of variables.
