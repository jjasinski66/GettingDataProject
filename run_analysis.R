
###############
## You should create one R script called run_analysis.R that does the following. 

## 1) Merges the training and the test sets to create one data set.

## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

## 3)Uses descriptive activity names to name the activities in the data set

## 4)Appropriately labels the data set with descriptive variable names. 

#3 5)From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.

##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################


## read in the TEST data 
X.test <- read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=F)
Y.test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)

## read in the subject file
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)

# combine activity and subject to the X.test
X.test <- cbind(Y.test, X.test)
X.test <- cbind(subject.test, X.test)


## read in the TRAIN data 
X.train <- read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=F)
Y.train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)

# read in the subject file
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)

# add activity and subject to X.train
X.train <- cbind(Y.train, X.train)
X.train <- cbind(subject.train, X.train)


## merge TRAIN and TEST into one frame
mergedset <- rbind(X.test, X.train)

# housecleaning
rm(X.train, X.test, Y.train, Y.test, subject.test, subject.train)


###########################################################################
# 2. Extracts only the measurements on the mean and standard deviation for  
#    each measurement.  
###########################################################################

#read the list of 561 variables 
features <- read.table("UCI HAR Dataset/features.txt", header=F)

#name the variables in the dataframe included the first two columns; 
names(mergedset)[1] <- c("subject")
names(mergedset)[2] <- c("activity")
names(mergedset)[3:563] <- as.character(features$V2) 

#get all variables that measure either "mean" or "std"
ss <- grep("mean|std", names(mergedset))

## subset frame which contains mean or standard deviation measurements
##  keep activity and subject columns as well
mergedsetsub <- mergedset[, c(1,2,ss)]

## take out the FFT variables since these use the same information as the original 
##  Keep "t*" variables:
st <- grep("^[t]", names(mergedsetsub))
mergedsetsub <- mergedsetsub[, c(1,2,st)]

## housekeeping
rm(ss, st)


###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

# read the activity lables.
l.activities <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)

#convert "activity" into descriptive factor. 
mergedsetsub$activity <- factor(mergedsetsub$activity, levels=l.activities$V1, labels=l.activities$V2)

## housekeeping
rm(l.activities)


###########################
# 4. Fix the variable names
###########################

## remove "()" and "-" from the column names.

names(mergedsetsub) <- gsub("[()]", "", names(mergedsetsub))
names(mergedsetsub) <- gsub("[-]", "_", names(mergedsetsub))



##########################################################################
# 5. Creates a second, independent tidy data set with the average of each 
#    variable  for each activity and each subject. 
##########################################################################

#calculate the mean of each variable, grouped by subject and activity. 
tidy.frame <- aggregate(mergedsetsub[,3:ncol(mergedsetsub)], by=list(mergedsetsub$activity, mergedsetsub$subject), FUN=mean)

#rename grouping variables
names(tidy.frame)[1] <- c("activity")
names(tidy.frame)[2] <- c("subject")

#save tidy data set to file. 
write.table(tidy.frame, file="tidyset.txt", row.name=FALSE)

