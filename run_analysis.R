## Getting and Cleaning Data Course Project
## mygit = istailer

library(dplyr)

filename <- "Dataset_GC_data.zip"

# Checking file
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

# Checking folder
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Merge train + test
X_merged <- rbind(x_train, x_test)
Y_merged <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Data_merged <- cbind(Subject, Y_merged, X_merged)

# Extract Mean and SD
Data_tidy <- Data_merged %>% select(subject, code, contains("mean"), contains("std"))

# Names
Data_tidy$code <- activities[Data_tidy$code, 2]

# Labels
names(Data_tidy)[2] = "activity"
names(Data_tidy) <- gsub("Acc", "Accelerometer", names(Data_tidy))
names(Data_tidy) <- gsub("Gyro", "Gyroscope", names(Data_tidy))
names(Data_tidy) <- gsub("BodyBody", "Body", names(Data_tidy))
names(Data_tidy) <- gsub("Mag", "Magnitude", names(Data_tidy))
names(Data_tidy) <- gsub("^t", "Time", names(Data_tidy))
names(Data_tidy) <- gsub("^f", "Frequency", names(Data_tidy))
names(Data_tidy) <- gsub("tBody", "TimeBody", names(Data_tidy))
names(Data_tidy) <- gsub("-mean()", "Mean", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy) <- gsub("-std()", "STD", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy) <- gsub("-freq()", "Frequency", names(Data_tidy), ignore.case = TRUE)
names(Data_tidy) <- gsub("angle", "Angle", names(Data_tidy))
names(Data_tidy) <- gsub("gravity", "Gravity", names(Data_tidy))


# Average each variable
Data_result <- Data_tidy %>% group_by(subject, activity) %>% summarise_all(funs(mean))

# Create TXT
write.table(Data_result, "TydaData_result.txt", row.name=FALSE)

#Check 
str(Data_result)


