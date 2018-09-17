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
## Class04

* [Set up](#set-up)
* [Naive Bayesian](#nb)
* [Decision Trees](#tree)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
install.packages('tree')
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
## Naive Bayesian

```r
del=data.frame(delay)
del$schedf=factor(floor(del$schedtime/100))
del$delay=recode(del$delay,"'delayed'=1;else=0")
response=as.numeric(levels(del$delay)[del$delay])
hist(response)
```

![plot of chunk class04-chunk-3](assets/fig/class04-chunk-3-1.png)

--- .sscode-nowrap .compact
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
tttrain1=tttt[tttt[,7]>0.5,]

## prior probabilities
tdel=table(response[train])
tdel=tdel/sum(tdel)
tdel
```

```
## 
##         0         1 
## 0.8022727 0.1977273
```

--- .ssscode-nowrap .compact
## Naive Bayesian

```r
## scheduled time
ts0=table(tttrain0[,1])
ts0=ts0/sum(ts0)
ts0
```

```
## 
##          1          2          3          4          5          6 
## 0.06137866 0.06798867 0.07176582 0.05949008 0.05004721 0.03399433 
##          7          8          9         10         11         12 
## 0.06421152 0.07743154 0.09537299 0.06326723 0.07743154 0.10198300 
##         13         14         15         16 
## 0.04249292 0.04627007 0.02171860 0.06515581
```

```r
ts1=table(tttrain1[,1])
ts1=ts1/sum(ts1)
ts1
```

```
## 
##           1           2           3           4           5           6 
## 0.038314176 0.045977011 0.065134100 0.026819923 0.026819923 0.007662835 
##           7           8           9          10          11          12 
## 0.065134100 0.049808429 0.153256705 0.091954023 0.076628352 0.145593870 
##          13          14          15          16 
## 0.026819923 0.065134100 0.015325670 0.099616858
```

```r
## scheduled carrier
tc0=table(tttrain0[,2])
tc0=tc0/sum(tc0)
tc0
```

```
## 
##          1          2          3          4          5          6 
## 0.04060434 0.22757318 0.18508026 0.12181303 0.01510859 0.18035883 
##          7          8 
## 0.01510859 0.21435316
```

```r
tc1=table(tttrain1[,2])
tc1=tc1/sum(tc1)
tc1
```

```
## 
##          1          2          3          4          5          6 
## 0.06896552 0.33716475 0.09195402 0.17624521 0.01149425 0.22222222 
##          7          8 
## 0.01532567 0.07662835
```

--- .ssscode-nowrap .compact
## Naive Bayesian

```r
## scheduled destination
td0=table(tttrain0[,3])
td0=td0/sum(td0)
td0
```

```
## 
##         1         2         3 
## 0.2861190 0.1690274 0.5448536
```

```r
td1=table(tttrain1[,3])
td1=td1/sum(td1)
td1
```

```
## 
##         1         2         3 
## 0.3869732 0.2107280 0.4022989
```

```r
## scheduled origin  
to0=table(tttrain0[,4])
to0=to0/sum(to0)
to0
```

```
## 
##          1          2          3 
## 0.06421152 0.65250236 0.28328612
```

```r
to1=table(tttrain1[,4])
to1=to1/sum(to1)
to1
```

```
## 
##          1          2          3 
## 0.09578544 0.49042146 0.41379310
```

--- .ssscode-nowrap .compact
## Naive Bayesian

```r
## weather
tw0=table(tttrain0[,5])
tw0=tw0/sum(tw0)
tw0
```

```
## 
## 0 
## 1
```

```r
tw1=table(tttrain1[,5])
tw1=tw1/sum(tw1)
tw1
```

```
## 
##          0          1 
## 0.91954023 0.08045977
```

```r
## bandaid as no observation in a cell
tw0=tw1
tw0[1]=1
tw0[2]=0

## scheduled day of week
tdw0=table(tttrain0[,6])
tdw0=tdw0/sum(tdw0)
tdw0
```

```
## 
##          1          2          3          4          5          6 
## 0.12747875 0.13692162 0.15391879 0.17847025 0.17563739 0.12842304 
##          7 
## 0.09915014
```

```r
tdw1=table(tttrain1[,6])
tdw1=tdw1/sum(tdw1)
tdw1
```

```
## 
##          1          2          3          4          5          6 
## 0.20689655 0.15325670 0.12643678 0.14176245 0.14559387 0.05363985 
##          7 
## 0.17241379
```

--- .sscode-nowrap .compact
## Naive Bayesian

```r
## creating test data set
tt=cbind(del$schedf[-train],del$carrier[-train],del$dest[-train],del$origin[-train],del$weather[-train],del$dayweek[-train],response[-train])

## creating predictions, stored in gg
p0=ts0[tt[,1]]*tc0[tt[,2]]*td0[tt[,3]]*to0[tt[,4]]*tw0[tt[,5]+1]*tdw0[tt[,6]]
p1=ts1[tt[,1]]*tc1[tt[,2]]*td1[tt[,3]]*to1[tt[,4]]*tw1[tt[,5]+1]*tdw1[tt[,6]]
gg=(p1*tdel[2])/(p1*tdel[2]+p0*tdel[1])
hist(gg)
```

![plot of chunk class04-chunk-8](assets/fig/class04-chunk-8-1.png)

--- .sscode-nowrap .compact
## Naive Bayesian

```r
## coding as 1 if probability 0.5 or larger
gg1=floor(gg+0.5)
ttt=table(response[-train],gg1)
ttt
```

```
##    gg1
##       0   1
##   0 679  35
##   1 137  30
```

```r
error=(ttt[1,2]+ttt[2,1])/n2
error
```

```
## [1] 0.1952327
```


--- #tree .scode-nowrap .compact
## Decision Trees

Example: Fisher Iris
-----------------------------


```r
library(MASS) 
library(tree)
## read in the iris data
iris[1:3,]
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
```

--- .scode-nowrap .compact
## Decision Trees

```r
iristree <- tree(Species~.,data=iris)
iristree  
```

```
## node), split, n, deviance, yval, (yprob)
##       * denotes terminal node
## 
##  1) root 150 329.600 setosa ( 0.33333 0.33333 0.33333 )  
##    2) Petal.Length < 2.45 50   0.000 setosa ( 1.00000 0.00000 0.00000 ) *
##    3) Petal.Length > 2.45 100 138.600 versicolor ( 0.00000 0.50000 0.50000 )  
##      6) Petal.Width < 1.75 54  33.320 versicolor ( 0.00000 0.90741 0.09259 )  
##       12) Petal.Length < 4.95 48   9.721 versicolor ( 0.00000 0.97917 0.02083 )  
##         24) Sepal.Length < 5.15 5   5.004 versicolor ( 0.00000 0.80000 0.20000 ) *
##         25) Sepal.Length > 5.15 43   0.000 versicolor ( 0.00000 1.00000 0.00000 ) *
##       13) Petal.Length > 4.95 6   7.638 virginica ( 0.00000 0.33333 0.66667 ) *
##      7) Petal.Width > 1.75 46   9.635 virginica ( 0.00000 0.02174 0.97826 )  
##       14) Petal.Length < 4.95 6   5.407 virginica ( 0.00000 0.16667 0.83333 ) *
##       15) Petal.Length > 4.95 40   0.000 virginica ( 0.00000 0.00000 1.00000 ) *
```

--- .scode-nowrap .compact
## Decision Trees

```r
plot(iristree)
```

![plot of chunk class04-chunk-12](assets/fig/class04-chunk-12-1.png)

--- .scode-nowrap .compact
## Decision Trees

```r
plot(iristree,col=8)
text(iristree,digits=2)
```

![plot of chunk class04-chunk-13](assets/fig/class04-chunk-13-1.png)

--- .scode-nowrap .compact
## Decision Trees

```r
summary(iristree)
```

```
## 
## Classification tree:
## tree(formula = Species ~ ., data = iris)
## Variables actually used in tree construction:
## [1] "Petal.Length" "Petal.Width"  "Sepal.Length"
## Number of terminal nodes:  6 
## Residual mean deviance:  0.1253 = 18.05 / 144 
## Misclassification error rate: 0.02667 = 4 / 150
```


--- .scode-nowrap .compact
## Decision Trees

```r
# splitting on 7 and 12 lead to identical results, and these nodes and the
# trees below them can be snipped off
irissnip=snip.tree(iristree,nodes=c(7,12))
irissnip
```

```
## node), split, n, deviance, yval, (yprob)
##       * denotes terminal node
## 
##  1) root 150 329.600 setosa ( 0.33333 0.33333 0.33333 )  
##    2) Petal.Length < 2.45 50   0.000 setosa ( 1.00000 0.00000 0.00000 ) *
##    3) Petal.Length > 2.45 100 138.600 versicolor ( 0.00000 0.50000 0.50000 )  
##      6) Petal.Width < 1.75 54  33.320 versicolor ( 0.00000 0.90741 0.09259 )  
##       12) Petal.Length < 4.95 48   9.721 versicolor ( 0.00000 0.97917 0.02083 ) *
##       13) Petal.Length > 4.95 6   7.638 virginica ( 0.00000 0.33333 0.66667 ) *
##      7) Petal.Width > 1.75 46   9.635 virginica ( 0.00000 0.02174 0.97826 ) *
```


--- .scode-nowrap .compact
## Decision Trees

```r
plot(irissnip)
text(irissnip)
```

![plot of chunk class04-chunk-16](assets/fig/class04-chunk-16-1.png)

--- ##ex .scode-nowrap .compact
## Example: Prostate cancer

```r
data.url = 'http://www.yurulin.com/class/spring2014_datamining/data/data_text'
prostate <- read.csv(sprintf("%s/prostate.csv",data.url))
prostate[1:3,]
```

```
##       lcavol age      lbph       lcp gleason       lpsa
## 1 -0.5798185  50 -1.386294 -1.386294       6 -0.4307829
## 2 -0.9942523  58 -1.386294 -1.386294       6 -0.1625189
## 3 -0.5108256  74 -1.386294 -1.386294       7 -0.1625189
```

--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
library(tree)
## Construct the tree
## You can further control the tree:
## mincut -- The minimum number of observations to include in either child node;
## mindev -- The within-node deviance must be at least this times that of the root node for the node to be split.
pstree <- tree(lcavol ~., data=prostate, mindev=0.1, mincut=1)
pstree <- tree(lcavol ~., data=prostate, mincut=1)
pstree
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
##   1) root 97 133.4000  1.35000  
##     2) lcp < 0.261624 63  64.1100  0.79250  
##       4) lpsa < 2.30257 35  24.7200  0.27870  
##         8) lpsa < 0.104522 4   0.3311 -0.82220 *
##         9) lpsa > 0.104522 31  18.9200  0.42070  
##          18) age < 52 3   0.1195 -0.79620 *
##          19) age > 52 28  13.8800  0.55110  
##            38) lbph < 1.09012 18   6.3190  0.73790  
##              76) age < 65.5 14   4.0670  0.55550  
##               152) lcp < -0.698172 11   2.1200  0.37820 *
##               153) lcp > -0.698172 3   0.3329  1.20600 *
##              77) age > 65.5 4   0.1552  1.37600 *
##            39) lbph > 1.09012 10   5.8010  0.21490  
##              78) lpsa < 1.96623 7   2.8370 -0.08817 *
##              79) lpsa > 1.96623 3   0.8212  0.92200 *
##       5) lpsa > 2.30257 28  18.6000  1.43500  
##        10) lpsa < 3.24598 23  11.6100  1.23300 *
##        11) lpsa > 3.24598 5   1.7560  2.36200 *
##     3) lcp > 0.261624 34  13.3900  2.38300  
##       6) lcp < 2.13963 25   6.6620  2.14700  
##        12) age < 62.5 7   0.7253  1.68600 *
##        13) age > 62.5 18   3.8700  2.32600 *
##       7) lcp > 2.13963 9   1.4750  3.03800 *
```



--- .scode-nowrap .compact
## Example: Prostate cancer

```r
plot(pstree, col=8)
text(pstree, digits=2)
```

![plot of chunk class04-chunk-19](assets/fig/class04-chunk-19-1.png)


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
# vary the panelty term k in pruning
pstcut <- prune.tree(pstree,k=1.7)
plot(pstcut)
```

![plot of chunk class04-chunk-20](assets/fig/class04-chunk-20-1.png)


--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
pstcut
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
##  1) root 97 133.4000  1.35000  
##    2) lcp < 0.261624 63  64.1100  0.79250  
##      4) lpsa < 2.30257 35  24.7200  0.27870  
##        8) lpsa < 0.104522 4   0.3311 -0.82220 *
##        9) lpsa > 0.104522 31  18.9200  0.42070  
##         18) age < 52 3   0.1195 -0.79620 *
##         19) age > 52 28  13.8800  0.55110  
##           38) lbph < 1.09012 18   6.3190  0.73790  
##             76) age < 65.5 14   4.0670  0.55550 *
##             77) age > 65.5 4   0.1552  1.37600 *
##           39) lbph > 1.09012 10   5.8010  0.21490  
##             78) lpsa < 1.96623 7   2.8370 -0.08817 *
##             79) lpsa > 1.96623 3   0.8212  0.92200 *
##      5) lpsa > 2.30257 28  18.6000  1.43500  
##       10) lpsa < 3.24598 23  11.6100  1.23300 *
##       11) lpsa > 3.24598 5   1.7560  2.36200 *
##    3) lcp > 0.261624 34  13.3900  2.38300  
##      6) lcp < 2.13963 25   6.6620  2.14700  
##       12) age < 62.5 7   0.7253  1.68600 *
##       13) age > 62.5 18   3.8700  2.32600 *
##      7) lcp > 2.13963 9   1.4750  3.03800 *
```


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
pstcut <- prune.tree(pstree,k=2.05)
plot(pstcut)
```

![plot of chunk class04-chunk-22](assets/fig/class04-chunk-22-1.png)

--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
pstcut
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
##  1) root 97 133.4000  1.3500  
##    2) lcp < 0.261624 63  64.1100  0.7925  
##      4) lpsa < 2.30257 35  24.7200  0.2787  
##        8) lpsa < 0.104522 4   0.3311 -0.8222 *
##        9) lpsa > 0.104522 31  18.9200  0.4207  
##         18) age < 52 3   0.1195 -0.7962 *
##         19) age > 52 28  13.8800  0.5511 *
##      5) lpsa > 2.30257 28  18.6000  1.4350  
##       10) lpsa < 3.24598 23  11.6100  1.2330 *
##       11) lpsa > 3.24598 5   1.7560  2.3620 *
##    3) lcp > 0.261624 34  13.3900  2.3830  
##      6) lcp < 2.13963 25   6.6620  2.1470  
##       12) age < 62.5 7   0.7253  1.6860 *
##       13) age > 62.5 18   3.8700  2.3260 *
##      7) lcp > 2.13963 9   1.4750  3.0380 *
```

--- .scode-nowrap .compact
## Example: Prostate cancer

```r
pstcut <- prune.tree(pstree,k=3)
plot(pstcut)
```

![plot of chunk class04-chunk-24](assets/fig/class04-chunk-24-1.png)


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
pstcut
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
##  1) root 97 133.4000  1.3500  
##    2) lcp < 0.261624 63  64.1100  0.7925  
##      4) lpsa < 2.30257 35  24.7200  0.2787  
##        8) lpsa < 0.104522 4   0.3311 -0.8222 *
##        9) lpsa > 0.104522 31  18.9200  0.4207  
##         18) age < 52 3   0.1195 -0.7962 *
##         19) age > 52 28  13.8800  0.5511 *
##      5) lpsa > 2.30257 28  18.6000  1.4350  
##       10) lpsa < 3.24598 23  11.6100  1.2330 *
##       11) lpsa > 3.24598 5   1.7560  2.3620 *
##    3) lcp > 0.261624 34  13.3900  2.3830  
##      6) lcp < 2.13963 25   6.6620  2.1470 *
##      7) lcp > 2.13963 9   1.4750  3.0380 *
```

--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
pstcut <- prune.tree(pstree)
pstcut
```

```
## $size
##  [1] 12 11  8  7  6  5  4  3  2  1
## 
## $dev
##  [1]  26.15491  27.76888  33.76664  35.83388  40.75225  45.98251  51.23381
##  [8]  56.70719  77.50140 133.35903
## 
## $k
##  [1]      -Inf  1.613972  1.999253  2.067239  4.918373  5.230262  5.251294
##  [8]  5.473378 20.794213 55.857635
## 
## $method
## [1] "deviance"
## 
## attr(,"class")
## [1] "prune"         "tree.sequence"
```


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
plot(pstcut)
```

![plot of chunk class04-chunk-27](assets/fig/class04-chunk-27-1.png)

--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
pstcut <- prune.tree(pstree,best=3)
pstcut
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
## 1) root 97 133.40 1.3500  
##   2) lcp < 0.261624 63  64.11 0.7925  
##     4) lpsa < 2.30257 35  24.72 0.2787 *
##     5) lpsa > 2.30257 28  18.60 1.4350 *
##   3) lcp > 0.261624 34  13.39 2.3830 *
```


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
plot(pstcut)
```

![plot of chunk class04-chunk-29](assets/fig/class04-chunk-29-1.png)

--- .scode-nowrap .compact
## Example: Prostate cancer

```r
## Use cross-validation to prune the tree
set.seed(2)
cvpst <- cv.tree(pstree, K=10)
cvpst$size
```

```
##  [1] 12 11  8  7  6  5  4  3  2  1
```

```r
cvpst$dev
```

```
##  [1]  73.22055  70.18426  70.79439  70.24455  65.40004  65.30020  65.30020
##  [8]  64.93791  90.18312 134.09981
```


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
plot(cvpst, pch=21, bg=8, type="p", cex=1.5, ylim=c(65,100))
```

![plot of chunk class04-chunk-31](assets/fig/class04-chunk-31-1.png)

--- .sscode-nowrap .compact
## Example: Prostate cancer

```r
pstcut <- prune.tree(pstree, best=3)
pstcut
```

```
## node), split, n, deviance, yval
##       * denotes terminal node
## 
## 1) root 97 133.40 1.3500  
##   2) lcp < 0.261624 63  64.11 0.7925  
##     4) lpsa < 2.30257 35  24.72 0.2787 *
##     5) lpsa > 2.30257 28  18.60 1.4350 *
##   3) lcp > 0.261624 34  13.39 2.3830 *
```


--- .scode-nowrap .compact
## Example: Prostate cancer

```r
plot(pstcut, col=8)
text(pstcut)
```

![plot of chunk class04-chunk-33](assets/fig/class04-chunk-33-1.png)

--- .scode-nowrap .compact
## Example: Prostate cancer

```r
## Plot what we end up with
plot(prostate[,c("lcp","lpsa")],cex=0.2*exp(prostate$lcavol))
abline(v=.261624, col=4, lwd=2)
lines(x=c(-2,.261624), y=c(2.30257,2.30257), col=4, lwd=2)  
```

![plot of chunk class04-chunk-34](assets/fig/class04-chunk-34-1.png)
