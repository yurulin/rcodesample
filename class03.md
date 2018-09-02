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

--- .compact 

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

--- .compact 

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
