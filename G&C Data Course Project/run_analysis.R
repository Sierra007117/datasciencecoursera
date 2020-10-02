library(reshape2)

## 1. Getting the data from the web and saving it 
rawDataDir <- "./rawData"
rawDataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataPath <- paste0(rawDataDir, "/rawData.zip")
dataDir <- "./data"

if (!file.exists(rawDataDir)){
  # downloading data 
  dir.create(rawDataDir)
  download.file(url = rawDataURL, destfile = rawDataPath)
}

if(!file.exists(dataDir)){
  #unziping data 
  dir.create(dataDir)
  unzip(rawDataPath, exdir = dataDir)
}


## 2. Merging training and test sets
# reading training sets 
X_train <- read.table(paste0(dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste0(dataDir, "/UCI HAR Dataset/train/y_train.txt"))
subject_train <- read.table(paste0(dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

# reading test sets 
X_test <- read.table(paste0(dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste0(dataDir, "/UCI HAR Dataset/test/y_test.txt"))
subject_test <- read.table(paste0(dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

# merging training and test set 
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

## 3. Naming the features 
# reading in features names
features <- read.table(paste0(dataDir, "/UCI HAR Dataset/features.txt"))
# naming features in the X_data 
names(X_data) <- features$V2


## 4. Extract measurements on the mean and the standard deviation for each measurment 
extracted_col <- grep("mean\\(|std\\(", names(X_data))
data <- X_data[extracted_col]


## 5. Using describtive activity names 
labels <- read.table(paste0(dataDir, "/UCI HAR Dataset/activity_labels.txt"), stringsAsFactors = FALSE)
data$activity <- factor(y_data$V1, levels=labels$V1, labels=labels$V2)
data$subject <- as.factor(subject_data$V1)

## 6. Appropiatly name the variables 
names(data) <- gsub("-", "", names(data))
names(data) <- gsub("\\(\\)", "", names(data))
names(data) <- gsub("mean", "Mean", names(data))
names(data) <- gsub("std", "Std", names(data))


## 7. Create a data set with the average of each variable for each activity and each subject 
dataMelt <- melt(data, id = c("activity", "subject"))
tidy_data <- dcast(dataMelt, activity + subject ~ variable, mean)

#Saving the tidy data set 
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)

