Tasks performed in the script include:

Step 1: Merges the training and the test sets to create one data set.
        #Read in the test datasets
        #Read in the train datasets
        #Combine the test datasets
        #Combine the train datasets
        #Combine the test and train combined data into one dataset
        
Step 2: Extracts only the measurements on the mean and standard 
deviation for each measurement. 
        #Read in the features table to figure out the column indexes of the mean
        #and std
        #Find the indexes and labels for the mean and std column labels
        #Convert labels from factor to character vector and apply new naming
        #convention
        
Step 4: Appropriately labels the data set with descriptive variable names. 
        #Removes duplicate "Body" in names and special characters
        #Applies CamelCase to names
        #Label the columns for mean, std, y, and subject data
        #Combine mean, std, y, and subject data into one dataframe
        mean_std_df <- cbind(mean_df, std_df, y_data, sub_data)
        
Step 3: Uses descriptive activity names to name the activities in the data set
        #Read the activities label file
        #Merge the combined dataframe (mean_std_df) with the activities labels
        #table
        #Simplify the columns by removing the activities id column
        #Label the column with the activity labels as "Activity"
   
Step 5: From the data set in step 4, creates a second, independent tidy
data set with the average of each variable for each activity and each 
subject.

Note: The workspace must be set within the "UCI HAR Dataset" folder (Ex:
setwd(.../getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset). The output
"tidy_wide_data.txt" will be sent to the workspace.