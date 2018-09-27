---
title       : Class05
subtitle    : classification
author      : Yu-Ru Lin
job         : 
framework   : shower        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
toc         : true
toc_depth   : 2

--- #toc
## Class05

* [Set up](#set-up)
* [SVM](#svm)
* [AdaBoost](#ada)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- .scode-nowrap .compact #svm
## SVM
The examples are taken from [Data Mining Algorithms In R](http://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R)



```r
library(e1071)
library(MASS)
data(cats)
model <- svm(Sex~., data = cats)

print(model)
```

```
## 
## Call:
## svm(formula = Sex ~ ., data = cats)
## 
## 
## Parameters:
##    SVM-Type:  C-classification 
##  SVM-Kernel:  radial 
##        cost:  1 
##       gamma:  0.5 
## 
## Number of Support Vectors:  84
```

--- .scode-nowrap .compact
## SVM

```r
summary(model)
```

```
## 
## Call:
## svm(formula = Sex ~ ., data = cats)
## 
## 
## Parameters:
##    SVM-Type:  C-classification 
##  SVM-Kernel:  radial 
##        cost:  1 
##       gamma:  0.5 
## 
## Number of Support Vectors:  84
## 
##  ( 39 45 )
## 
## 
## Number of Classes:  2 
## 
## Levels: 
##  F M
```

--- .modal
## SVM

```r
plot(model,cats)
```

![plot of chunk class05-chunk-4](assets/fig/class05-chunk-4-1.png)

--- .sscode-nowrap .compact
## SVM

```r
## run svm with training / testing sets
index <- 1:nrow(cats)
testindex <- sample(index, trunc(length(index)/3))
testset <- cats[testindex,]
trainset <- cats[-testindex,]
model <- svm(Sex~., data = trainset)
prediction <- predict(model, testset[,-1])
tab <- table(pred = prediction, true = testset[,1])

## tune hyperparameters using a grid search over the supplied parameter ranges
tuned <- tune.svm(Sex~., data = trainset, gamma = 10^(-6:-1), cost = 10^(1:2))
summary(tuned)
```

```
## 
## Parameter tuning of 'svm':
## 
## - sampling method: 10-fold cross validation 
## 
## - best parameters:
##  gamma cost
##    0.1   10
## 
## - best performance: 0.1955556 
## 
## - Detailed performance results:
##    gamma cost     error dispersion
## 1  1e-06   10 0.3211111 0.15030376
## 2  1e-05   10 0.3211111 0.15030376
## 3  1e-04   10 0.3211111 0.15030376
## 4  1e-03   10 0.3211111 0.15030376
## 5  1e-02   10 0.2277778 0.13761141
## 6  1e-01   10 0.1955556 0.09927031
## 7  1e-06  100 0.3211111 0.15030376
## 8  1e-05  100 0.3211111 0.15030376
## 9  1e-04  100 0.3211111 0.15030376
## 10 1e-03  100 0.2277778 0.13761141
## 11 1e-02  100 0.2266667 0.12430327
## 12 1e-01  100 0.1955556 0.09927031
```

--- .scode-nowrap .compact #ada
## AdaBoost

```r
library(ada)
library(MASS)
data(cats)

index <- 1:nrow(cats)
testindex <- sample(index, trunc(length(index)/3))
testset <- cats[testindex,]
trainset <- cats[-testindex,]
model <- ada(Sex~., data = trainset)
pred <- addtest(model, testset[,-1], testset[,1])
summary(pred)
```

```
## Call:
## ada(Sex ~ ., data = trainset)
## 
## Loss: exponential Method: discrete   Iteration: 50 
## 
## Training Results
## 
## Accuracy: 0.812 Kappa: 0.578 
## 
## Testing Results
## 
## Accuracy: 0.729 Kappa: 0.402
```

--- .modal
## AdaBoost

```r
## plot of variables ordered by the variable importance measure (based on improvement)
varplot(pred)
```

![plot of chunk class05-chunk-7](assets/fig/class05-chunk-7-1.png)
