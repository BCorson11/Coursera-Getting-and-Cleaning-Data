##Set the Working Directory to a folder that includes
## the X_train, y_train, X_test, y_test, subject_train,
##subject_test, and feature files in it.

setwd("C:/Users/Corson/Desktop/Coursera")
getwd()

install.packages('data.table')
install.packages('dplyr')
install.packages('matrixStats')
install.packages('plyr')

library(data.table)
library(dplyr)
library(matrixStats)
library(plyr)

X_train <- fread("./X_train.txt")
y_train <- fread("./y_train.txt")

X_test <- fread("./X_test.txt")
y_test <- fread("./y_test.txt")

subject_train <- fread("./subject_train.txt")
subject_test <- fread("./subject_test.txt")

features <- fread("./features.txt")

features <- features %>% select("V2")
features <- unlist(features)

colnames(X_train) <- features
colnames(X_test) <- features

colnames(y_train) <- "Activity"
colnames(y_test) <- "Activity"

colnames(subject_test) <- "SubjectID"
colnames(subject_train) <- "SubjectID"

Test <- cbind(subject_test, y_test, X_test)
Train <- cbind(subject_train, y_train, X_train)

Total <- rbind(Train, Test)

Total$Activity[Total$Activity == "1"] <- "WALKING"
Total$Activity[Total$Activity == "2"] <- "WALKING_UPSTAIRS"
Total$Activity[Total$Activity == "3"] <- "WALKING_DOWNSTAIRS"
Total$Activity[Total$Activity == "4"] <- "SITTING"
Total$Activity[Total$Activity == "5"] <- "STANDING"
Total$Activity[Total$Activity == "6"] <- "LAYING"

colnames(Total) <- make.unique(names(Total))

Mean <- colMeans(subset(Total, select = -c(SubjectID, Activity)))
StDev <- Total %>% select(-c(SubjectID, Activity)) %>%
        as.matrix() %>%
        colSds

Variable <- Total %>% select(-c(SubjectID, Activity)) %>%
        colnames

summarystats <- cbind(Variable, Mean, StDev)
rownames(summarystats) <- c(1:561)

subjectmeans <- Total %>%
        group_by(SubjectID, Activity) %>%
        summarise_all(mean)

write.table(subjectmeans, file = "ProjectStep5Output.txt", row.names = FALSE)

View(Total)
View(summarystats)
View(subjectmeans)


