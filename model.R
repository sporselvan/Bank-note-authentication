#bank_note_authentication

##importing libraries
library(readr)
library(randomForest)


##importing the dataset from github

bank<-read.csv("https://raw.githubusercontent.com/sporselvan/DATA/main/BankNote_Authentication.csv")

bank$class <- factor(bank$class,levels = c(0,1), labels = c("authentic","duplicate"))


#data split train & test

set.seed(123)

ind<-sample(2,nrow(bank),replace=TRUE,prob = c(0.8,0.2))
train<-bank[ind==1,]
test<-bank[ind==2,]

write.csv(train,"training.csv")
write.csv(test,"testing.csv")

#reading train file
TrainSet<-read.csv("training.csv")

#final random forest model after parameter tuning

rf_model<-randomForest(class~.,data=TrainSet,
                       mtry=2,
                       ntree=250,
                       importance=TRUE,
                       proximity=TRUE)


#save model as RDs files

saveRDS(rf_model,"model.rds")


