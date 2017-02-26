# Codebook
This code book explains each step of the R script in the data cleaning assignment.

##0. Setup and Loading Data
First assume data are unzipped and placed in a folder called UCI HAR Dataset, under the root directory. Also assume R working directory has been set up to the root directory.

The first step is to load data. I simply use read.table() and turn it in to _tbl_ objects. For example, to load train data I do:
```R
X_train = read.table("train/X_train.txt") %>% as.tbl()
y_train = read.table("train/y_train.txt") %>% as.tbl()
```
One data transformation carried out in this stage is the feature data. Features look like
```R
> features
# A tibble: 561 × 2
#     V1                V2
#  <int>            <fctr>
#      1 tBodyAcc-mean()-X
#      2 tBodyAcc-mean()-Y
#      3 tBodyAcc-mean()-Z
#      4 tBodyAcc-std()-X
#      ...
```
So I split it to extract the feature, function and axis parts. I also transform the name so it can be used as a variable name in the future. This transformation is rough: I simply remove or replace the characters like "()" and "," into underscores.
```R
> features_split
# A tibble: 561 × 5
#     V1  feature   func  axis       new_names
#*  <int>    <chr>  <chr> <chr>           <chr>
#1      1 tBodyAcc mean()     X tBodyAcc_mean_X
#2      2 tBodyAcc mean()     Y tBodyAcc_mean_Y
#3      3 tBodyAcc mean()     Z tBodyAcc_mean_Z
#...
```

##1. Combine Train and Test Data
Two things I did here:
  - Combine subject, X and y
  - Rename subject varname from V1 to subject. For X and y I will do renaming work later.
  
##2. Extract mean and std measures.
First I found the features with _mean()_ and _std()_ in them:
```R
mean_std_cols_data = features_split %>% 
  filter(func %in% c("mean()","std()")) %>% 
  mutate(colname=paste("V",V1,sep=""))
mean_std_cols_data
## A tibble: 66 × 6
#      V1     feature   func  axis          new_names colname
#   <int>       <chr>  <chr> <chr>              <chr>   <chr>
#1      1    tBodyAcc mean()     X    tBodyAcc_mean_X      V1
#2      2    tBodyAcc mean()     Y    tBodyAcc_mean_Y      V2
#3      3    tBodyAcc mean()     Z    tBodyAcc_mean_Z      V3
```
Then _mean_std_cols_ are the old names (V1, V2, etc) and _new_names_ are the new names (tBodyAcc_mean_X, tBodyAcc_mean_X, etc). Finally I create a data called _X_all_ms_, which is the _X_all_ with new names.

##3. Rename activity to meaningful names.
_y_all_label_ is the _y_all_ with levels more readable than an encoded integer. Also I renamed the labels to _activity_.

##4. Label data with descriptive varnames.
Now I combine the subject, activity as well as the feature data into one data:
```R
data_all = bind_cols(subject_all, y_all_label, X_all_ms)
```
and _data_all_ looks like
```R
> data_all
## A tibble: 10,299 × 68
#   subject activity tBodyAcc_mean_X tBodyAcc_mean_Y tBodyAcc_mean_Z tBodyAcc_std_X tBodyAcc_std_Y tBodyAcc_std_Z
#     <int>   <fctr>           <dbl>           <dbl>           <dbl>          <dbl>          <dbl>          <dbl>
#1        1 STANDING       0.2885845    -0.020294171      -0.1329051     -0.9952786     -0.9831106     -0.9135264
#2        1 STANDING       0.2784188    -0.016410568      -0.1235202     -0.9982453     -0.9753002     -0.9603220
#3        1 STANDING       0.2796531    -0.019467156      -0.1134617     -0.9953796     -0.9671870     -0.9789440
#4        1 STANDING       0.2791739    -0.026200646      -0.1232826     -0.9960915     -0.9834027     -0.9906751
#5        1 STANDING       0.2766288    -0.016569655      -0.1153619     -0.9981386     -0.9808173     -0.9904816
```

##5. Compute average value of features for each subject and each activity
To avoid massive coding, I use the following code:
```R
data_all_gather = data_all %>% gather(key=feature, value=value, -c(subject, activity))
data_all_avg = data_all_gather %>% 
  group_by(subject, activity, feature) %>% 
  summarise(value=mean(value)) %>% 
  ungroup() 
```
I first gather the data so each row is a subject, activity and feature combination. Then I can easily summarize the data by mean and come up with the tidy data that looks like:
```R
> data_all_avg
## A tibble: 11,880 × 4
#   subject activity             feature      value
#     <int>   <fctr>               <chr>      <dbl>
#1        1   LAYING     fBodyAcc_mean_X -0.9390991
#2        1   LAYING     fBodyAcc_mean_Y -0.8670652
#3        1   LAYING     fBodyAcc_mean_Z -0.8826669
#4        1   LAYING      fBodyAcc_std_X -0.9244374
#5        1   LAYING      fBodyAcc_std_Y -0.8336256
```
