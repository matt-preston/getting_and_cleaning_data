
# Download the data set
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=dataURL, destfile="dataset.zip", method="curl")
unzip('dataset.zip')

features <- read.table("./UCI HAR Dataset/features.txt")

# Extract the mean and standard deviation measurements
filteredFeatures <- grep("mean|std", features$V2)

# Read the training files
training <- read.table('./UCI HAR Dataset/train/X_train.txt', col.names=features$V2)
training <- training[, filteredFeatures]

training$Subject <- read.table('./UCI HAR Dataset/train/subject_train.txt')$V1
training$ActivityCode <- read.table('./UCI HAR Dataset/train/y_train.txt')$V1

# Read the test files
test <- read.table('./UCI HAR Dataset/test/X_test.txt', col.names=features$V2)
test <- test[, filteredFeatures]

test$Subject <- read.table('./UCI HAR Dataset/test/subject_test.txt')$V1
test$ActivityCode <- read.table('./UCI HAR Dataset/test/y_test.txt')$V1

# Merge data frames together
data <- rbind(training, test)

# Use descriptive activity names
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names=c("ActivityCode", "Activity"))
data <- merge(data, activities)

# Create a tiday data set with the average of each variable for each activity and each subject
tidy <- aggregate(data[,2:80], by=data[c("Subject", "Activity")], FUN="mean")
write.table(tidy, "tidy.txt", row.name = FALSE)

