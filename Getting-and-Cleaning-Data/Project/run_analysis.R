#install.packages("downloader")
#install.packages("data.table")
#install.packages("reshape2")

#library(downloader)
#library(data.table)
#library(reshape2)

# Initialize variables for the url and zip file name 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zfile <- "Dataset.zip"

# Download and upzip folders and files
download(url, dest=zfile, mode="wb") #download as binary since it is a zipped file
unzip (zfile)

dataFilespath <- file.path("./", "UCI HAR Dataset")

# Read the subject data files

dtSubjectTrain <- fread(file.path(dataFilespath, "train", "subject_train.txt"))
dtSubjectTest  <- fread(file.path(dataFilespath, "test" , "subject_test.txt" ))

# Read the Activity label files
dtActivityLabelTrain <- fread(file.path(dataFilespath, "train", "Y_train.txt"))
dtActivityLabelTest  <- fread(file.path(dataFilespath, "test" , "Y_test.txt" ))

# Read the data files
readFile <- function (f) {
  df <- read.table(f)
  dt <- data.table(df)
}
dtActivityDataTrain <- readFile(file.path(dataFilespath, "train", "X_train.txt"))
dtActivityDataTest  <- readFile(file.path(dataFilespath, "test" , "X_test.txt" ))

# Merge the training and the test sets

dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivityLabel <- rbind(dtActivityLabelTrain, dtActivityLabelTest)
setnames(dtActivityLabe, "V1", "activityNum")
dtActivityData <- rbind(dtActivityDataTrain, dtActivityDataTest)

# Merge columns.

dtSubject <- cbind(dtSubject, dtActivityLabel)
dtActivityData <- cbind(dtSubject, dtActivityData)

# Set key.

setkey(dtActivityData, subject, activityNum)

# Extract only the mean and standard deviation

Read the features.txt file. This tells which variables in dt are measurements for the mean and standard deviation.

dtFeatures <- fread(file.path(dataFilespath, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

# Subset only measurements for the mean and standard deviation.

dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

# Convert the column numbers to a vector of variable names

dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]

#Subset these variables using variable names.

varList <- c(key(dtActivityData), dtFeatures$featureCode)
dtActivityData <- dtActivityData[, varList, with=FALSE]

# Label activity name variables (columns) from the activity_labels.txt

dtActivityNames <- fread(file.path(dataFilespath, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

# Add the descriptive activity name

dtActivityData <- merge(dtActivityData, dtActivityNames, by="activityNum", all.x=TRUE)

#Add activityName as a key.

setkey(dtActivityData, subject, activityNum, activityName)

# Transpose the data to get tidy data.

dtActivityData <- data.table(melt(dtActivityData, key(dtActivityData), variable.name="featureCode"))

# Merge activity name.

dtActivityData <- merge(dtActivityData, dtFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)

# Create new variables, activity and feature,
# that is equivalent to activityName and featureName

dtActivityData$activity <- factor(dtActivityData$activityName)
dtActivityData$feature <- factor(dtActivityData$featureName)

# Segregate features into seprarate columnsbased on featureName 

# This function will locate specific features 
# using grep and regular expressions
findCategories <- function (regex) {
  grepl(regex, dtActivityData$feature)
}

y <- matrix(seq(1, 2), nrow=2)

# Identify time and frequency domains
x <- matrix(c(findCategories("^t"), findCategories("^f")), ncol=nrow(y))
dtActivityData$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))

# Identify Accelerator and Gyro instruments
x <- matrix(c(findCategories("Acc"), findCategories("Gyro")), ncol=nrow(y))
dtActivityData$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

# Identify Body and Gravity Acceleration
x <- matrix(c(findCategories("BodyAcc"), findCategories("GravityAcc")), ncol=nrow(y))
dtActivityData$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))

# Identify Accelerator and Gyroscope instruments
x <- matrix(c(findCategories("mean()"), findCategories("std()")), ncol=nrow(y))
dtActivityData$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))

# Identify Jerk category
dtActivityData$featJerk <- factor(findCategories("Jerk"), labels=c(NA, "Jerk"))

## Identify Magnitude category
dtActivityData$featMagnitude <- factor(findCategories("Mag"), labels=c(NA, "Magnitude"))

## Features with 3 categories
y <- matrix(seq(1, 3), nrow=3)

x <- matrix(c(findCategories("-X"), findCategories("-Y"), findCategories("-Z")), ncol=nrow(y))
dtActivityData$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# Create a tidy data set with the average of 
# each variable for each activity and each subject

setkey(dtActivityData, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidyActivityData <- dtActivityData[, list(count = .N, average = mean(value)), by=key(dtActivityData)]
