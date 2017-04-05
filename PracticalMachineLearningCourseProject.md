# Practical Machine Learning Course Project
I. Martinez  
April 3, 2017  



## Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: <http://groupware.les.inf.puc-rio.br/har> (see the section on the Weight Lifting Exercise Dataset).

## Objective
The goal of your project is to predict the manner in which they did the exercise.

## Data

The training data for this project are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har. Thank you for your generousity in letting us use your data for our learning.

## Data Analysis and Preparation


```r
library(caret)
```

```
## Loading required package: lattice
```

```
## Loading required package: ggplot2
```

```r
library(ggplot2)
set.seed(88388)
setwd("C:/Other/Git/DataScienceTrack/PracticalMachineLearning")
```


```r
trainUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
training <- read.csv(url(trainUrl), na.strings=c("NA","#DIV/0!",""))

dim(training)
```

```
## [1] 19622   160
```

```r
#str(training)
```
The training data set contains 19622 observations and 160 variables. Many variables contain mostly NA's so our next step is to remove some of these variables that have no data or are not necessary. This will reduce the number of variables to 53.

```r
train=training[,colSums(is.na(training))<(nrow(training)*0.9)]
train=subset(train, select=-c(X,user_name,raw_timestamp_part_1,raw_timestamp_part_2,cvtd_timestamp,new_window,num_window ))
dim(train)
```

```
## [1] 19622    53
```

## Train Models and Evaluate on Held-out Set
We will now partition the data into parts, and for initial inspection train models only on a random sample of 1000 train and 1000 dev instances to select which method to take. We use Naive Bayes (NB) as baseline method. Assuming that the variables are not independent, we expect it to be a bad model. The random forests should work better. Finally we will compare them to support vector machines (SVM) with a linear and polynomial kernel

```r
inTrain <- createDataPartition(train$classe, p=0.7,list=FALSE) 
length(inTrain)
```

```
## [1] 13737
```

```r
inTrain=sample(inTrain,size=1000,replace=FALSE) #subset for testing
training <- train[inTrain,]
testing <- train[-inTrain,]
testing=testing[sample(nrow(testing), 1000),] #random rows
# we create the different models
model_rf=train(classe~.,data=training,method="rf")
#model_nb=train(classe~.,data=training,method="nb")
#model_svm=train(classe~.,data=training,method="svmLinear")
#model_pol=train(classe~.,data=training,method="svmPoly")
predictions_rf=predict(model_rf,newdata=testing)
accuracy=sum(predictions_rf == testing$classe)/length(testing$classe) #or
#predictions=predict(model_nb,newdata=testing)
#accuracy=sum(predictions == testing$classe)/length(testing$classe) #or
#predictions=predict(model_svm,newdata=testing)
#accuracy=sum(predictions == testing$classe)/length(testing$classe) #or
#predictions=predict(model_pol,newdata=testing)
#accuracy=sum(predictions == testing$classe)/length(testing$classe) #or
```
As expected, the worst model is naive Bayes (NB) and The best model is random forest. More specifically, on the 1000 data sample, the accuracies we get are:

- RF accuracy: 90%
- NB accuracy: 65%
- svmLinear: 72%
- svmPoly: 84%


```r
confusionMatrix(predictions_rf,testing$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction   A   B   C   D   E
##          A 253   8   0   3   0
##          B   8 170   6   0   5
##          C   6   8 176  12   7
##          D   5   3   5 139   2
##          E   3   1   1   2 177
## 
## Overall Statistics
##                                          
##                Accuracy : 0.915          
##                  95% CI : (0.896, 0.9315)
##     No Information Rate : 0.275          
##     P-Value [Acc > NIR] : < 2e-16        
##                                          
##                   Kappa : 0.8928         
##  Mcnemar's Test P-Value : 0.01137        
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9200   0.8947   0.9362   0.8910   0.9267
## Specificity            0.9848   0.9765   0.9594   0.9822   0.9913
## Pos Pred Value         0.9583   0.8995   0.8421   0.9026   0.9620
## Neg Pred Value         0.9701   0.9753   0.9848   0.9799   0.9828
## Prevalence             0.2750   0.1900   0.1880   0.1560   0.1910
## Detection Rate         0.2530   0.1700   0.1760   0.1390   0.1770
## Detection Prevalence   0.2640   0.1890   0.2090   0.1540   0.1840
## Balanced Accuracy      0.9524   0.9356   0.9478   0.9366   0.9590
```

## Feature selection
Now we will find the top-20 features of the RF model and train on the whole data set partition.

```r
varImp(model_rf)
```

