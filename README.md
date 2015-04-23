# GettingDataProject
Course Project for Data Science Coursera Getting Data

###############
 You should create one R script called run_analysis.R that does the following. 

 1) Merges the training and the test sets to create one data set.

 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

 3)Uses descriptive activity names to name the activities in the data set

 4)Appropriately labels the data set with descriptive variable names. 

 5)From the data set in step 4, creates a second, independent tidy data set with the average 
    of each variable for each activity and each subject.
##################################################################
 1. Merges the training and the test sets to create one data set.
##################################################################


1) read the TEST data 
2) combine activity and subject to the Test data

3) read the TRAIN data 
4) read subject file

5) add activity and subject to Train Data

6) merge TRAIN and TEST into one dataframe

###########################################################################
 2. Extracts only the measurements on the mean and standard deviation for  
    each measurement.  
###########################################################################

1) read the list of 561 variables 

2) name the variables in the dataframe includind the first two columns; 

3) extract all variables that measure either "mean" or "std"
    subset frame to those columns which contain mean or standard deviation measurements
    preserve activity and subject columns as well

4) take out the FFT variables , Keep "t*" variables:



###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

1) read the levels and lables of the activities

2) convert "activity" into descriptive factor. 


####################################
 4. Fix the remaining variable names
####################################

1) remove parenthesis "()" and "-" from the names.


##########################################################################
 5. Creates a second, independent tidy data set with the average of each 
    variable  for each activity and each subject. 
##########################################################################

1) calculate the mean of each variable, grouped by subject and activity. 

2) rename grouping variables

3) save tidy data set to file. 