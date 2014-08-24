library('plyr')
# load datafile
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, f))
unzip("dataset.zip")
trainSet = read.table(file="./UCI\ HAR\ Dataset/train/X_train.txt")
trainLabel = read.table(file="./UCI\ HAR\ Dataset/train/Y_train.txt")
trainSubject = read.table(file="./UCI HAR Dataset/train/subject_train.txt")
testSet = read.table(file="./UCI\ HAR\ Dataset/test/X_test.txt")
testLabel = read.table(file="./UCI\ HAR\ Dataset/test/Y_test.txt")
testSubject = read.table(file="./UCI HAR Dataset/test/subject_test.txt")
varname = read.table(file="./UCI HAR Dataset/features.txt")
activity_label = read.table(file="./UCI HAR Dataset/activity_labels.txt")
# 1.Merges the training and the test sets to create one data set.
set = rbind(trainSet, testSet)
colnames(set) <- varname$V2

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
set = set[grep("*-mean\\(\\)|*-std\\(\\)", names(set))]

# 3.Uses descriptive activity names to name the activities in the data set
label = rbind(trainLabel, testLabel)
label = merge(label, activity_label, by.x="V1", by.y="V1", all=TRUE)
colnames(label) <- c("Activity", "ActivityName")
set = cbind(set, label)

# 4.Appropriately labels the data set with descriptive variable names.
subject = rbind(trainSubject, testSubject)
colnames(subject) <- c("SubjectID")
set = cbind(set, subject)

# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_set = ddply(set, c("SubjectID", "ActivityName"), function (x) colMeans(x[1:(length(set)-3)]))
# Write tidy_set data set as a txt file created with write.table() using row.name=FALSE (do not cut and paste a dataset 
# directly into the text box, as this may cause errors saving your submission).
write.table(tidy_set, "tidydata.txt", row.names=FALSE)
