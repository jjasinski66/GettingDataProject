# read feature names
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table('features.txt', stringsAsFactors=F, col.names=c('id', 'name')) $name
colClasses <- grepl('-(mean|meanFreq|std)\\(', features)
colClasses <- ifelse(colClasses, 'numeric', 'NULL')

# load data of selected features
# 4. Appropriately label the data set with descriptive variable names.
train <- read.table('train/X_train.txt', col.names=features, colClasses=colClasses, check.names=F)
test <- read.table('test/X_test.txt', col.names=features, colClasses=colClasses, check.names=F)

train <- cbind(read.table('train/y_train.txt', col.names='activity'), train)
test <- cbind(read.table('test/y_test.txt', col.names='activity'), test)

train <- cbind(read.table('train/subject_train.txt', col.names='subject'), train)
test <- cbind(read.table('test/subject_test.txt', col.names='subject'), test)

# 1. Merge the training and the test sets to create one data set.
data <- rbind(train, test)

# 3. Use descriptive activity names to name the activities in the data set
labels <- read.table('activity_labels.txt', col.names=c('id', 'name'))
data$activity <- factor(data$activity, levels=labels$id, labels=labels$name)

# 5. Create a tidy data set with the average of each variable for each activity and each subject.
tidy <- aggregate(. ~ activity + subject, data, mean)

# restore working directory
setwd(wd)

# save result
write.table(tidy, 'averages.txt', row.names=F)
