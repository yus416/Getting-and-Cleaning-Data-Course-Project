======================
CodeBook
======================
The resulting tidy dataset contains the average of each variable for each activity and each subject.
The first two columns are subject IDs and activity labels.

Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
Triaxial Angular velocity from the gyroscope. 
A 561-feature vector with time and frequency domain variables. 
Its activity label. 
An identifier of the subject who carried out the experiment.
1. "activity_labels.txt" were used to decode y_test.txt and y_train.txt
2. "features.txt" was used to create column names for X_test.txt and X_train.txt
3. "subject_test.txt" and "subject_train.txt" were used as columns containing subject IDs and were combined with X_test.txt and X_train.txt respectively
4. Then Test and Training datasets were merged  - see variable "combo" in thr R code provided.

5 For the second tidy dataset column means were calculated per subject and per activity simultaneously. This was implemented by creation of an intermediate variable 
"new_col", obtained by concatenation of subject ID and activity label, like this "10-WALKING"
6. The resulting dataset "mean_data2_final" contains "subject", "activity", and and 564 variables from features.txt (shown in the appendix below).


