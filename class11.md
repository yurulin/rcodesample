---
title       : Class11
subtitle    : Recommendation
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
## Class11
  
* [Set up](#set-up)
* [Data manipulation](#data)
* [Sample dataset](#sample)
* [Recommender System](#recommender)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
install.packages('recommenderlab')
```

--- .compact
## Recommendation

* The sample code is based on the examples given in http://cran.r-project.org/web/packages/recommenderlab/vignettes/recommenderlab.pdf
* See information about the installation and more details about what the package can do in the manual.


```r
library(recommenderlab)
```

--- .scode-nowrap .compact #data
## Data manipulation


```r
## create a toy reating matrix
m = matrix(sample(c(as.numeric(0:5), NA), 50,
                  replace=TRUE, prob=c(rep(.4/6,6),.6)), ncol=10,
           dimnames=list(user=paste("u", 1:5, sep=''),
                         item=paste("i", 1:10, sep='')))
m
```

```
##     item
## user i1 i2 i3 i4 i5 i6 i7 i8 i9 i10
##   u1 NA NA NA  3 NA NA NA NA  1  NA
##   u2 NA NA NA NA NA NA NA  3 NA   4
##   u3  3  3 NA NA  4  0  3  4 NA   4
##   u4  1 NA NA NA  5 NA  1 NA NA  NA
##   u5 NA NA NA NA NA NA NA  3 NA   0
```

--- .scode-nowrap .compact 
## Data manipulation


```r
r = as(m, "realRatingMatrix") ## store the matrix in sparse format
## The realRatingMatrix can be coerced back into a matrix which is identical to the original matrix
identical(as(r, "matrix"),m)
```

```
## [1] TRUE
```

--- .sscode-nowrap .compact
## Data manipulation


```r
## a list of users
as(r, "list")
```

```
## $u1
## i4 i9 
##  3  1 
## 
## $u2
##  i8 i10 
##   3   4 
## 
## $u3
##  i1  i2  i5  i6  i7  i8 i10 
##   3   3   4   0   3   4   4 
## 
## $u4
## i1 i5 i7 
##  1  5  1 
## 
## $u5
##  i8 i10 
##   3   0
```

--- .sscode-nowrap .compact
## Data manipulation


```r
## rating data in data.frame format
head(as(r, "data.frame"))
```

```
##    user item rating
## 4    u1   i4      3
## 13   u1   i9      1
## 10   u2   i8      3
## 14   u2  i10      4
## 1    u3   i1      3
## 3    u3   i2      3
```

--- .scode-nowrap .compact
## Data manipulation


```r
## normalization: remove rating bias by subtracting the row mean from all ratings in the row
r_m = normalize(r)
r_m
```

```
## 5 x 10 rating matrix of class 'realRatingMatrix' with 16 ratings.
## Normalized using center on rows.
```

--- .scode-nowrap .compact
## Data manipulation


```r
r_z = normalize(r,method="Z-score")
r_z
```

```
## 5 x 10 rating matrix of class 'realRatingMatrix' with 16 ratings.
## Normalized using z-score on rows.
```

--- .scode-nowrap .compact
## Data manipulation


```r
## visualize the matrices
image(r, main = "Raw Ratings")
```

![plot of chunk class11-chunk-9](assets/fig/class11-chunk-9-1.png)

--- .scode-nowrap .compact
## Data manipulation


```r
image(r_m, main = "Normalized Ratings")
```

![plot of chunk class11-chunk-10](assets/fig/class11-chunk-10-1.png)

--- .scode-nowrap .compact
## Data manipulation


```r
image(r_z, main = "Normalized Ratings (Z-score)")
```

![plot of chunk class11-chunk-11](assets/fig/class11-chunk-11-1.png)

--- .sscode-nowrap .compact
## Data manipulation


```r
## Binarization: transform the real-valued matrix into a 0-1 matrix based on a user specified threshold (min_ratings)
r_b = binarize(r, minRating=4)
as(r_b, "matrix")
```

```
##       i1    i2    i3    i4    i5    i6    i7    i8    i9   i10
## u1 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## u2 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
## u3 FALSE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE  TRUE
## u4 FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE
## u5 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```

--- .scode-nowrap .compact #sample
## Sample dataset


```r
## load the Jester5k data: it contains a sample of 5000 users from the anonymous ratings data from the Jester Online Joke Recommender System collected between April 1999 and May 2003 (Goldberg, Roeder, Gupta, and Perkins, 2001).

data(Jester5k)
Jester5k
```

```
## 5000 x 100 rating matrix of class 'realRatingMatrix' with 362106 ratings.
```

--- .sscode-nowrap .compact
## Sample dataset


```r
set.seed(1) ## reset random seed before sampling

## use only a subset of the data containing a sample of 1000 users
r = sample(Jester5k, 1000)

## the ratings for the first user
rowCounts(r[1,])
```

```
## u175 
##   38
```

```r
as(r[1,], "list")
```

```
## $u175
##    j5    j7    j8   j10   j13   j15   j16   j17   j18   j19   j20   j21 
## -4.32  3.45  4.37  5.73 -9.76  2.77  2.48 -0.10  0.58  1.12  5.58  5.49 
##   j27   j28   j29   j32   j33   j35   j36   j47   j48   j49   j50   j53 
##  3.98  4.76  3.16  2.72 -6.50  3.64  1.17  3.40  3.16  8.69  0.58  1.99 
##   j54   j56   j59   j60   j61   j62   j65   j66   j68   j69   j74   j77 
##  7.72  7.14  0.05  7.82  3.59  6.84  3.35 -8.06  7.43 -0.68  2.91  1.70 
##   j81   j95 
## -3.06  7.14
```

--- .scode-nowrap .compact
## Sample dataset


```r
rowMeans(r[1,]) ## The user has rated 38 jokes, the list shows the ratings and the user's rating average is 1.4731
```

```
## Error in rowMeans(r[1, ]): 'x' must be an array of at least two dimensions
```

```r
rowMeans(as(r[1,], "matrix"),na.rm=TRUE)
```

```
##     u175 
## 2.421842
```

--- .scode-nowrap .compact
## Sample dataset


```r
## generate a histogram to show the distribution of the ratings
hist(getRatings(r), breaks=100)
```

![plot of chunk class11-chunk-16](assets/fig/class11-chunk-16-1.png)

--- .scode-nowrap .compact
## Sample dataset


```r
## the distribution after normalization
hist(getRatings(normalize(r)), breaks=100)
```

![plot of chunk class11-chunk-17](assets/fig/class11-chunk-17-1.png)

--- .scode-nowrap .compact
## Sample dataset


```r
hist(getRatings(normalize(r, method="Z-score")), breaks=100)
```

![plot of chunk class11-chunk-18](assets/fig/class11-chunk-18-1.png)

--- .scode-nowrap .compact
## Sample dataset


```r
## how many jokes each user has rated
hist(rowCounts(r), breaks=50)
```

![plot of chunk class11-chunk-19](assets/fig/class11-chunk-19-1.png)

--- .scode-nowrap .compact
## Sample dataset


```r
## the mean rating for each joke
hist(colMeans(r), breaks=20)
```

```
## Error in colMeans(r): 'x' must be an array of at least two dimensions
```

--- .scode-nowrap .compact #recommender
## Recommender System


```r
## (training) create a recommender which generates recommendations solely on the popularity of items (the number of users who have the item in their profile)
r = Recommender(Jester5k[1:1000], method = "POPULAR")
r
```

```
## Recommender of type 'POPULAR' for 'realRatingMatrix' 
## learned using 1000 users.
```

```r
## get the model by getModel()
names(getModel(r))
```

```
## [1] "topN"                  "ratings"               "normalize"            
## [4] "aggregationRatings"    "aggregationPopularity" "verbose"
```

--- .sscode-nowrap .compact
## Recommender System


```r
getModel(r)$topN
```

```
## Recommendations as 'topNList' with n = 100 for 1 users.
```

```r
## (prediction) create top-5 recommendation lists for two users who were not used to learn the model
recom = predict(r, Jester5k[1001:1002], n=5)
recom
```

```
## Recommendations as 'topNList' with n = 5 for 2 users.
```

```r
as(recom, "list")
```

```
## $u20089
## [1] "j89" "j72" "j47" "j93" "j76"
## 
## $u11691
## [1] "j89" "j93" "j76" "j88" "j96"
```

--- .scode-nowrap .compact
## Recommender System



--- .scode-nowrap .compact
## Recommender System



