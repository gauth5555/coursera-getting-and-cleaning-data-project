library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
label1 <- read.table("UCI HAR Dataset/activity_labels.txt")
label1[,2] <- as.character(label1[,2])
featres <- read.table("UCI HAR Dataset/features.txt")
featres[,2] <- as.character(featres[,2])

# Extract only the data on mean and standard deviation
ftrWantd <- grep(".*mean.*|.*std.*", featres[,2])
ftrWantd.names <- featres[ftrWantd,2]
ftrWantd.names = gsub('-mean', 'Mean', ftrWantd.names)
ftrWantd.names = gsub('-std', 'Std', ftrWantd.names)
ftrWantd.names <- gsub('[-()]', '', ftrWantd.names)


# Load the datasets
trn <- read.table("UCI HAR Dataset/train/X_train.txt")[ftrWantd]
trnAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trnSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trn <- cbind(trnSubjects, trnAct, trn)

tst <- read.table("UCI HAR Dataset/test/X_test.txt")[ftrWantd]
tstAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
tstSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
tst <- cbind(tstSubjects, tstAct, tst)

# merge datasets and add labels
allDta <- rbind(trn, tst)
colnames(allDta) <- c("subject", "activity", ftrWantd.names)

# turn activities & subjects into factors
allDta$activity <- factor(allDta$activity, levels = label1[,1], labels = label1[,2])
allDta$subject <- as.factor(allDta$subject)

allDta.
<- melt(allDta, id = c("subject", "activity"))
allDta.mean <- dcast(allDta, subject + activity ~ variable, mean)

write.table(allDta.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
