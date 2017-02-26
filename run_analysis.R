#setwd("C:/Users/Ange/Desktop/study/coursera/data_clean/UCI HAR Dataset")

####
# require library
library(tidyr)
library(dplyr)

####
# process data
subject_train = read.table("train/subject_train.txt") %>% as.tbl()
X_train = read.table("train/X_train.txt") %>% as.tbl()
y_train = read.table("train/y_train.txt") %>% as.tbl()

subject_test = read.table("test/subject_test.txt") %>% as.tbl()
X_test = read.table("test/X_test.txt") %>% as.tbl()
y_test = read.table("test/y_test.txt") %>% as.tbl()

activity_labels = read.table("activity_labels.txt") %>% as.tbl()
features = read.table("features.txt") %>% as.tbl()

features_split = features %>% 
  mutate(new_names = gsub("-","_",gsub("\\(\\)|,","",V2))) %>% 
  separate("V2",into=c("feature","func","axis"),sep="-") %>% 
  as.tbl()
  

#####
#1. Combine train and test data
subject_all = bind_rows(subject_train, subject_test) %>% select(subject=V1)
X_all = bind_rows(X_train, X_test)
y_all = bind_rows(y_train, y_test)

####
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std_cols_data = features_split %>% 
  filter(func %in% c("mean()","std()")) %>% 
  mutate(colname=paste("V",V1,sep=""))
mean_std_cols = mean_std_cols_data %>% .[["colname"]]
new_names = mean_std_cols_data %>% .[["new_names"]]
X_all_ms = X_all %>% select_(.dots=mean_std_cols)
names(X_all_ms) = new_names

####
#3. Uses descriptive activity names to name the activities in the data set
y_all_label = y_all %>% inner_join(activity_labels) %>% select(activity=V2)

####
#4. Appropriately labels the data set with descriptive variable names.
data_all = bind_cols(subject_all, y_all_label, X_all_ms)

####
#5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
data_all_gather = data_all %>% gather(key=feature, value=value, -c(subject, activity))
data_all_avg = data_all_gather %>% 
  group_by(subject, activity, feature) %>% 
  summarise(value=mean(value)) %>% 
  ungroup()

####
# Finally output the data
write.table(data_all_avg, "final_output.txt", row.names = FALSE, quote=FALSE)







