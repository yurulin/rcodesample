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

--- .compact #big
## Big data set

* When dealing with big data files, do not read everything into memory.
* We use the sample data from: http://grouplens.org/datasets/hetrec-2011/
* See: http://files.grouplens.org/datasets/hetrec2011/hetrec2011-movielens-readme.txt
  

```r
## give the input filename
data.path = 'hetrec2011'
ifilename = sprintf('%s/movies.dat',data.path)
## read the first n=3 lines
lines = readLines(ifilename,n=3)
lines
```

```
## [1] "id\ttitle\timdbID\tspanishTitle\timdbPictureURL\tyear\trtID\trtAllCriticsRating\trtAllCriticsNumReviews\trtAllCriticsNumFresh\trtAllCriticsNumRotten\trtAllCriticsScore\trtTopCriticsRating\trtTopCriticsNumReviews\trtTopCriticsNumFresh\trtTopCriticsNumRotten\trtTopCriticsScore\trtAudienceRating\trtAudienceNumRatings\trtAudienceScore\trtPictureURL"
## [2] "1\tToy story\t0114709\tToy story (juguetes)\thttp://ia.media-imdb.com/images/M/MV5BMTMwNDU0NTY2Nl5BMl5BanBnXkFtZTcwOTUxOTM5Mw@@._V1._SX214_CR0,0,214,314_.jpg\t1995\ttoy_story\t9\t73\t73\t0\t100\t8.5\t17\t17\t0\t100\t3.7\t102338\t81\thttp://content7.flixster.com/movie/10/93/63/10936393_det.jpg"                                                     
## [3] "2\tJumanji\t0113497\tJumanji\thttp://ia.media-imdb.com/images/M/MV5BMzM5NjE1OTMxNV5BMl5BanBnXkFtZTcwNDY2MzEzMQ@@._V1._SY314_CR3,0,214,314_.jpg\t1995\t1068044-jumanji\t5.6\t28\t13\t15\t46\t5.8\t5\t2\t3\t40\t3.2\t44587\t61\thttp://content8.flixster.com/movie/56/79/73/5679734_det.jpg"
```

--- .ssscode-nowrap .compact 
## Big data set

```r
## read the first 3 rows into a data.frame object
df = read.csv(ifilename, sep='\t', nrows=3) ## we saw from the first few lines that the field separator is <TAB>
df
```

```
##   id          title imdbID           spanishTitle
## 1  1      Toy story 114709   Toy story (juguetes)
## 2  2        Jumanji 113497                Jumanji
## 3  3 Grumpy Old Men 107050 Dos viejos gru\xf1ones
##                                                                                                     imdbPictureURL
## 1 http://ia.media-imdb.com/images/M/MV5BMTMwNDU0NTY2Nl5BMl5BanBnXkFtZTcwOTUxOTM5Mw@@._V1._SX214_CR0,0,214,314_.jpg
## 2 http://ia.media-imdb.com/images/M/MV5BMzM5NjE1OTMxNV5BMl5BanBnXkFtZTcwNDY2MzEzMQ@@._V1._SY314_CR3,0,214,314_.jpg
## 3     http://ia.media-imdb.com/images/M/MV5BMTI5MTgyMzE0OF5BMl5BanBnXkFtZTYwNzAyNjg5._V1._SX214_CR0,0,214,314_.jpg
##   year            rtID rtAllCriticsRating rtAllCriticsNumReviews
## 1 1995       toy_story                9.0                     73
## 2 1995 1068044-jumanji                5.6                     28
## 3 1993  grumpy_old_men                5.9                     36
##   rtAllCriticsNumFresh rtAllCriticsNumRotten rtAllCriticsScore
## 1                   73                     0               100
## 2                   13                    15                46
## 3                   24                    12                66
##   rtTopCriticsRating rtTopCriticsNumReviews rtTopCriticsNumFresh
## 1                8.5                     17                   17
## 2                5.8                      5                    2
## 3                7.0                      6                    5
##   rtTopCriticsNumRotten rtTopCriticsScore rtAudienceRating
## 1                     0               100              3.7
## 2                     3                40              3.2
## 3                     1                83              3.2
##   rtAudienceNumRatings rtAudienceScore
## 1               102338              81
## 2                44587              61
## 3                10489              66
##                                                   rtPictureURL
## 1 http://content7.flixster.com/movie/10/93/63/10936393_det.jpg
## 2  http://content8.flixster.com/movie/56/79/73/5679734_det.jpg
## 3      http://content6.flixster.com/movie/25/60/256020_det.jpg
```
