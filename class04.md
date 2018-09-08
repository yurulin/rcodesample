---
title       : Class04
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
* [Set up](#set-up)
* [Naive Bayesian](#nb)
* [Decision Trees](#tree)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- #nb .modal 
## Naive Bayesian

The examples are taken from [Data Mining and Business Analytics with R](http://www.wiley.com/WileyCDA/WileyTitle/productCd-111844714X.html) and [Machine Learning for Hackers](http://shop.oreilly.com/product/0636920018483.do).

Example: Delayed Flights
-----------------------------
   * response variable: whether or not a flight has been delayed by more than 15 min (coded as 0 for no delay, and 1 for delay)
   * explanatory variables: different arrival airports, different departure airports, eight carriers, different hours of departure (6am to 10 pm), weather conditions (0 = good/1 = bad), day of week (1 for Sunday and Monday; and 0 for all other days)
   * objective: to identify flights that are likely to be delayed (a binary classification problem)

--- .scode-nowrap .compact
## Naive Bayesian
```r
set.seed(1)
library(car)  #used to recode a variable

## reading the data
data.url = 'http://www.yurulin.com/class/spring2014_datamining/data/data_text'
delay = read.csv(sprintf("%s/FlightDelays.csv",data.url))
delay[1:3,]
```

--- .scode-nowrap .compact
## Naive Bayesian

```r
del=data.frame(delay)
```

```
## Error in data.frame(delay): object 'delay' not found
```

```r
del$schedf=factor(floor(del$schedtime/100))
```

```
## Error in `$<-.data.frame`(`*tmp*`, schedf, value = structure(integer(0), .Label = character(0), class = "factor")): replacement has 0 rows, data has 2201
```

```r
del$delay=recode(del$delay,"'delayed'=1;else=0")
response=as.numeric(levels(del$delay)[del$delay])
hist(response)
```

```
## Error in hist.default(response): invalid number of 'breaks'
```

--- .scode-nowrap .compact
## Naive Bayesian

```r
## determining test and evaluation data sets
n=length(del$dayweek)
n
```

```
## [1] 2201
```

```r
n1=floor(n*(0.6)) ## 60% for training
n1 # num of training cases
```

```
## [1] 1320
```

```r
n2=n-n1
n2 # num of testing cases
```

```
## [1] 881
```

```r
train=sample(1:n,n1)

## determining marginal probabilities
tttt=cbind(del$schedf[train],del$carrier[train],del$dest[train],del$origin[train],del$weather[train],del$dayweek[train],response[train])
tttrain0=tttt[tttt[,7]<0.5,]
```

```
## Error in tttt[, 7]: subscript out of bounds
```

```r
tttrain1=tttt[tttt[,7]>0.5,]
```

```
## Error in tttt[, 7]: subscript out of bounds
```

```r
## prior probabilities
tdel=table(response[train])
tdel=tdel/sum(tdel)
tdel
```

```
## numeric(0)
```

--- .scode-nowrap .compact
## Naive Bayesian

```r
## scheduled time
ts0=table(tttrain0[,1])
```

```
## Error in table(tttrain0[, 1]): object 'tttrain0' not found
```

```r
ts0=ts0/sum(ts0)
```

```
## Error in eval(expr, envir, enclos): object 'ts0' not found
```

```r
ts0
```

```
## Error in eval(expr, envir, enclos): object 'ts0' not found
```

```r
ts1=table(tttrain1[,1])
```

```
## Error in table(tttrain1[, 1]): object 'tttrain1' not found
```

```r
ts1=ts1/sum(ts1)
```

```
## Error in eval(expr, envir, enclos): object 'ts1' not found
```

```r
ts1
```

```
## Error in eval(expr, envir, enclos): object 'ts1' not found
```

```r
## scheduled carrier
tc0=table(tttrain0[,2])
```

```
## Error in table(tttrain0[, 2]): object 'tttrain0' not found
```

```r
tc0=tc0/sum(tc0)
```

```
## Error in eval(expr, envir, enclos): object 'tc0' not found
```

```r
tc0
```

```
## Error in eval(expr, envir, enclos): object 'tc0' not found
```

```r
tc1=table(tttrain1[,2])
```

```
## Error in table(tttrain1[, 2]): object 'tttrain1' not found
```

```r
tc1=tc1/sum(tc1)
```

```
## Error in eval(expr, envir, enclos): object 'tc1' not found
```

```r
tc1
```

```
## Error in eval(expr, envir, enclos): object 'tc1' not found
```

```r
## scheduled destination
td0=table(tttrain0[,3])
```

```
## Error in table(tttrain0[, 3]): object 'tttrain0' not found
```

```r
td0=td0/sum(td0)
```

```
## Error in eval(expr, envir, enclos): object 'td0' not found
```

```r
td0
```

```
## Error in eval(expr, envir, enclos): object 'td0' not found
```

```r
td1=table(tttrain1[,3])
```

```
## Error in table(tttrain1[, 3]): object 'tttrain1' not found
```

```r
td1=td1/sum(td1)
```

```
## Error in eval(expr, envir, enclos): object 'td1' not found
```

```r
td1
```

```
## Error in eval(expr, envir, enclos): object 'td1' not found
```

```r
## scheduled origin  
to0=table(tttrain0[,4])
```

```
## Error in table(tttrain0[, 4]): object 'tttrain0' not found
```

```r
to0=to0/sum(to0)
```

```
## Error in eval(expr, envir, enclos): object 'to0' not found
```

```r
to0
```

```
## Error in eval(expr, envir, enclos): object 'to0' not found
```

```r
to1=table(tttrain1[,4])
```

```
## Error in table(tttrain1[, 4]): object 'tttrain1' not found
```

```r
to1=to1/sum(to1)
```

```
## Error in eval(expr, envir, enclos): object 'to1' not found
```

```r
to1
```

```
## Error in eval(expr, envir, enclos): object 'to1' not found
```

```r
## weather
tw0=table(tttrain0[,5])
```

```
## Error in table(tttrain0[, 5]): object 'tttrain0' not found
```

```r
tw0=tw0/sum(tw0)
```

```
## Error in eval(expr, envir, enclos): object 'tw0' not found
```

```r
tw0
```

```
## Error in eval(expr, envir, enclos): object 'tw0' not found
```

```r
tw1=table(tttrain1[,5])
```

```
## Error in table(tttrain1[, 5]): object 'tttrain1' not found
```

```r
tw1=tw1/sum(tw1)
```

```
## Error in eval(expr, envir, enclos): object 'tw1' not found
```

```r
tw1
```

```
## Error in eval(expr, envir, enclos): object 'tw1' not found
```

```r
## bandaid as no observation in a cell
tw0=tw1
```

```
## Error in eval(expr, envir, enclos): object 'tw1' not found
```

```r
tw0[1]=1
```

```
## Error in tw0[1] = 1: object 'tw0' not found
```

```r
tw0[2]=0
```

```
## Error in tw0[2] = 0: object 'tw0' not found
```

```r
## scheduled day of week
tdw0=table(tttrain0[,6])
```

```
## Error in table(tttrain0[, 6]): object 'tttrain0' not found
```

```r
tdw0=tdw0/sum(tdw0)
```

```
## Error in eval(expr, envir, enclos): object 'tdw0' not found
```

```r
tdw0
```

```
## Error in eval(expr, envir, enclos): object 'tdw0' not found
```

```r
tdw1=table(tttrain1[,6])
```

```
## Error in table(tttrain1[, 6]): object 'tttrain1' not found
```

```r
tdw1=tdw1/sum(tdw1)
```

```
## Error in eval(expr, envir, enclos): object 'tdw1' not found
```

```r
tdw1
```

```
## Error in eval(expr, envir, enclos): object 'tdw1' not found
```

--- .scode-nowrap .compact
## Naive Bayesian

```r
## creating test data set
tt=cbind(del$schedf[-train],del$carrier[-train],del$dest[-train],del$origin[-train],del$weather[-train],del$dayweek[-train],response[-train])

## creating predictions, stored in gg
p0=ts0[tt[,1]]*tc0[tt[,2]]*td0[tt[,3]]*to0[tt[,4]]*tw0[tt[,5]+1]*tdw0[tt[,6]]
```

```
## Error in eval(expr, envir, enclos): object 'ts0' not found
```

```r
p1=ts1[tt[,1]]*tc1[tt[,2]]*td1[tt[,3]]*to1[tt[,4]]*tw1[tt[,5]+1]*tdw1[tt[,6]]
```

```
## Error in eval(expr, envir, enclos): object 'ts1' not found
```

```r
gg=(p1*tdel[2])/(p1*tdel[2]+p0*tdel[1])
```

```
## Error in eval(expr, envir, enclos): object 'p1' not found
```

```r
hist(gg)
```

```
## Error in hist(gg): object 'gg' not found
```

```r
## coding as 1 if probability 0.5 or larger
gg1=floor(gg+0.5)
```

```
## Error in eval(expr, envir, enclos): object 'gg' not found
```

```r
ttt=table(response[-train],gg1)
```

```
## Error in table(response[-train], gg1): all arguments must have the same length
```

```r
ttt
```

```
## Error in eval(expr, envir, enclos): object 'ttt' not found
```

```r
error=(ttt[1,2]+ttt[2,1])/n2
```

```
## Error in eval(expr, envir, enclos): object 'ttt' not found
```

```r
error
```

```
## [1] 0.1782066
```
