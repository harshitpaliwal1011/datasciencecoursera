# We have to run this code several times, 
# so to make sure that the file does not get downloaded
# every time, I'll include an if-else condition which only 
# downloads the file if its not present already.

if(!file.exists("./dataset.zip")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileurl,destfile = "./dataset.zip")
  unzip("./dataset.zip")                 #unzip the file and look for the name of folder where it unzipped 
                                         #(UCI HAR Dataset in this case)
  print("File downloaded and unzipped")
} else {
  print("File already present")
}

pathfile <- file.path("UCI HAR Dataset")    # Create path so that we don't have to type it again and again
files = list.files(pathfile,recursive = T)  #just to print all the file names to the console

# Now we begin to read train data and test deta in separate variables

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

# Now we need to name all the columns in the data frames to make them easily understandable

colnames(activity_lables) <- c("activityId","activity")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"


### TASK 1 : Now we will merge the dataframes


train <- cbind(y_train,subject_train,x_train)
test <- cbind(y_test,subject_test,x_test)

# Now let's merge the test and train dataframes in one for easier access

complete <- rbind(train,test)


# TASK 2 : Now we need to extract the collumns with mean and sd data only

# We will first make a logical vector that checks the column names of
# complete data set and select values corresponding to specific name

# We will match text with the help of grepl function

mean_sd <- (grepl("subjectId",colnames(complete))|
            grepl("activityId",colnames(complete))|
            grepl("mean*?",colnames(complete))|
            grepl("std*?",colnames(complete)))

# Now we subset the complete dataframe only for the TRUE values 
# from this logical vector

complete_mean_sd <- complete[,mean_sd == T]


# TASK 3 : Now we can set descriptive names for activities just by merging the 
# activity label dataframe with the complete_mean_sd dataframe

activityLabel_mean_sd <- merge(complete_mean_sd,activity_lables,by = "activityId", all.x = T)


# TASK 4 : Set descriptive names for variables

names(activityLabel_mean_sd) <- gsub("^t","time",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("^f","frequency",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Acc","Accelerometer",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Gyro","Gyroscope",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Mag","Magnitude",names(activityLabel_mean_sd))
names(activityLabel_mean_sd) <- gsub("Body Body","Body",names(activityLabel_mean_sd))


# TASK 5 : Now make a new tidy dataset 

library(dplyr)
Tidydataset <- activityLabel_mean_sd %>%
                  group_by(subjectId,activityId) %>%
                    summarise_all(funs(mean))

write.table(Tidydataset,file = "Tidydataset.txt",row.name = F)


