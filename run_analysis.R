run_analysis <- function() {
        library(dplyr)
        #Step 1: Merges the training and the test sets to create one data set.
        
        #Read in the test datasets
        subtest_table <- read.table("./test/subject_test.txt", 
                        header=FALSE)
        Xtest_table <- read.table("./test/X_test.txt", 
                        header=FALSE)
        Ytest_table <- read.table("./test/Y_test.txt", 
                        header=FALSE)
        
        #Read in the train datasets
        subtrain_table <- read.table("./train/subject_train.txt", 
                        header=FALSE)
        Xtrain_table <- read.table("./train/X_train.txt", 
                        header=FALSE)
        Ytrain_table <- read.table("./train/Y_train.txt", 
                        header=FALSE)
        
        #Combine the test datasets
        test_bind <- cbind(Xtest_table, Ytest_table, subtest_table)
        
        #Combine the train datasets
        train_bind <- cbind(Xtrain_table, Ytrain_table, subtrain_table)
        
        #Combine the test and train combined data into one dataset
        total_bind <- rbind(test_bind, train_bind)
        
        #Step 2: Extracts only the measurements on the mean and standard 
        #deviation for each measurement. 
        
        #Read in the features table to figure out the column indexes of the mean
        #and std
        features_table <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", 
                        header=FALSE)
        
        #Find the indexes and labels for the mean column labels
        mean_idx_labels <- features_table[grep("mean", tolower(features_table$V2)), ]
        
        #Convert labels from factor to character vector and apply new naming
        #convention
        mean_labs <- as.character(mean_idx_labels[ ,2])
        
        # Step 4: Appropriately labels the data set with descriptive variable names. 
        
        #Remove duplicate Body in names
        mean_labs[grep("BodyBody", mean_labs)] <- sub("BodyBody","Body",
                mean_labs[grep("BodyBody", mean_labs)])

        mean_labs[grep("-", mean_labs)] <- sub("-","",mean_labs[grep("-", mean_labs)])
        mean_labs[grep("meanFreq()", mean_labs)] <- sub("meanFreq()","MeanFreq",
                mean_labs[grep("meanFreq()", mean_labs)], fixed=TRUE)
        
        mean_labs[grep("mean()", mean_labs)] <- sub("mean()","Mean",
                mean_labs[grep("mean()", mean_labs)], fixed=TRUE)
        
        mean_labs[grep("-", mean_labs)] <- sub("-", "In", mean_labs[grep("-", 
                mean_labs)])
        
        #Find the indexes and labels for the mean column labels
        std_idx_labels <- features_table[grep("std", tolower(features_table$V2)), ]        
        
        # Step 4: Appropriately labels the data set with descriptive variable names. 
        
        #Convert labels from factor to character vector and apply new naming
        #convention
        std_labs <- as.character(std_idx_labels[ ,2])
        
        #Remove duplicate Body in names
        std_labs[grep("BodyBody", std_labs)] <- sub("BodyBody","Body",
                std_labs[grep("BodyBody", std_labs)])
        
        std_labs[grep("-", std_labs)] <- sub("-","",std_labs[grep("-", std_labs)])
        
        std_labs[grep("-", std_labs)] <- sub("-", "In", std_labs[grep("-", 
                std_labs)])
        std_labs[grep("std()", std_labs)] <- sub("std()","Std",
                std_labs[grep("std()", std_labs)], fixed=TRUE)
        
        #Label the columns for mean, std, y, and subject data
        mean_df <- total_bind[mean_idx_labels[ ,1]]
        colnames(mean_df) <- mean_labs
        
        std_df <- total_bind[std_idx_labels[ ,1]]
        colnames(std_df) <- std_labs
        
        y_data <- total_bind[ncol(total_bind)-1]
        colnames(y_data) <- "Act_id"
        
        sub_data <- total_bind[ncol(total_bind)]
        colnames(sub_data) <- "Subject"
        
        #Combine mean, std, y, and subject data into one dataframe
        mean_std_df <- cbind(mean_df, std_df, y_data, sub_data)
        
        #Step 3: Uses descriptive activity names to name the activities in the data set
        
        #Read the activities label file
        acts_table <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",
                header=FALSE)
        
        #Merge the combined dataframe (mean_std_df) with the activities labels
        #table
        mergeacts = merge(mean_std_df, acts_table, by.x = "Act_id", 
                by.y = "V1", all=TRUE)
        
        #Simplify the columns by removing the activities id column
        mergeacts$Act_id <- NULL
        
        #Label the column with the activity labels as "Activity"
        names(mergeacts)[ncol(mergeacts)] <- "Activity"
        
        #Step 5: From the data set in step 4, creates a second, independent tidy
        #data set with the average of each variable for each activity and each 
        #subject.
        by_sub_act <- group_by(mergeacts, Subject, Activity)
        mean_group <- summarize_each(by_sub_act, funs(mean))
        
        write.table(mean_group, file="./tidy_wide_data.txt", row.names=FALSE, 
                col.names=TRUE)
        
}
        