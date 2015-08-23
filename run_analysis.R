###
### This R script, run_analysis.R, will read given test and train data sets,
### and complete the following 5 tasks:
### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for
###    each measurement. 
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive variable names. 
### 5. From the data set in step 4, creates a second, independent tidy data
###    set with the average of each variable for each activity and each subject.
###

# Locate data files
# Root of the data files is called "UCI HAR Dataset", located in the same
#   directory as this script, e.g. "./UCI HAR Dataset/README.txt"
data_dir <- "./UCI HAR Dataset"

# 1. Merge given data sets into one data set
# First, merge columns of each of test and train dataset with test subjects
#   and activities
test_data <- read.table(paste0(data_dir, "/test/X_test.txt"))
test_data <- cbind(test_data,
                   read.table(paste0(data_dir, "/test/subject_test.txt")),
                   read.table(paste0(data_dir, "/test/y_test.txt")))
train_data <- read.table(paste0(data_dir, "/train/X_train.txt"))
train_data <- cbind(train_data,
                    read.table(paste0(data_dir, "/train/subject_train.txt")),
                    read.table(paste0(data_dir, "/train/y_train.txt")))
# Second, merge observations (rows) of test and train datasets
tidyset <- rbind(test_data, train_data)
# Remove temporary datasets to save memory
remove(test_data, train_data)

# 2. Extract only mean and standard deviation of each measurements by subsetting
#    the merged dataset
# According to the cookbook, extract the following columns of mean and std
mean_std_cols <- c(1:6,     # tBodyAcc
                   41:46,   # tGravityAcc
                   81:86,   # tBodyAccJerk
                   121:126, # tBodyGyro
                   161:166, # tBodyGyroJerk
                   201:202, # tBodyAccMag
                   214:215, # tGravityAccMag
                   227:228, # tBodyAccJerkMag
                   240:241, # tBodyGyroMag
                   253:254, # tBodyGyroJerkMag
                   266:271, # fBodyAcc
                   345:350, # fBodyAccJerk
                   424:429, # fBodyGyro
                   503:504, # fBodyAccMag
                   516:517, # fBodyBodyAccJerkMag
                   529:530, # fBodyBodyGyroMag
                   542:543) # fBodyBodyGyroJerkMag
# Also include subject and activity names
tidyset <- tidyset[, c(mean_std_cols, ncol(tidyset)-1, ncol(tidyset))]

# 3. Use descriptive names to name activities
# First, load table from activity label file
act_labels <- read.table(paste0(data_dir, "/activity_labels.txt"))
names(act_labels) <- c("Activity.Num", "Activity")
# Second, merge dataset with the activity name data frame by activity numbers
act_col_x <- tail(colnames(tidyset), 1)
tidyset <- merge(x = tidyset, by.x = act_col_x,
                 y = act_labels, by.y = "Activity.Num")
# Remove the activity number column
tidyset[act_col_x] <- NULL

# 4. Use descriptive names for all variables
# First, load table of variable names
var_names <- read.table(paste0(data_dir, "/features.txt"))
# Second, re-format the names
# Only need the selected rows and 2nd column as names
var_names <- var_names[mean_std_cols, 2]
# Removing "()" and replacing "-" with "."
var_names <- gsub("\\(\\)", "", var_names)
var_names <- gsub("-", ".", var_names)
# Rename the dataset
names(tidyset) <- c(as.character(var_names),
                    "Subject.Number", "Activity.Type")

# 5. Create a new data set of means of each variables of each activity
#    and each subject
library(dplyr)
tidyset2 <- aggregate(tidyset[, 1:(ncol(tidyset)-2)],
                      list(tidyset$Activity.Type, tidyset$Subject.Number),
                      mean)
names(tidyset2)[1:2] <- c("Activity.Type", "Subject.Number")
write.table(tidyset2, file = "./data_mean.txt", row.name = FALSE)
