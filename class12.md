---
title       : Class12
subtitle    : Data Processing and Features
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
## Class12
  
* [Set up](#set-up)
* [Big data set](#big)
* [Sparse matrix](#sparse)
* [Feature selection](#featureselection)
* [Frequent patterns](#freq)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- .compact
## Big data set

When dealing with big data files, do not read everything into memory.
We use the sample data from: http://grouplens.org/datasets/hetrec-2011/
See: http://files.grouplens.org/datasets/hetrec2011/hetrec2011-movielens-readme.txt
  

```r
## give the input filename
## (data path for input file: movies.dat)
ifilename = 'https://piazza.com/class_profile/get_resource/jl1epekmnw31h1/jox2c30z80q4f'
## read the first n=3 lines
lines = readLines(ifilename,n=3)
lines
```

```
## [1] "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
## [2] "<html>"                                                                                                                       
## [3] ""
```
