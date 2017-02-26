# What this code does:
The _run_analysis.R_ processes the [Sumsung activity tracking data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), and a description of the data can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The original data are:
  - _subject_train_, _subject_test_: each row is a subject number.
  - _X_train_, _X_test_: each row is a collection of features generated from the activity tracker. The feature names are in _feature.txt_.
  - _y_train_, _y_test_: each row is an activity number. The correspondence between activity number and description is in _activity.txt_.

This code only works on the main data, i.e. _subject_, _X_ and _y_ for both train and test. It does the following:
  - Combine train and test.
  - Combine _X_, _y_ and _subject_ to the same data.
  - Properly label the data so _y_ is more readable with labels of activities.
  - Extract only those features with mean() and std() summary.
  - Collapse the data so each subject and each activity has a single row, with the collapsed value to be the mean of each feature. The final output is a tidy data with each row to be a subject/activity/feature combination.

# How to run the code
Take the following steps to run the run_analysis.R:
  - Unzip data files.
  - Set up R working directory to the root folder of the data (where README.txt file is located).
  - Run the R code and an output data called _final_output.txt_ will be generated in the working folder.
