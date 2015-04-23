## Load the required package
library(reshape2)

# download the data and save it into the data subfolder
require("R.utils")

if(!file.exists("./data")){dir.create("./data")}
# download file
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/UCI.zip")){download.file(Url, destfile = "./data/UCI.zip")}
# unzip file
unzip("./data/UCI.zip",exdir = "./data" )

# Reading subjects

subject.test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", header=FALSE, col.names=c("Subject.ID"))
subject.train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", header=FALSE, col.names=c("Subject.ID"))
str(subject.test)
summary(subject.test)
table(subject.test)
table(subject.train)

# Reading labels
y.test <- read.table("data/UCI HAR Dataset/test/y_test.txt", header=FALSE, col.names=c("Activity"))
y.train <- read.table("data/UCI HAR Dataset/train/y_train.txt", header=FALSE, col.names=c("Activity"))
str(y.test)
head(y.test)


# Reading features
features <- read.table("data/UCI HAR Dataset/features.txt", header=FALSE, as.is=TRUE, col.names=c("Featire.ID", "Featire.Name"))
str(features)


# Reading data set and label the X. file variable (column) names. This takes time.
X.test <- read.table("data/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", col.names=features$Featire.Name)
X.train <- read.table("data/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", col.names=features$Featire.Name)
str(X.train)
summary(X.test)

# X. files have 561 variables whose column names are in the "feature" second column.


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. (Before mergering, subset the dataset and save time and space.) )

# Getting indexes of measurement names with std() and mean()
mean.std.index <- grep(".*mean\\(\\)|.*std\\(\\)", features$Featire.Name)
# 66 variable related to mean and std.
str(mean.std.index)
# Getting data by indexes. now X. file only have 66 variables which .
X.test <- X.test[, mean.std.index]
X.train <- X.train[, mean.std.index]
head(X.test)

# Setting subjects and labels to data set: 2947 test observation; 7352 train observation
X.test$Subject.ID <- subject.test$Subject.ID
X.train$Subject.ID <- subject.train$Subject.ID

# Setting activity and labels to data set: 2947 test observation; 7352 train observation
X.test$Activity <- y.test$Activity
X.train$Activity <- y.train$Activity


# 1. Merges the training and the test sets to create one data set.
# 66 measurement varaibles and subject.ID and Activity factor.
X.data <- rbind(X.test, X.train)
names(X.data)
head(X.data)

# 3. Uses descriptive activity names to name the activities in the data set
activity.labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", header=F, col.names=c("Activity", "Activity.Name"))
# There are 6 activity, first three are active, and later three are still.
# WALKING; WALKING_UPSTAIRS; WALKING_DOWNSTAIRS; SITTING; STANDING; LAYING   
activity.labels
# factor
activity.labels$Activity.Name <- as.factor(activity.labels$Activity.Name)

# 4. Appropriately labels the data set with descriptive activity names: 
# WALKING; WALKING_UPSTAIRS; WALKING_DOWNSTAIRS; SITTING; STANDING; LAYING            
X.data$Activity <- factor(X.data$Activity, levels = 1:6, labels = activity.labels$Activity.Name)
head(X.data)
names(X.data)
# Transform all the column name to readable name. Shorten the variable name for easy reading; appropriately labels the data set with readable name
column.names <- colnames(X.data)
# Get rid of the .
column.names <- gsub("\\.+mean\\.+", column.names, replacement="Mean")
column.names <- gsub("\\.+std\\.+", column.names, replacement="Std")
# Give short name a full explaination
column.names <- gsub("Mag", column.names, replacement="Magnitude")
column.names <- gsub("Acc", column.names, replacement="Accelerometer")
column.names <- gsub("Gyro", column.names, replacement="Gyroscope")
column.names
# Put back to X. file
colnames(X.data) <- column.names

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
meltdata <- melt(X.data, id.vars = c("Activity", "Subject.ID"))
tidydata <- dcast(meltdata, Activity + Subject.ID ~ variable, mean)
head(meltdata)
# Get 180 (=30*6) observations of 30 subjects' 6 activities.
# Each subject has 6 activities. Each activity has 66 features.
head(tidydata)
table(tidydata$Subject.ID)
# 5.1 Save tidy data set
write.table(tidydata, "tidydata.txt", row.names = FALSE)
