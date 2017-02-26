# Codebook
This code book explains each step of the R script in the data cleaning assignment.

##Setup and Loading Data
First assume data are unzipped and placed in a folder called UCI HAR Dataset, under the root directory. Also assume R working directory has been set up to the root directory.

The first step is to load data. I simply use read.table() and turn it in to tbl objects. For example, to load train data I do:
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
So I split it to extract the feature, function and axis parts. I also transform the name so it can be used as a variable name in the future. 
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
