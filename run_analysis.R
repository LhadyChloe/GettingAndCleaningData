#Download File
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
 
#Local data file
dataFileZIP <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"

#Make a directory
dirFile <- "./UCI HAR Dataset"
 
tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"
 
tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"

#Download the dataset
 
if (file.exists(dataFileZIP) == FALSE) {download.file(fileURL, destfile = dataFileZIP)}
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 Mb)
opened URL
downloaded 59.7 Mb

#Decompress data file
if (file.exists(dirFile) == FALSE) {unzip(dataFileZIP)}
 
###1###
#1 Merges the training and the test sets to create one data set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
 
#Combine train and test data table
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
z <- rbind(subject_train, subject_test)

###2###
#2 Extracts only the measurements on the mean and standard deviation for each measurement 
#Read the feature file
features <- read.table("./UCI HAR Dataset/features.txt")

#Making feature column
names(features) <- c('feat_id', 'feat_name')
 
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name)
x <- x[, index_features] 
 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))
 
###3###
#3 Uses descriptive activity names to name the activities in the data set
 
###4###
#4 Appropriately labels the data set with descriptive variable names. 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]
 
names(y) <- "Activity"
names(s) <- "Subject"
 
#Combines the tables
tidyDataSet <- cbind(s, y, x)
 
###5###
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"
