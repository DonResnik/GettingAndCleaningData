---
title: "CodeBook"
author: "Don Resnik"
date: "April 11, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
if(file.exists("myFile.Rda")){
  load("myFile.Rda")} 
```

## 1.  Merges the training and the test sets to create one data set.
Combine the rows (rbind) of:

* subject train and test 

* Y train and test (activity data) 

* X train and test (result data) 

The subject and activity data are shown in a single talbe (cbind).  The data for the train and test results is shown in the table below that.

```{r}
str(subjectActivity)
head(subjectActivity)
str(dataTrainTest)
```

## 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
Use regex to extract the 'mean' and 'sd' columns from the 'features'.  Notice that rows are skipped that don't hold mean or sd values.  This is derived from mapping the names in the features list to the id in the 'Vxx' column names.

```{r}
str(features)
head(features)
str(featuresMeanSdToMatch)
head(featuresMeanSdToMatch,8)
```

Filter out the feature columns for 'mean' and 'sd' values
```{r}
str(subjectActivityDataArrange)
head(subjectActivityDataArrange)
```

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
Map the activity names to the activity column and map feature names to the 'Vxx' columns
```{r}
str(subjectActivityNameMerge)
head(subjectActivityNameMerge)
```

## 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```{r}
str(summaryData)
head(summaryData)
```