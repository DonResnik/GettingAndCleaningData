---
title: "README"
author: "Don Resnik"
date: "April 11, 2016"
output: html_document
---

## Getting and Cleaning Data Course Project
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. ppropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How to run the analysis

The programs assumes the following files are in your working directory
in a folder called 'UCI HAR Dataset'

- subject_train.txt
- subject_test.txt
- Y_train.txt
- Y_test.txt
- X_train.txt
- X_test.txt
- features.txt
- activity_labels.txt

Run 'run_analysis.R'

30 subjects performed exercise activities using wearable monoitors
the groups were split by test data and training data
the training data subjects are
1,3,5,6,7,8,11,14,15,16,17,19,21,22,23,25,26,27,28,29,30
the test data subjects are
2,4,9,10,12,13,18,20,24

First we need to combine the training and test data into one data set
the data is spread out over several files for both the training and test data

When we have all the data loaded for the training and test data we need to combine them
into one data set

Data frame dataTrainTest has 561 columns in it.  These columns are identified in the features.txt.file
we only want the rows that are the mean or standard deviation values.  So we need to get
these row numbers from the features table.  We will grep the rows out of features.txt 

Then we have to tidy up the activityId with the name of the activity
and tidy up the feature column headers by renaming the 'Vxxx' columns with 
readable names from the features.txt file

Create a list to hold the descriptions of the columns names
if the column name does not start with V, then just add it to the list
if it does start with V, substirng past the V to get the id, then replace
the id with the text name of the feature

Average of each variable for each activity and each subject
and create a summarized table grouped by the subjectId and activityName

The program will create a file called 'tidySummary.csv' that is described in CodeBook.md