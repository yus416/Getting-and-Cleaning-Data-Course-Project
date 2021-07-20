library(data.table)
library(expss)
library(stringr)

# Reading and formatting of Test dataset
setwd("../UCI HAR Dataset")  #Set working directory

# Read files of Test dataset
x_test <- fread("./test/X_test.txt")
act_labels <- fread("./activity_labels.txt")
feat <- fread("./features.txt")
subject_test <- fread("./test/subject_test.txt")
y_test <- fread("./test/y_test.txt")

colnames(x_test) <- feat$V2  ##Add column names from features.txt

act_labels_test <- vlookup(y_test$V1, act_labels, result_column = 2, lookup_column = 1) ##Matching activity labels
x_test_formatted <- cbind(subject_test, act_labels_test, x_test ) #Combining subjects, activity labels and collected data 
colnames(x_test_formatted)[1] <- "subject"     #Renaming the column
colnames(x_test_formatted)[2] <- "act_labels"   #Renaming the column

# Reading and formatting of Training dataset

# Read files of Training dataset
x_train <- fread("./train/X_train.txt")
subject_train <- fread("./train/subject_train.txt")
y_train <- fread("./train/y_train.txt")

colnames(x_train) <- feat$V2

act_labels_train <- vlookup(y_train$V1, act_labels, result_column = 2, lookup_column = 1) #Matching activity labels

x_train_formatted <- cbind(subject_train, act_labels_train, x_train )
colnames(x_train_formatted)[1] <- "subject"  #Renaming the column
colnames(x_train_formatted)[2] <- "act_labels" #Renaming the column

# Combining of Test and Training datasets

combo <- rbind(x_test_formatted, x_train_formatted)
unique(combo$act_labels)

# Extracts only the measurements on the mean and standard deviation for each measurement

combo_names <- names(combo)
col <- grep("mean|std|subject|act_labels", combo_names) #selection of columns only containing mean and std dev info
combo <- combo[, ..col] #keep only mean and std dev in the object "combo", subsetting by "col" object


# Create a second, independent tidy data set with the average of each variable for each activity and each subject.

new_col <- paste(combo$subject, combo$act_labels, sep = "-")  #Create a new column by concatenation of subject ids and activities
combo2 <- cbind(new_col, combo)  #insert the new column in the dataset

subj_activ <- unique(combo2$new_col)
mean_data2 <- t(sapply(unique(subj_activ),function(activ_sub){  #this function calculates a mean per subject per each activity
        colMeans(combo2[combo2$new_col == activ_sub,-(1:3)])
}))
rownames(mean_data2) <- subj_activ
row_names <- row.names(mean_data2)

new_col2 <- str_split(row_names, pattern = "-")  #splitting the temporary "row_names" column back to subject and activity
new_col2_df <- as.data.frame(do.call(rbind, new_col2)) #converting  new_col2 object into dataframe
colnames(new_col2_df) <- c("subject", "activity") #naming two columns of object new_col2_df
mean_data2 <- as.data.frame(mean_data2)
mean_data2_final <- cbind(new_col2_df, mean_data2) #combining mean_data2 with new_col2_df

# order the final dataframe by subject id
mean_data2_final <- mean_data2_final[order(as.numeric(mean_data2_final$subject), decreasing = FALSE), ]

# writing the final table - txt file, tab-delimited
write.table(mean_data2_final, "mean_data2_final.txt", row.names = FALSE, sep = "\t")

