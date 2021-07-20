Getting and Cleaning Data Course Project

Human Activity Recognition Using Smartphones Dataset
README that explains the analysis files is clear and understandable
==================================================================
Files prepared for the Course Progect:
1. run_analysis.R - Contains R scripts for the dataset conversion
2. mean_data2_final.txt - Is the independent tidy data set with the average of each variable for each activity and each subject.
3. README.md - explains the analysis files
4. CodeBook.md  - Code book that describes the variables, the data, and any transformations or work that was performed to clean up the data

=================================================================
Analysis speps performed in R
1. Loading libraries

library(data.table)
library(expss)
library(stringr)

2. Setting working directory (setwd() function) and reading raw files in R for Test and Training datasets (fread() function)
3. Adding column names from "features.txt" file to "x_test.txt" and "x_train.txt"
4. Creating meanigful (human-readable) activity labels column by matching activity labels(activity_labels.txt) and "y_test.txt" and "y_train.txt" using lookup() function
5. Adding subject IDs from "y_test.txt" and "y_train.txt" to the Test and Training parts respectively
6. Remamung of two columns in the process - "subject" and "act_labels"
7. Combining of Test and Training datasets parts using rbind()
8. Extracting only the measurements on the mean and standard deviation for each measurement using grep() command, subsetting
9 Creation of the second, independent tidy data set with the average of each variable for each activity and each subject
-- Create a new (temporary) "new_col" column by concatenation of subject ids and activities
-- A custom function used along with sapply() to calculate a mean per subject per each activity
-- str_split() function used to split the temporary column back to subject and activity
-- finalising the variables in the tidy dataset (combining subject and activity colums with calculated means) 
-- order the final dataframe by subject id using order()
-- writing the final table - txt file, tab-delimited, "mean_data2_final.txt"

