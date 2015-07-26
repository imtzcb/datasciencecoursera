# Getting and Cleaning Data - Course Project
Author: Illich Martinez (<https://github.com/imtzcb/datasciencecoursera/Getting-and-Cleaning-Data>)  
Date: July 25, 2015

Project Definition
-------------------

>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a **tidy data set** as described below, 2) a link to a Github repository with your **script for performing the analysis**, and 3) a **code book** that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a **README.md** in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

>Here are the data for the project: 

>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

>You should create one R script called **run_analysis.R** that does the following:  
>1. Merges the training and the test sets to create one data set.  
>2. Extracts only the measurements on the mean and standard deviation for each measurement.  
>3. Uses descriptive activity names to name the activities in the data set  
>4. Appropriately labels the data set with descriptive variable names.  
>5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Tidy-data Preparation Process
-----------------------------
1. Install and load all required packages
 * downloader
 * data.table
 * reshape2
2. Set working directory
3. Download and unzip data files
4. Read the subject, activity labels and data files (both training and test)
5. Merge the training and test data sets (for each activity and subject)
6. Join the activity and subject
7. Extract only the mean and standard deviation
  * Subset only measurements for the mean and standard deviation
  * Convert the column numbers to a vector of variable names
  * Subset these variables using variable names
  * Label activity name variables (columns) from the activity_labels.txt
8. Label activity name variables (columns) from the activity_labels.txt
  * Add the descriptive activity name
  * Use activityName as a key
  * Transpose the data to get tidy data
  * Merge activity name
  * Create new variables, activity and feature, that is equivalent to activityName and featureName
  * Classify the measurement by time/frequency domain, Instruments, Acceleration type, etc.
9. Create a tidy data set with the average of each variable for each activity and each subject
10. Export tidy data set to a file
