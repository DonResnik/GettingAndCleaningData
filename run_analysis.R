library(dplyr)
# don't forget to set your working directory
# setwd(pathToYourLocalUCI HAR Dataset)
pathToFiles <- file.path(getwd(), "UCI HAR Dataset")

# 30 subjects performed exercise activities using wearable monoitors
# the groups were split by test data and training data
# the training data subjects are
# 1,3,5,6,7,8,11,14,15,16,17,19,21,22,23,25,26,27,28,29,30
# the test data subjects are
# 2,4,9,10,12,13,18,20,24

# first we need to combine the training and test data into one data set
# the data is spread out over several files for both the training and test data
# load the subject files into data tables
trainSubject <- read.table(file.path(pathToFiles, "train", "subject_train.txt"))
testSubject  <- read.table(file.path(pathToFiles, "test" , "subject_test.txt" ))

# load the activity files
trainActivity <- read.table(file.path(pathToFiles, "train", "Y_train.txt"))
testActivity  <- read.table(file.path(pathToFiles, "test" , "Y_test.txt" ))

# load the data files
trainData <- read.table(file.path(pathToFiles, "train", "X_train.txt"))
testData <- read.table(file.path(pathToFiles, "test" , "X_test.txt" ))

# now that we have all the data loaded for the training and test data we need to combine them
# into one data set

# combine the subject rows and rename column header
subjectTrainTest <- rbind(trainSubject, testSubject)
colnames(subjectTrainTest) <- c("subjectId")

# combine the activity rows and rename column header
activityTrainTest <- rbind(trainActivity, testActivity)
colnames(activityTrainTest) <- c("activityId")

#1.  Merges the training and the test sets to create one data set.
subjectActivity <- cbind(subjectTrainTest, activityTrainTest)

# combine the data rows 
dataTrainTest <- rbind(trainData, testData)

# 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
# dataTrainTest has 561 columns in it.  These columns are identified in the features.txt.file
# we only want the rows that are the mean or standard deviation values.  So we need to get
# these row numbers from the features table.  We will grep the rows out of features.txt 

#load the features table
features <- read.table(file.path(pathToFiles, "features.txt"))
colnames(features) <- c("featureId", "featureName")

# grep out mean and sd cols
featuresMeanSd <- grep("mean\\(\\)|std\\(\\)", features$featureName)

# featureMeanSid now has all the column numbers for each mean and sd column.  If we prepend 
# each number with 'V' they will be an exact match for the data columns so we can easily
# filter them out of the current data set
featuresMeanSdToMatch <- paste0("V", featuresMeanSd)

# now we can use featuresMeanSdToMatch to filter out the rows we do not want
# subjectActivityData
featuresMeanSdCols <- c(dataTrainTest, featuresMeanSdToMatch)
filteresDataTrainTest <- dataTrainTest[, featuresMeanSdToMatch]

# combine the columns of the data sets into one data set
subjectActivityData <- cbind(subjectActivity,filteresDataTrainTest)
subjectActivityDataArrange <- arrange(subjectActivityData,subjectId,activityId)

# 3. Uses descriptive activity names to name the activities in the data set
# now we have to tidy up the activityId with the name of the activity
activityNames <- read.table(file.path(pathToFiles, "activity_labels.txt"))
colnames(activityNames) <- c("activityId", "activityName")
subjectActivityNameMerge <- merge(activityNames, subjectActivityDataArrange, by="activityId", all.x=TRUE)

# remove the activityId column and change the column position to put it in the order
# subjectId, activityName, mean and sd values
subjectActivityNameMerge <- subjectActivityNameMerge[, c(3,2,4:ncol(subjectActivityNameMerge))]

# 4.  Appropriately labels the data set with descriptive variable names.
# now tidy up the feature column headers by renaming the 'Vxxx' columns with 
# readable names from the features.txt file
# make a data frame from the result of the grep 
# that filtered out the mean and sd columns 
featuresMeanSddf <- data.frame(featuresMeanSd)

# featureMatch is the id and featureName for every mean and sd colmn
for (i in featuresMeanSddf) {
  featureMatch <- features[i,]
}
# create a list to hold the descriptions of the columns names
# if the column name does not start with V, then just add it to the list
# if it does start with V, substirng past the V to get the id, then replace
# the id with the text name of the feature
namesToChange <-names(subjectActivityNameMerge)
updatedColNames <- list()
for (j in namesToChange) {
  if (grepl("^V",j)) {
    c <- substring(j,2)
    # get the text name from the second column of the appropriate row
    newName <-featureMatch[c,2]
    # remove the "()-" from the matched names to tidy them up more
    newName <-gsub("\\(\\)-","",newName)
    updatedColNames <- c(updatedColNames,as.character(newName))
  }
  else {
    # this column name is already in text form, so just add it as is
    updatedColNames <- c(updatedColNames,j)
  }
}
# after looping through all the column names, replace the column names with the 
# updated names
colnames(subjectActivityNameMerge) <- updatedColNames

# 5.  From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
# now create a summarized table grouped by the subjectId and activityName
summaryData <- subjectActivityNameMerge %>% group_by(subjectId,activityName) %>% 
  summarise_each(funs(mean))

save(subjectActivity,dataTrainTest,features,featuresMeanSdToMatch,subjectActivityDataArrange,subjectActivityNameMerge,summaryData,file='myfile.Rda')

# save the summary data frame in a file called tidySummary.csv
write.csv(summaryData,"tidySummary.csv")