```
## rf variable importance
## 
##   only 20 most important variables shown (out of 52)
## 
##                      Overall
## roll_belt            100.000
## pitch_forearm         73.574
## yaw_belt              48.585
## magnet_dumbbell_y     45.947
## magnet_dumbbell_z     38.689
## roll_forearm          33.465
## pitch_belt            24.176
## roll_dumbbell         20.526
## accel_forearm_x       18.375
## accel_dumbbell_y      17.673
## magnet_dumbbell_x     15.891
## magnet_belt_z         14.093
## total_accel_dumbbell  11.786
## magnet_forearm_z      11.753
## gyros_belt_z          11.599
## accel_belt_z          11.250
## magnet_belt_y         10.528
## magnet_arm_y           9.214
## gyros_dumbbell_y       9.053
## accel_dumbbell_z       9.037
```

```r
qplot(roll_belt,pitch_forearm,data=training,color=classe)
```

![](PracticalMachineLearningCourseProject_files/figure-html/Top20-1.png)<!-- -->

We now use only the top-20 features to train an RF model.

```r
inTrain <- createDataPartition(train$classe, p=0.7,list=FALSE) #same as [[1]] instead of list=FALSE
length(inTrain)
```

```
## [1] 13737
```

```r
training <- train[inTrain,]
testing <- train[-inTrain,]
training=subset(training,select=c(roll_belt,pitch_forearm,magnet_dumbbell_y,magnet_dumbbell_z,yaw_belt,roll_dumbbell,magnet_belt_y,accel_belt_z,magnet_belt_z ,magnet_arm_x,magnet_dumbbell_x,accel_dumbbell_y,pitch_belt,accel_forearm_x,roll_forearm,magnet_arm_y,accel_dumbbell_x,magnet_forearm_y,gyros_dumbbell_y,accel_arm_x,classe))
dim(training)
```

```
## [1] 13737    21
```

So far we have trained models on only a subset of the data. To get an estimate of the out-of-sample error we train a random forest model on the whole training data using cross-validation.

```r
fitControl <- trainControl(## 10-fold CV
                           method = "repeatedcv",
                           number = 10,
                           repeats = 10)
model=train(classe~.,data=training,method="rf",trControl=fitControl)
```
From the cross validation accuracy (98.9%) we can get an estimated of the out-of-sample performance.
## Final model

We train the final model using the seleted features on the entire training data set and evaluate it on the test set of 20 instances


```r
model=train(classe~.,data=training,method="rf")
predictions=predict(model,newdata=testing)
accuracy=sum(predictions == testing$classe)/length(testing$classe) #or:
accuracy
```

```
## [1] 0.993373
```

```r
confusionMatrix(predictions,testing$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1671    1    0    0    0
##          B    2 1133    4    0    1
##          C    0    4 1021   17    0
##          D    0    1    1  946    6
##          E    1    0    0    1 1075
## 
## Overall Statistics
##                                          
##                Accuracy : 0.9934         
##                  95% CI : (0.991, 0.9953)
##     No Information Rate : 0.2845         
##     P-Value [Acc > NIR] : < 2.2e-16      
##                                          
##                   Kappa : 0.9916         
##  Mcnemar's Test P-Value : NA             
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9982   0.9947   0.9951   0.9813   0.9935
## Specificity            0.9998   0.9985   0.9957   0.9984   0.9996
## Pos Pred Value         0.9994   0.9939   0.9798   0.9916   0.9981
## Neg Pred Value         0.9993   0.9987   0.9990   0.9963   0.9985
## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
## Detection Rate         0.2839   0.1925   0.1735   0.1607   0.1827
## Detection Prevalence   0.2841   0.1937   0.1771   0.1621   0.1830
## Balanced Accuracy      0.9990   0.9966   0.9954   0.9899   0.9966
```
We reach an accuracy of 99.81% on the held-out set. More specifically, the sensitivity and specificity per class is, respectively: A 0.9988/0.9993, B 0.9939/0.9992, C 0.9981/0.9992, D 1.0/1.0, E 1.0/1.0.

Now we run it on the real test data and write the predictions to the files. Submitting the test run on the website shows that we actually got an accuracy of 100% (with just 20 features). Thus, our estimate holds.


```r
testUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
testing <- read.csv(url(testUrl), na.strings=c("NA","#DIV/0!",""))
testing=subset(testing,select=c(roll_belt,pitch_forearm,magnet_dumbbell_y,magnet_dumbbell_z,yaw_belt,roll_dumbbell,magnet_belt_y,accel_belt_z,magnet_belt_z ,magnet_arm_x,magnet_dumbbell_x,accel_dumbbell_y,pitch_belt,accel_forearm_x,roll_forearm,magnet_arm_y,accel_dumbbell_x,magnet_forearm_y,gyros_dumbbell_y,accel_arm_x))
dim(testing)
```

```
## [1] 20 20
```

```r
predictionsTest=predict(model,newdata=testing)
length(predictionsTest)
```

```
## [1] 20
```

```r
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("predict_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(predictionsTest)
```
