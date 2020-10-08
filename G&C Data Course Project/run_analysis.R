datasetPath <- 'UCI HAR Dataset'
downloadDataset <- function() {
  url <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url, 'Dataset.zip')
  unzip('Dataset.zip')
}
readMergedData <- function(file, name=FALSE) {
  data <- data.frame()
  for (folder in c('test', 'train')) {
    filename <- sprintf('%s/%s/%s_%s.txt', datasetPath, folder, file, folder)
    data <- rbind(data, read.table(filename))
  }
  if (name != FALSE) {
    colnames(data) <- name
  }
  data
}
downloadDataset()
dataFeatures <- read.table(sprintf('%s/features.txt', datasetPath))
setColumnNames <- dataFeatures$V2
dataLabels <- readMergedData('y', 'activity')
dataSubjects <- readMergedData('subject', 'subject')
dataset <- readMergedData('X', setColumnNames)
activityLabels <- read.table(sprintf('%s/activity_labels.txt', datasetPath))
dataset <- dataset[grepl("mean\\(\\)|std\\(\\)", setColumnNames)]
dataset <- cbind(dataSubjects, dataLabels, dataset)
dataset$activity <- activityLabels[dataset$activity, 2]
write.table(dataset, "data.txt", sep="\t", row.names = FALSE)
tidyDataset <- aggregate(dataset, by=list(dataset$subject, dataset$activity), FUN=mean)
tidyDataset$activity <- NULL
tidyDataset$subject <- NULL
names(tidyDataset)[names(tidyDataset) == 'Group.1'] <- 'subject'
names(tidyDataset)[names(tidyDataset) == 'Group.2'] <- 'activity'
write.table(tidyDataset, "tidy_data.txt", sep="\t", row.names = FALSE)