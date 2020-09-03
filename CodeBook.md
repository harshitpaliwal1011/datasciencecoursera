## Getting and Cleaning data course project</br>
### **Preparation of data for tasks**
The `run_analysis.R` script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition. 

* Download the dataset
```
if(!file.exists("./dataset.zip")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl,destfile = "./dataset.zip")
  unzip("./dataset.zip")                 
  print("File downloaded and unzipped")
} else {
  print("File already present")
```  
Dataset is downloaded and extracted under the folder called `UCI HAR Dataset`

* Create the path variable to assign for reading data
`pathfile <- file.path("UCI HAR Dataset") `

* Read all the data one by one in different variables
```
# Firstly feature and activity labels

features <- read.table(file.path(pathfile,"features.txt"),header = F)
activity_lables <- read.table(file.path(pathfile,"activity_labels.txt"),header = F)

# Now train data

x_train <- read.table(file.path(pathfile,"train","X_train.txt"),header = F)
y_train <- read.table(file.path(pathfile,"train","y_train.txt"),header = F)
subject_train <- read.table(file.path(pathfile,"train","subject_train.txt"),header = F)

# Then test data

x_test <- read.table(file.path(pathfile,"test","X_test.txt"),header = F)
y_test <- read.table(file.path(pathfile,"test","y_test.txt"),header = F)
subject_test <- read.table(file.path(pathfile,"test","subject_test.txt"),header = F)

```

* Information about assigned data to variables

`features <- features.txt : 561 rows, 2 columns`</br>
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.
`activity_labels <- activity_labels.txt : 6 rows, 2 columns`</br>
List of activities performed when the corresponding measurements were taken and its codes (labels)
`subject_test <- test/subject_test.txt : 2947 rows, 1 column`</br>
Contains test data of 9/30 volunteer test subjects being observed</br>
`x_test <- test/X_test.txt : 2947 rows, 561 columns`</br>
Contains recorded features test data</br>
`y_test <- test/y_test.txt : 2947 rows, 1 columns`</br>
Contains test data of activities’code labels</br>
`subject_train <- test/subject_train.txt : 7352 rows, 1 column`</br>
Contains train data of 21/30 volunteer subjects being observed</br>
`x_train <- test/X_train.txt : 7352 rows, 561 columns`</br>
Contains recorded features train data</br>
`y_train <- test/y_train.txt : 7352 rows, 1 columns`</br>
Contains train data of activities’code labels</br>

* Name the columns to easily interpret the data
```
colnames(activity_lables) <- c("activityId","activity")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
```


#### **TASK 1:** Merge the training sets and the test sets to create one data set
```
train <- cbind(y_train,subject_train,x_train)
test <- cbind(y_test,subject_test,x_test)
complete <- rbind(train,test)

```
`train` (7352 rows, 563 columns) is created by merging `y_train`,`subject_train` and `x_train` using `cbind()` function
`test` (2947 rows, 563 columns) is created by merging `y_test`,`subject_test` and `x_test` using `cbind()` function
`complete` (10299 rows, 563 column) is created by merging `train` and `test` using `rbind()` 

#### **TASK 2:** Extract only the measurements on the mean and standard deviation for each measurement

```
mean_sd <- (grepl("subjectId",colnames(complete))|
            grepl("activityId",colnames(complete))|
            grepl("mean*?",colnames(complete))|
            grepl("std*?",colnames(complete)))

complete_mean_sd <- complete[,mean_sd == T]
```
`grepl()` function takes a char string and serches for the string in a given vector, 
It returns `TRUE` for all the places string is present and `FALSE` for absent, i.e. a logical vector
Subset the `complete` dataframe only for the TRUE values from this logical vector

#### **TASK 3:** Use descriptive activity names to name the activities in the data set

```
activityLabel_mean_sd <- merge(complete_mean_sd,activity_lables,by = "activityId", all.x = T)
```
Entire numbers in code column of the `complete_mean_sd` replaced with corresponding activity taken from second column of the `activity_labels` variable

#### **TASK 4:** Appropriately label the data set with descriptive variable names
```
names(activityLabel_mean_sd) <- gsub("^t","time",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("^f","frequency",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Acc","Accelerometer",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Gyro","Gyroscope",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Mag","Magnitude",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Body Body","Body",names(activityLabel_mean_sd))
```

code column in `activityLabel_mean_sd` renamed into activities
All start with character t in column’s name replaced by Time
All start with character f in column’s name replaced by Frequency
All Acc in column’s name replaced by Accelerometer
All Gyro in column’s name replaced by Gyroscope
All Mag in column’s name replaced by Magnitude
All BodyBody in column’s name replaced by Body

#### **TASK 5:** From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
```
library(dplyr)
Tidydataset <- activityLabel_mean_sd %>%
                  group_by(subjectId,activityId) %>%
                    summarise_all(funs(mean))

write.table(Tidydataset,file = "Tidydataset.txt",row.name = F)
```
`Tidydataset` (180 rows, 82 columns) is created by summarizing `activityLabel_mean_sd` taking the means of each variable for each activity and each subject, after groupped by subject and activity.
Export `Tidydataset` into Tidydataset.txt file.
