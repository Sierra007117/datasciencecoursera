activity <- read.table("./activity_labels.txt", col.names = c("IDactivity", "activity"))
features <- read.table("./features.txt", col.names = c("IDfeature", "feature"))


# Reading data from test folder
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$feature)
y_test <- read.table("./test/y_test.txt", col.names = "code")


#Reading data from train forlder
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_train <- read.table("./train/X_train.txt", col.names = features$feature)
y_train <- read.table("./train/y_train.txt", col.names = "code")


# Unimos los datos
Xjoin <- rbind(x_test, x_train)
Yjoin <- rbind(y_test, y_train)
SubjectJoin <- rbind(subject_test, subject_train)



#MergeData, First Data
MergeData <- cbind(SubjectJoin, Yjoin, Xjoin)
MergeData <- MergeData[,grepl("subject|code|mean|std", names(MergeData))]


# Rename de the columns from DataMerge
names(MergeData) <- gsub("Acc", "Accelerometer", names(MergeData))
names(MergeData) <- gsub("Gyro", "Gyroscope", names(MergeData))
names(MergeData) <- gsub("^t", "Time", names(MergeData))
names(MergeData) <- gsub("^f", "Frequency", names(MergeData))
names(MergeData) <- gsub("angle", "Angle", names(MergeData))
names(MergeData) <- gsub("gravity", "Gravity", names(MergeData))
names(MergeData) <- gsub("BodyBody", "Body", names(MergeData))
names(MergeData)[2] <- "activity"


#FinalData, Second Data
library(dplyr)
TidyData <- group_by(.data = MergeData, subject, activity)
TidyData <- summarise_all(TidyData, funs(mean))


write.table(x = TidyData, file = "FinalTidyData.txt",row.names = FALSE)