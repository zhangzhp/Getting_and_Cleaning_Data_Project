X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
        
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# 1. Merges the training and the test sets to create one data set.
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
data_all <- cbind(y,subject,X)
colnames(data_all)[1:2]<- c("label","subject")

# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features <-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE,sep=" ")
#X1<-X[,c(grep(".*mean().*",features[,2]),grep(".*std().*",features[,2]))]
data_all<-data_all[,c(1,2,2+grep(".*mean().*",features[,2]),2+grep(".*std().*",features[,2]))]

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE,sep=" ")
colnames(activities)<-c("label","activity")
data_all <- merge(activities,data_all,by.x="label",by.y="label")

# 4. Appropriately labels the data set with descriptive variable names. 
n<-length(names(data_all))
colnames(data_all)[4:n]<-features[c(grep(".*mean().*",features[,2]),grep(".*std().*",features[,2])),2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
data_all$activity<-as.factor(data_all$activity)
data_all$subject<-as.factor(data_all$subject)
data_new<-ddply(data_all,.(activity, subject), function(x) colMeans(x[,4:n]))

write.table(data_new,file="./tidy_data_set.txt",row.name=FALSE)