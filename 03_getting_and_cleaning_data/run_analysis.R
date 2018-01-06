require("data.table") || install.packages("data.table")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

        data.folder <- "UCI HAR Dataset"

 ## dowloading file using curl (required for Mac users) method
        zip.name <- "dataset.zip"
        download.file(url, zip.name, method = "curl")
        
 ## unzip file and delete archive.
        unzip(zip.name)
        unlink(zip.name)

 ## read labels and features data using data.table package.
        actv.lbls <- fread(paste0(data.folder, "/", "activity_labels.txt"))
        ftrs <- fread(paste0(data.folder, "/", "features.txt"))
        
 ## 1. Merges the training and the test sets to create one data set.
        train <- fread(paste0(data.folder, "/", "train/X_train.txt"))
        test <- fread(paste0(data.folder, "/", "test/X_test.txt"))
        untd <- rbind(train, test)
        
 ## 2. Extracts measurements on the mean and standard deviation.
        mes.cols <- grep("mean\\(\\)|std\\(\\)", ftrs$V2, ignore.case = TRUE)
        col.names <- ftrs$V2[mes.cols]
        untd <- untd[, (mes.cols), with = FALSE]
        names(untd) <- col.names
        
 ## 3. Uses descriptive activity names to name the activities in the data set
        actv.train  <- fread(paste0(data.folder, "/", "train/y_train.txt"))
        actv.test  <- fread(paste0(data.folder, "/", "test/y_test.txt"))
        actv.untd <- c(actv.train$V1, actv.test$V1)
        actv.fctr <- factor(actv.untd, labels = actv.lbls$V2)
        untd$activity <- actv.fctr
        
 ## 4. Appropriately labels the data set with descriptive variable names.
        subj.train <- fread(paste0(data.folder, "/", "train/subject_train.txt"))
        subj.test <- fread(paste0(data.folder, "/", "test/subject_test.txt"))
        subj.fctr <- as.factor(c(subj.train$V1, subj.test$V1))
        untd$subject <- subj.fctr
        
 ## 5. From the data set in step 4, creates a second, independent tidy data set
 ## with the average of each variable for each activity and each subject.
        untd.melt <- melt(untd, id = c("subject", "activity"))
        untd.tidy <- dcast(untd.melt, subject + activity ~ variable, mean)
