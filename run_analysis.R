## Merges the training and the test sets to create one data set
tmpx1 <- read.table("UCI HAR Dataset/train/X_train.txt")
tmpx2 <- read.table("UCI HAR Dataset/test/X_test.txt")
# Merge  two temp x
X <- rbind(tmpx1, tmpx2)

# y data set 
tmpy1 <- read.table("UCI HAR Dataset/train/y_train.txt")
tmpy2<- read.table("UCI HAR Dataset/test/y_test.txt")
# Merge two temp y
y <- rbind(tmpy1,tmpy2)

# read Subject data

tmps1 <- read.table("UCI HAR Dataset/train/subject_train.txt")
tmps2 <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Merge Subject data
s <- rbind(tmps1,tmps2)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, indices_of_good_features]
names(X) <- features[indices_of_good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X)) 

# 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
y[,1] = activities[y[,1], 2]
names(y) <- "activity"


# 4. Appropriately labels the data set with descriptive activity names.

names(s) <- "subject"
cleandata <- cbind(s,y,X)
write.table(cleandata, "merged_clean_data.txt")

uniqueSubjects = unique(s)[,1]
numSubjects = length(unique(s)[,1])
numActivities = length(activities[,1])
numCols = dim(cleandata)[2]
result = cleandata[1:(numSubjects*numActivities), ]

row = 1
for (s1 in 1:numSubjects) {
  for (a in 1:numActivities) {
    result[row, 1] = uniqueSubjects[s1]
    result[row, 2] = activities[a, 2]
    tmp <- cleandata[cleandata$subject==s1 & cleandata$activity==activities[a, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}

write.table(result, "data_set_with_the_averages.txt")
