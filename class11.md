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

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- .modal 
## Recommendation

* The sample code is based on the examples given in http://cran.r-project.org/web/packages/recommenderlab/vignettes/recommenderlab.pdf


```r
library("recommenderlab")
```

```
## Error in library("recommenderlab"): there is no package called 'recommenderlab'
```

--- .modal #data
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
##   u1 NA NA NA NA NA  4  2 NA NA   4
##   u2 NA NA NA NA NA  4 NA NA NA   4
##   u3  3 NA NA NA NA  0 NA  2  5   4
##   u4  2  0  1 NA NA NA NA NA NA   4
##   u5  2 NA  5  5 NA NA NA NA NA  NA
```

--- .modal 
## Data manipulation


```r
r = as(m, "realRatingMatrix") ## store the matrix in sparse format
```

```
## Error in as(m, "realRatingMatrix"): no method or default for coercing "matrix" to "realRatingMatrix"
```

```r
## The realRatingMatrix can be coerced back into a matrix which is identical to the original matrix
identical(as(r, "matrix"),m)
```

```
## Error in .class1(object): object 'r' not found
```

--- .modal 
## Data manipulation


