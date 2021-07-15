library(data.table)
library(expss)
library(stringr)

# Reading and formatting of Test dataset

x_test <- fread("./test/X_test.txt")
dim(x_test)

act_labels <- fread("./activity_labels.txt")
act_labels

feat <- fread("./features.txt")
dim(feat)

colnames(x_test) <- feat$V2  ##Add column names from features.txt

subject_test <- fread("./test/subject_test.txt")
dim(subject_test)

y_test <- fread("./test/y_test.txt")
dim(y_test)


act_labels_test <- vlookup(y_test$V1, act_labels, result_column = 2, lookup_column = 1) ##Matching activity labels
class(act_labels_test)
x_test_formatted <- cbind(subject_test, act_labels_test, x_test ) #Combining subjects, activity labels and collected data 
colnames(x_test_formatted)[1] <- "subject"     #Renaming a column
colnames(x_test_formatted)[2] <- "act_labels"   #Renaming a column

#Reading and formatting of Training dataset

x_train <- fread("./train/X_train.txt")
dim(x_train)


colnames(x_train) <- feat$V2

subject_train <- fread("./train/subject_train.txt")
dim(subject_train)

y_train <- fread("./train/y_train.txt")
dim(y_train)


act_labels_train <- vlookup(y_train$V1, act_labels, result_column = 2, lookup_column = 1)

x_train_formatted <- cbind(subject_train, act_labels_train, x_train )
colnames(x_train_formatted)[1] <- "subject"
colnames(x_train_formatted)[2] <- "act_labels"

# Combining of Test and Training datasets


combo <- rbind(x_test_formatted, x_train_formatted)
unique(combo$act_labels)

#write.csv(combo, file = "combo.csv", row.names = FALSE)

# Extracts only the measurements on the mean and standard deviation for each measurement
combo_names <- names(combo)

col <- grep("mean|std|subject|act_labels", combo_names)
class(col)

combo <- combo[, ..col]


#create a second, independent tidy data set with the average of each variable for each activity and each subject.

##Create a new column by concatenation of dubject ids and activities
new_col <- paste(combo$subject, combo$act_labels, sep = "-")
combo2 <- cbind(new_col, combo)  #insert the new column in the dataset

subj_activ <- unique(combo2$new_col)
mean_data2 <- t(sapply(unique(subj_activ),function(activ_sub){
        colMeans(combo2[combo2$new_col == activ_sub,-(1:3)])
}))
rownames(mean_data2) <- subj_activ
mean_data2

row_names <- row.names(mean_data2)

new_col2 <- str_split(row_names, pattern = "-")
new_col2_df <- as.data.frame(do.call(rbind, new_col2))
colnames(new_col2_df) <- c("subject", "activity")
mean_data2 <- as.data.frame(mean_data2)
mean_data2_final <- cbind(new_col2_df, mean_data2)

#write.csv(mean_data2_final, "mean_data2_final.csv", row.names = FALSE)

write.table(mean_data2_final, "mean_data2_final.txt", row.names = FALSE, sep = "\t")

