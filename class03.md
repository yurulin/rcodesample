---
title       : Class03
subtitle    : binary classification
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

## Class03
* [Set up](#set-up)
* [Split data into two classes](#two-class)
* [Logistic Regression](#logistic-regression)
* [Example: Death penelty data](##ex1)
* [Example: Delayed flights](##ex2)
* [kNN](#knn)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- #two-class .scode-nowrap .compact 

## Split data into two classes

The examples are taken from [Data Mining and Business Analytics with R](http://www.wiley.com/WileyCDA/WileyTitle/productCd-111844714X.html) and [Machine Learning for Hackers](http://shop.oreilly.com/product/0636920018483.do).



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

--- #logistic-regression  .model
## Logistic Regression

Example: Death penelty data
-----------------------------

   * objective: to identify whether the death penalty more likely if the victim is white, or the crime is more aggravating
   * response variable: getting death panelty or not
   * explanatory variables: severity of the crime, race of victim (black: 0; white: 1), etc

--- .scode-nowrap .compact ##ex1
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


--- .model ##ex2
## Logistic Regression

Example: Delayed Flights
------------------------

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

--- .sscode-nowrap .compact 
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

--- .ssscode-nowrap .compact 
## Logistic Regression


```
## 
## Call:
## glm(formula = delay ~ ., family = binomial, data = data.frame(delay = ytrain, 
##     xtrain))
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.2216  -0.6772  -0.5281  -0.3531   2.6610  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)   
## (Intercept)  -0.90788    0.66551  -1.364  0.17251   
## carrierDH    -0.88899    0.58988  -1.507  0.13179   
## carrierDL    -1.27041    0.51493  -2.467  0.01362 * 
## carrierMQ    -0.27574    0.49695  -0.555  0.57899   
## carrierOH    -1.70665    0.90758  -1.880  0.06005 . 
## carrierRU    -0.55706    0.42580  -1.308  0.19078   
## carrierUA    -0.87858    0.95414  -0.921  0.35715   
## carrierUS    -1.50848    0.52662  -2.864  0.00418 **
## destJFK       0.07171    0.31884   0.225  0.82206   
## destLGA       0.13013    0.33339   0.390  0.69629   
## originDCA    -0.49878    0.42828  -1.165  0.24417   
## originIAD    -0.07251    0.42327  -0.171  0.86399   
## weather      17.94673  518.83956   0.035  0.97241   
## dayweek       0.52898    0.16440   3.218  0.00129 **
## sched7        0.06378    0.46386   0.137  0.89064   
## sched8       -0.01011    0.45996  -0.022  0.98247   
## sched9       -0.58942    0.61810  -0.954  0.34029   
## sched10      -0.16001    0.54645  -0.293  0.76965   
## sched11       0.09688    0.63912   0.152  0.87951   
## sched12       0.23978    0.44425   0.540  0.58938   
## sched13      -0.72601    0.52616  -1.380  0.16764   
## sched14       0.73609    0.39598   1.859  0.06304 . 
## sched15       0.64755    0.42912   1.509  0.13130   
## sched16       0.44173    0.40755   1.084  0.27843   
## sched17       0.63126    0.37948   1.663  0.09621 . 
## sched18       0.19315    0.53792   0.359  0.71955   
## sched19       0.98114    0.43985   2.231  0.02571 * 
## sched20       0.35194    0.64191   0.548  0.58351   
## sched21       0.75079    0.40888   1.836  0.06632 . 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1304.3  on 1319  degrees of freedom
## Residual deviance: 1154.1  on 1291  degrees of freedom
## AIC: 1212.1
## 
## Number of Fisher Scoring iterations: 15
```

--- .scode-nowrap .compact 
## Logistic Regression


```r
## prediction: predicted default probabilities for cases in test set
ptest = predict(m1,newdata=data.frame(xtest),type="response")
## the default predictions are of log-odds (probabilities on logit scale); 
## type = "response" gives the predicted probabilities
data.frame(ytest,ptest)[1:10,] ## look at the actual value vs. predicted value
```

```
##    ytest      ptest
## 4      0 0.24824663
## 5      0 0.13019171
## 6      0 0.14090627
## 8      0 0.20489958
## 11     0 0.27121717
## 13     0 0.04163173
## 18     0 0.27624832
## 22     0 0.09293735
## 24     0 0.28808073
## 27     0 0.03310419
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
##     0 710   1
##     1 156  14
```

```r
error=(conf.matrix[1,2]+conf.matrix[2,1])/n.test
error
```

```
## [1] 0.1782066
```



--- .sscode-nowrap .compact
## Logistic Regression

Example: Delayed flights (Lift chart)
-----------------------------------------


```r
## order cases in test set according to their success prob
## actual outcome shown next to it
df=cbind(ptest,ytest)
df[1:20,]
```

```
##         ptest ytest
## 4  0.24824663     0
## 5  0.13019171     0
## 6  0.14090627     0
## 8  0.20489958     0
## 11 0.27121717     0
## 13 0.04163173     0
## 18 0.27624832     0
## 22 0.09293735     0
## 24 0.28808073     0
## 27 0.03310419     0
## 28 0.06367758     0
## 29 0.02900021     0
## 31 0.10398187     0
## 34 0.30286929     0
## 40 0.22476385     0
## 42 0.24627333     0
## 44 0.36440209     0
## 48 0.29113111     0
## 51 0.14103333     0
## 55 0.24824663     0
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
## 1828 1.0000000      1
## 1857 1.0000000      1
## 1908 1.0000000      1
## 1865 1.0000000      1
## 1829 1.0000000      1
## 1252 1.0000000      1
## 1914 1.0000000      1
## 1911 0.9999999      1
## 1815 0.9999999      1
## 1823 0.9999999      1
## 1868 0.9999999      1
## 1832 0.9999999      1
## 744  0.5258407      0
## 1257 0.5258407      1
## 1851 0.5258407      1
## 223  0.4931691      1
## 837  0.4931691      0
## 1336 0.4931691      1
## 1861 0.4931691      1
## 194  0.4894635      1
```



--- .sscode-nowrap .compact 
## Logistic Regression


```r
## overall success (delay) prob in the evaluation data set
baserate=mean(ytest)
baserate
```

```
## [1] 0.1929625
```

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
## 1828 1.0000000      1       1 0.1929625
## 1857 1.0000000      1       2 0.3859251
## 1908 1.0000000      1       3 0.5788876
## 1865 1.0000000      1       4 0.7718502
## 1829 1.0000000      1       5 0.9648127
## 1252 1.0000000      1       6 1.1577753
## 1914 1.0000000      1       7 1.3507378
## 1911 0.9999999      1       8 1.5437003
## 1815 0.9999999      1       9 1.7366629
## 1823 0.9999999      1      10 1.9296254
## 1868 0.9999999      1      11 2.1225880
## 1832 0.9999999      1      12 2.3155505
## 744  0.5258407      0      12 2.5085131
## 1257 0.5258407      1      13 2.7014756
## 1851 0.5258407      1      14 2.8944381
## 223  0.4931691      1      15 3.0874007
## 837  0.4931691      0      15 3.2803632
## 1336 0.4931691      1      16 3.4733258
## 1861 0.4931691      1      17 3.6662883
## 194  0.4894635      1      18 3.8592509
```



--- .scode-nowrap .compact 
## Logistic Regression


```r
plot(ax,ay.pred,xlab="number of cases",ylab="number of successes",
main="Lift: Cum successes sorted by\n pred val/success prob")
points(ax,ay.base,type="l")
```

<img src="assets/fig/unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" style="display: block; margin: auto;" />


--- .sscode-nowrap .compact 
## Logistic Regression

Example: Delayed flights (ROC)
----------------------------------


```r
## we use probability cutoff 1/2
## coding as 1 if probability 1/2 or larger
cut=1/2
gg1=floor(ptest+(1-cut))
conf.matrix=table(ytest,btest)
conf.matrix
```

```
##      btest
## ytest   0   1
##     0 710   1
##     1 156  14
```

```r
truepos <- ytest==1 & ptest>=cut 
trueneg <- ytest==0 & ptest<cut
# Sensitivity (predict default when it does happen)
sum(truepos)/sum(ytest==1) 
```

```
## [1] 0.08235294
```

```r
# Specificity (predict no default when it does not happen)
sum(trueneg)/sum(ytest==0) 
```

```
## [1] 0.9985935
```

--- .scode-nowrap .compact 
## Logistic Regression


```r
## using the ROCR package to graph the ROC curves 
library(ROCR)

## input is a data frame consisting of two columns
## predictions in first column and actual outcomes in the second 

## ROC for hold-out period
data=data.frame(predictions=ptest,labels=ytest)
data[1:10,]
```

```
##    predictions labels
## 4   0.24824663      0
## 5   0.13019171      0
## 6   0.14090627      0
## 8   0.20489958      0
## 11  0.27121717      0
## 13  0.04163173      0
## 18  0.27624832      0
## 22  0.09293735      0
## 24  0.28808073      0
## 27  0.03310419      0
```

--- .scode-nowrap .compact 
## Logistic Regression


```r
## pred: function to create prediction objects
pred <- prediction(data$predictions,data$labels)
str(pred)
```

```
## Formal class 'prediction' [package "ROCR"] with 11 slots
##   ..@ predictions:List of 1
##   .. ..$ : num [1:881] 0.248 0.13 0.141 0.205 0.271 ...
##   ..@ labels     :List of 1
##   .. ..$ : Ord.factor w/ 2 levels "0"<"1": 1 1 1 1 1 1 1 1 1 1 ...
##   ..@ cutoffs    :List of 1
##   .. ..$ : num [1:191] Inf 1 1 1 1 ...
##   ..@ fp         :List of 1
##   .. ..$ : num [1:191] 0 0 0 0 0 0 0 0 0 0 ...
##   ..@ tp         :List of 1
##   .. ..$ : num [1:191] 0 1 2 3 4 5 6 7 8 9 ...
##   ..@ tn         :List of 1
##   .. ..$ : num [1:191] 711 711 711 711 711 711 711 711 711 711 ...
##   ..@ fn         :List of 1
##   .. ..$ : num [1:191] 170 169 168 167 166 165 164 163 162 161 ...
##   ..@ n.pos      :List of 1
##   .. ..$ : int 170
##   ..@ n.neg      :List of 1
##   .. ..$ : int 711
##   ..@ n.pos.pred :List of 1
##   .. ..$ : num [1:191] 0 1 2 3 4 5 6 7 8 9 ...
##   ..@ n.neg.pred :List of 1
##   .. ..$ : num [1:191] 881 880 879 878 877 876 875 874 873 872 ...
```


--- .scode-nowrap .compact 
## Logistic Regression


```r
## perf: creates the input to be plotted
## sensitivity (TPR) and one minus specificity (FPR)
perf <- performance(pred, "sens", "fpr")
str(perf)
```

```
## Formal class 'performance' [package "ROCR"] with 6 slots
##   ..@ x.name      : chr "False positive rate"
##   ..@ y.name      : chr "Sensitivity"
##   ..@ alpha.name  : chr "Cutoff"
##   ..@ x.values    :List of 1
##   .. ..$ : num [1:191] 0 0 0 0 0 0 0 0 0 0 ...
##   ..@ y.values    :List of 1
##   .. ..$ : num [1:191] 0 0.00588 0.01176 0.01765 0.02353 ...
##   ..@ alpha.values:List of 1
##   .. ..$ : num [1:191] Inf 1 1 1 1 ...
```


--- .scode-nowrap .compact 
## Logistic Regression


```r
plot(perf)
```

![plot of chunk unnamed-chunk-29](assets/fig/unnamed-chunk-29-1.png)

--- #knn .scode-nowrap .compact 
## kNN

Example: Forensic Glass
-----------------------------

data set of 214 glass shards of six possible glass types
objective: to determine why types of glass based on characteristics including the refractive index (RI) and the percentages of Na, Mg, Al, Si, K, Ca, Ba, and Fe
6 groups of glass shards:
  
   - WinF: float glass window
   - WinNF: nonfloat window
   - Veh: vehicle window
   - Con: container (bottles)
   - Tabl: tableware
   - Head: vehicle headlamp

--- .scode-nowrap .compact 
## kNN
   

```r
library(MASS)   ## a library of example datasets

data(fgl)     ## loads the data into R; see help(fgl)
fgl[1:3,]
```

```
##      RI    Na   Mg   Al    Si    K   Ca Ba Fe type
## 1  3.01 13.64 4.49 1.10 71.78 0.06 8.75  0  0 WinF
## 2 -0.39 13.89 3.60 1.36 72.73 0.48 7.83  0  0 WinF
## 3 -1.82 13.53 3.55 1.54 72.99 0.39 7.78  0  0 WinF
```

--- .scode-nowrap .compact 
## kNN


```r
## use nt=200 training cases to find the nearest neighbors for 
## the remaining 14 cases. These 14 cases become the evaluation 
## (test, hold-out) cases

n=length(fgl$type)
nt=200
set.seed(1) ## to make the calculations reproducible in repeated runs
train <- sample(1:n,nt)

## Standardization of the data is preferable, especially if 
## units of the features are quite different
## could do this from scratch by calculating the mean and 
## standard deviation of each feature, and use those to 
## standardize.
x <- scale(fgl[,c(4,1)]) 
x <- scale(fgl[,c(1:9)]) ## using all nine dimensions (RI plus 8 chemical concentrations)
x[1:3,]
```

```
##           RI        Na        Mg         Al         Si           K
## 1  0.8708258 0.2842867 1.2517037 -0.6908222 -1.1244456 -0.67013422
## 2 -0.2487502 0.5904328 0.6346799 -0.1700615  0.1020797 -0.02615193
## 3 -0.7196308 0.1495824 0.6000157  0.1904651  0.4377603 -0.16414813
##           Ca         Ba         Fe
## 1 -0.1454254 -0.3520514 -0.5850791
## 2 -0.7918771 -0.3520514 -0.5850791
## 3 -0.8270103 -0.3520514 -0.5850791
```


--- .scode-nowrap .compact 
## kNN


```r
library(class)  
nearest1 <- knn(train=x[train,],test=x[-train,],cl=fgl$type[train],k=1)
nearest5 <- knn(train=x[train,],test=x[-train,],cl=fgl$type[train],k=5)
data.frame(fgl$type[-train],nearest1,nearest5)
```

```
##    fgl.type..train. nearest1 nearest5
## 1              WinF     WinF     WinF
## 2              WinF      Veh     WinF
## 3              WinF     WinF     WinF
## 4              WinF    WinNF    WinNF
## 5              WinF     WinF      Veh
## 6              WinF     WinF     WinF
## 7              WinF     WinF     WinF
## 8             WinNF    WinNF    WinNF
## 9             WinNF    WinNF    WinNF
## 10            WinNF      Veh    WinNF
## 11            WinNF    WinNF    WinNF
## 12            WinNF     WinF    WinNF
## 13              Con      Con      Con
## 14             Tabl     Tabl     Tabl
```



--- .scode-nowrap .compact 
## kNN


```r
## calculate the proportion of correct classifications on this one 
## training set

pcorrn1=100*sum(fgl$type[-train]==nearest1)/(n-nt)
pcorrn5=100*sum(fgl$type[-train]==nearest5)/(n-nt)
pcorrn1
```

```
## [1] 71.42857
```

```r
pcorrn5
```

```
## [1] 85.71429
```

```r
## Note: Different runs may give you slightly different results as ties 
## are broken at random
```
