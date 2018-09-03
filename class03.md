---
title       : Class03
subtitle    : binary classification
author      : 
job         : 
framework   : shower        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
--- #toc

## Class03
* [Set up](#set-up)
* [Split data into two classes](#two-class)
* [Logistic Regression](#logistic-regression)
* [kNN](#knn)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- #two-class .scode-nowrap .compact 

## Split data into two classes

```r
library(ggplot2) ## use ggplot for plotting
data.url = 'http://www.yurulin.com/class/spring2014_datamining/data/ml_hackers/'
data.file = file.path(data.url , '01_heights_weights_genders.csv')
heights.weights <- read.csv(data.file , header = TRUE , sep = ',')
# visualized their gender as the color of each point
ggplot(heights.weights, aes(x = Weight , y = Height , color = Gender)) +
  geom_point()
```

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2-1.png)

--- .scode-nowrap .compact 
## Split data into two classes


```r
heights.weights = transform(heights.weights , Male = ifelse(Gender == 'Male', 1, 0))
heights.weights [1:3,]
```

```
##   Gender   Height   Weight Male
## 1   Male 73.84702 241.8936    1
## 2   Male 68.78190 162.3105    1
## 3   Male 74.11011 212.7409    1
```

--- #logistic-regression .model
## Logistic Regression

Example 1: Death penelty data
-----------------------------

   * objective: to identify whether the death penalty more likely if the victim is white, or the crime is more aggravating
   * response variable: getting death panelty or not
   * explanatory variables: severity of the crime, race of victim (black: 0; white: 1), etc

--- .scode-nowrap .compact 
## Logistic Regression

```r
## analyzing individual observations
data.url = 'http://www.yurulin.com/class/spring2014_datamining/data/data_text'
dpen = read.csv(sprintf("%s/DeathPenalty.csv",data.url))
dpen[1:4,]
```

```
##   Agg VRace Death
## 1   1     1     1
## 2   1     1     1
## 3   1     1     0
## 4   1     1     0
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
m1=glm(Death~VRace+Agg,family=binomial(link='logit'),data=dpen)
m1
```

```
## 
## Call:  glm(formula = Death ~ VRace + Agg, family = binomial(link = "logit"), 
##     data = dpen)
## 
## Coefficients:
## (Intercept)        VRace          Agg  
##      -6.676        1.811        1.540  
## 
## Degrees of Freedom: 361 Total (i.e. Null);  359 Residual
## Null Deviance:	    321.9 
## Residual Deviance: 113.5 	AIC: 119.5
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
summary(m1)
```

```
## 
## Call:
## glm(formula = Death ~ VRace + Agg, family = binomial(link = "logit"), 
##     data = dpen)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.7526  -0.2658  -0.1083  -0.1083   3.2069  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -6.6760     0.7574  -8.814  < 2e-16 ***
## VRace         1.8106     0.5361   3.377 0.000732 ***
## Agg           1.5397     0.1867   8.246  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 321.88  on 361  degrees of freedom
## Residual deviance: 113.48  on 359  degrees of freedom
## AIC: 119.48
## 
## Number of Fisher Scoring iterations: 7
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
## calculating logits
exp(m1$coef[2])
```

```
##  VRace 
## 6.1144
```

```r
exp(m1$coef[3])
```

```
##      Agg 
## 4.663011
```

--- .ssscode-nowrap .compact
## Logistic Regression


```r
## plotting probability of getting death penalty as a function of aggravation
## separately for black (in black) and white (in red) victim
n.dots = 501 ## number of dots in the curves (the nubmer is set to make the curves smooth)
x.ag=dim(n.dots) ## x-value is the aggravating level (severity of the crime)
y.black=dim(n.dots) ## y-value for the black victim curve
y.white=dim(n.dots) ## y-value for the white victim curve
for (i in 1:n.dots) {
  x.ag[i]=(99+i)/100
  is.white = 0
  y.black[i]=exp(m1$coef[1]+m1$coef[2]*is.white+m1$coef[3]*x.ag[i])/(1+exp(m1$coef[1]+m1$coef[2]*is.white+m1$coef[3]*x.ag[i]))
  is.white = 1
  y.white[i]=exp(m1$coef[1]+m1$coef[2]*is.white+m1$coef[3]*x.ag[i])/(1+exp(m1$coef[1]+m1$coef[2]*is.white+m1$coef[3]*x.ag[i]))
}
plot(y.black~x.ag,type="l",col="black",ylab="Prob[Death]",xlab="Aggravation",ylim=c(0,1),main="red: white victim; black: black victim")
points(y.white~x.ag,type="l",col="red")
```

![plot of chunk unnamed-chunk-8](assets/fig/unnamed-chunk-8-1.png)

--- .scode-nowrap .compact 
## Logistic Regression

```r
## another format for logistic regression:
## summarized data
dpenother <- read.csv(sprintf("%s/DeathPenaltyOther.csv",data.url))
dpenother
```

```
##    Agg VicRace VRace Death Freq
## 1    1   White     1     1    2
## 2    1   White     1     0   60
## 3    1   Black     0     1    1
## 4    1   Black     0     0  181
## 5    2   White     1     1    2
## 6    2   White     1     0   15
## 7    2   Black     0     1    1
## 8    2   Black     0     0   21
## 9    3   White     1     1    6
## 10   3   White     1     0    7
## 11   3   Black     0     1    2
## 12   3   Black     0     0    9
## 13   4   White     1     1    9
## 14   4   White     1     0    3
## 15   4   Black     0     1    2
## 16   4   Black     0     0    4
## 17   5   White     1     1    9
## 18   5   Black     0     1    4
## 19   5   Black     0     0    3
## 20   6   White     1     1   17
## 21   6   Black     0     1    4
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
m1=glm(Death~VRace+Agg,family=binomial,weights=Freq,data=dpenother)
m1
```

```
## 
## Call:  glm(formula = Death ~ VRace + Agg, family = binomial, data = dpenother, 
##     weights = Freq)
## 
## Coefficients:
## (Intercept)        VRace          Agg  
##      -6.676        1.811        1.540  
## 
## Degrees of Freedom: 20 Total (i.e. Null);  18 Residual
## Null Deviance:	    321.9 
## Residual Deviance: 113.5 	AIC: 119.5
```

--- .ssscode-nowrap .compact 
## Logistic Regression

```r
summary(m1)
```

```
## 
## Call:
## glm(formula = Death ~ VRace + Agg, family = binomial, data = dpenother, 
##     weights = Freq)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -3.0355  -1.9341   0.7711   2.6921   3.6666  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -6.6760     0.7574  -8.814  < 2e-16 ***
## VRace         1.8106     0.5361   3.377 0.000732 ***
## Agg           1.5397     0.1867   8.246  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 321.88  on 20  degrees of freedom
## Residual deviance: 113.48  on 18  degrees of freedom
## AIC: 119.48
## 
## Number of Fisher Scoring iterations: 5
```

```r
exp(m1$coef[2])
```

```
##  VRace 
## 6.1144
```

```r
exp(m1$coef[3])
```

```
##      Agg 
## 4.663011
```


--- .model
## Logistic Regression

Example: Delayed Flights
-----------------------------
   * response variable: whether or not a flight has been delayed by more than 15 min (coded as 0 for no delay, and 1 for delay)
   * explanatory variables: different arrival airports, different departure airports, eight carriers, different hours of departure (6am to 10 pm), weather conditions (0 = good/1 = bad), day of week (1 for Sunday and Monday; and 0 for all other days)
   * objective: to identify flights that are likely to be delayed (a binary classification problem)


--- .scode-nowrap .compact 
## Logistic Regression

```r
library(car) ## needed to recode variables
set.seed(1) ## reset random seed for reproducibility

## read and print the data
data.url = 'http://www.yurulin.com/class/spring2014_datamining/data/data_text'
del <- read.csv(sprintf("%s/FlightDelays.csv",data.url))
del[1:3,]
```

```
##   schedtime carrier deptime dest distance     date flightnumber origin
## 1      1455      OH    1455  JFK      184 1/1/2004         5935    BWI
## 2      1640      DH    1640  JFK      213 1/1/2004         6155    DCA
## 3      1245      DH    1245  LGA      229 1/1/2004         7208    IAD
##   weather dayweek daymonth tailnu  delay
## 1       0       4        1 N940CA ontime
## 2       0       4        1 N405FJ ontime
## 3       0       4        1 N695BR ontime
```

--- .scode-nowrap .compact 
## Logistic Regression
* Convert data into desirable format: record and clean variables


```r
## define hours of departure
del$sched=factor(floor(del$schedtime/100))
del$delay=recode(del$delay,"'delayed'=1;else=0")
del$delay=as.numeric(levels(del$delay)[del$delay])
table(del$delay)
```

```
## 
##    0    1 
## 1773  428
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
## Delay: 1=Monday; 2=Tuesday; 3=Wednesday; 4=Thursday; 5=Friday; 6=Saturday; 7=Sunday
## 7=Sunday and 1=Monday coded as 1
del$dayweek=recode(del$dayweek,"c(1,7)=1;else=0")
table(del$dayweek)
```

```
## 
##    0    1 
## 1640  561
```

```r
## omit unused variables
del=del[,c(-1,-3,-5,-6,-7,-11,-12)]
del[1:3,]
```

```
##   carrier dest origin weather dayweek delay sched
## 1      OH  JFK    BWI       0       0     0    14
## 2      DH  JFK    DCA       0       0     0    16
## 3      DH  LGA    IAD       0       0     0    12
```


--- .scode-nowrap .compact 
## Logistic Regression

```r
## estimation of the logistic regression model
## explanatory variables: carrier, destination, origin, weather, day of week 
## (weekday/weekend), scheduled hour of departure
## create design matrix; indicators for categorical variables (factors)
Xdel = model.matrix(delay~.,data=del)[,-1] 
Xdel[1:3,]
```

```
##   carrierDH carrierDL carrierMQ carrierOH carrierRU carrierUA carrierUS
## 1         0         0         0         1         0         0         0
## 2         1         0         0         0         0         0         0
## 3         1         0         0         0         0         0         0
##   destJFK destLGA originDCA originIAD weather dayweek sched7 sched8 sched9
## 1       1       0         0         0       0       0      0      0      0
## 2       1       0         1         0       0       0      0      0      0
## 3       0       1         0         1       0       0      0      0      0
##   sched10 sched11 sched12 sched13 sched14 sched15 sched16 sched17 sched18
## 1       0       0       0       0       1       0       0       0       0
## 2       0       0       0       0       0       0       1       0       0
## 3       0       0       1       0       0       0       0       0       0
##   sched19 sched20 sched21
## 1       0       0       0
## 2       0       0       0
## 3       0       0       0
```


--- .scode-nowrap .compact 
## Logistic Regression
* Split the data into 60% training and 40% testing


```r
n.total=length(del$delay)
n.total
```

```
## [1] 2201
```

```r
n.train=floor(n.total*(0.6))
n.train
```

```
## [1] 1320
```

```r
n.test=n.total-n.train
n.test
```

```
## [1] 881
```

--- .ssscode-nowrap .compact 
## Logistic Regression


```r
train=sample(1:n.total,n.train) ## (randomly) sample indices for training set

xtrain = Xdel[train,]
xtest = Xdel[-train,]
ytrain = del$delay[train]
ytest = del$delay[-train]
m1 = glm(delay~.,family=binomial,data=data.frame(delay=ytrain,xtrain))
summary(m1)
```

```
## 
## Call:
## glm(formula = delay ~ ., family = binomial, data = data.frame(delay = ytrain, 
##     xtrain))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.3065  -0.6850  -0.5193  -0.2764   2.6671  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -0.506462   0.674045  -0.751 0.452426    
## carrierDH    -1.109683   0.587743  -1.888 0.059020 .  
## carrierDL    -1.687451   0.521459  -3.236 0.001212 ** 
## carrierMQ    -0.510547   0.496381  -1.029 0.303697    
## carrierOH    -2.262073   0.908804  -2.489 0.012808 *  
## carrierRU    -0.838344   0.424301  -1.976 0.048175 *  
## carrierUA    -1.602981   0.955408  -1.678 0.093387 .  
## carrierUS    -1.941613   0.529565  -3.666 0.000246 ***
## destJFK      -0.005843   0.317887  -0.018 0.985336    
## destLGA       0.171454   0.327708   0.523 0.600841    
## originDCA    -0.800683   0.413647  -1.936 0.052908 .  
## originIAD    -0.319476   0.401076  -0.797 0.425714    
## weather      17.881818 500.451538   0.036 0.971497    
## dayweek       0.669711   0.161234   4.154 3.27e-05 ***
## sched7       -0.168093   0.515374  -0.326 0.744305    
## sched8        0.338228   0.487051   0.694 0.487406    
## sched9       -0.450550   0.602829  -0.747 0.454826    
## sched10      -0.382502   0.601444  -0.636 0.524794    
## sched11      -0.578642   0.828878  -0.698 0.485113    
## sched12       0.614203   0.467384   1.314 0.188803    
## sched13      -0.232381   0.504607  -0.461 0.645143    
## sched14       0.973601   0.430169   2.263 0.023617 *  
## sched15       0.778466   0.454437   1.713 0.086706 .  
## sched16       0.528690   0.452783   1.168 0.242951    
## sched17       0.605440   0.422702   1.432 0.152056    
## sched18       0.169869   0.587675   0.289 0.772541    
## sched19       0.682830   0.500860   1.363 0.172783    
## sched20       0.922454   0.680325   1.356 0.175131    
## sched21       0.883470   0.441079   2.003 0.045180 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1312.7  on 1319  degrees of freedom
## Residual deviance: 1134.9  on 1291  degrees of freedom
## AIC: 1192.9
## 
## Number of Fisher Scoring iterations: 15
```


--- .sscode-nowrap .compact 
## Logistic Regression


```r
## prediction: predicted default probabilities for cases in test set
ptest = predict(m1,newdata=data.frame(xtest),type="response")
## the default predictions are of log-odds (probabilities on logit scale); 
## type = "response" gives the predicted probabilities
data.frame(ytest,ptest)[1:10,] ## look at the actual value vs. predicted value
```

```
##    ytest     ptest
## 1      0 0.1417566
## 5      0 0.1046429
## 6      0 0.1675298
## 9      0 0.2081648
## 10     0 0.2576931
## 12     0 0.1164139
## 15     0 0.1359269
## 17     0 0.1300306
## 21     0 0.1094095
## 22     0 0.1325476
```



--- .scode-nowrap .compact 
## Logistic Regression


```r
## measuring errors: coding as 1 if probability 0.5 or larger
btest=floor(ptest+0.5)  ## use floor function to clamp the value to 0 or 1
conf.matrix = table(ytest,btest)
conf.matrix
```

```
##      btest
## ytest   0   1
##     0 712   2
##     1 153  14
```

```r
error=(conf.matrix[1,2]+conf.matrix[2,1])/n.test
error
```

```
## [1] 0.1759364
```



--- .scode-nowrap .compact 
## Logistic Regression

Example: the delayed flights (Lift chart)
-----------------------------


```r
## order cases in test set according to their success prob
## actual outcome shown next to it
df=cbind(ptest,ytest)
df[1:20,]
```

```
##         ptest ytest
## 1  0.14175664     0
## 5  0.10464292     0
## 6  0.16752983     0
## 9  0.20816476     0
## 10 0.25769309     0
## 12 0.11641389     0
## 15 0.13592687     0
## 17 0.13003065     0
## 21 0.10940950     0
## 22 0.13254763     0
## 23 0.33790686     0
## 25 0.27619653     0
## 27 0.02853003     0
## 32 0.10030564     0
## 33 0.40824999     0
## 34 0.32314288     0
## 35 0.15093230     0
## 38 0.33143447     0
## 40 0.20912947     0
## 43 0.25753086     0
```


--- .sscode-nowrap .compact 
## Logistic Regression


```r
rank.df=as.data.frame(df[order(ptest,decreasing=TRUE),])
colnames(rank.df) = c('predicted','actual')
rank.df[1:20,]
```

```
##      predicted actual
## 1908 1.0000000      1
## 1850 1.0000000      1
## 1829 1.0000000      1
## 1877 1.0000000      1
## 1893 0.9999999      1
## 1868 0.9999999      1
## 1834 0.9999999      1
## 2102 0.9999999      1
## 1911 0.9999999      1
## 1823 0.9999999      1
## 1916 0.9999999      1
## 209  0.5740773      1
## 820  0.5740773      1
## 1254 0.5740773      1
## 1325 0.5740773      0
## 1849 0.5740773      0
## 288  0.4920023      1
## 821  0.4825933      0
## 1785 0.4728407      0
## 167  0.4698229      1
```



--- .scode-nowrap .compact 
## Logistic Regression


```r
## overall success (delay) prob in the evaluation data set
baserate=mean(ytest)
baserate
```

```
## [1] 0.1895573
```


--- .sscode-nowrap .compact 
## Logistic Regression


```r
## calculating the lift
## cumulative 1's sorted by predicted values
## cumulative 1's using the average success prob from evaluation set
ax=dim(n.test)
ay.base=dim(n.test)
ay.pred=dim(n.test)
ax[1]=1
ay.base[1]=baserate
ay.pred[1]=rank.df$actual[1]
for (i in 2:n.test) {
  ax[i]=i
  ay.base[i]=baserate*i ## uniformly increase with rate xbar
  ay.pred[i]=ay.pred[i-1]+rank.df$actual[i]
}

df=cbind(rank.df,ay.pred,ay.base)
df[1:20,]
```

```
##      predicted actual ay.pred   ay.base
## 1908 1.0000000      1       1 0.1895573
## 1850 1.0000000      1       2 0.3791146
## 1829 1.0000000      1       3 0.5686720
## 1877 1.0000000      1       4 0.7582293
## 1893 0.9999999      1       5 0.9477866
## 1868 0.9999999      1       6 1.1373439
## 1834 0.9999999      1       7 1.3269012
## 2102 0.9999999      1       8 1.5164586
## 1911 0.9999999      1       9 1.7060159
## 1823 0.9999999      1      10 1.8955732
## 1916 0.9999999      1      11 2.0851305
## 209  0.5740773      1      12 2.2746879
## 820  0.5740773      1      13 2.4642452
## 1254 0.5740773      1      14 2.6538025
## 1325 0.5740773      0      14 2.8433598
## 1849 0.5740773      0      14 3.0329171
## 288  0.4920023      1      15 3.2224745
## 821  0.4825933      0      15 3.4120318
## 1785 0.4728407      0      15 3.6015891
## 167  0.4698229      1      16 3.7911464
```



--- .scode-nowrap .compact 
## Logistic Regression


```r
plot(ax,ay.pred,xlab="number of cases",ylab="number of successes",main="Lift: Cum successes sorted by pred val/success prob")
points(ax,ay.base,type="l")
```

![plot of chunk unnamed-chunk-24](assets/fig/unnamed-chunk-24-1.png)

