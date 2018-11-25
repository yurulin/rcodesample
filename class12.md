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
install.packages('sqldf')
```

--- .scode-nowrap .compact #big
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

--- .ssscode-nowrap .compact 
## Big data set

```r
## read row 101--103
df = read.csv(ifilename, sep='\t', nrows=3, skip=101, header=F) ## if we set 'header=T', the first non-skip row will be treated as header (which is incorrect)
df
```

```
##    V1                            V2     V3                      V4
## 1 103                 Unforgettable 118040 Escondido en la memoria
## 2 104                 Happy Gilmore 116483             Terminagolf
## 3 105 The Bridges of Madison County 112579  Los puentes de Madison
##                                                                                                                 V5
## 1 http://ia.media-imdb.com/images/M/MV5BNDM1MDg5MzY4OV5BMl5BanBnXkFtZTcwMDM5NjgyMQ@@._V1._SY314_CR2,0,214,314_.jpg
## 2 http://ia.media-imdb.com/images/M/MV5BMjE1MzgxNjIyN15BMl5BanBnXkFtZTcwMjkzMjYyMQ@@._V1._SY314_CR6,0,214,314_.jpg
## 3 http://ia.media-imdb.com/images/M/MV5BMTQ5NzcyODM1Ml5BMl5BanBnXkFtZTcwODQwMDQyMQ@@._V1._SY314_CR6,0,214,314_.jpg
##     V6                        V7  V8 V9 V10 V11 V12 V13 V14 V15 V16 V17
## 1 1996             unforgettable 4.4 26   6  20  23 0.0   4   0   4   0
## 2 1996             happy_gilmore 5.5 50  29  21  58 5.1  11   4   7  36
## 3 1995 bridges_of_madison_county 7.2 40  36   4  90 7.9   9   9   0 100
##   V18    V19 V20
## 1 3.0    358  36
## 2 3.7 114875  83
## 3 3.6  11573  83
##                                                            V21
## 1 http://content8.flixster.com/movie/11/13/35/11133586_det.jpg
## 2      http://content7.flixster.com/movie/25/96/259613_det.jpg
## 3 http://content6.flixster.com/movie/10/92/73/10927328_det.jpg
```

--- .scode-nowrap .compact 
## Big data set

```r
## count how many lines in the file
# length(readLines(ifilename)) ## not recommended because it reads the file in memory
system(sprintf("wc -l %s",ifilename), intern=T ) 
```

```
## [1] "10198 hetrec2011/movies.dat"
```

```r
## you can use 'wc' command on unix-based machine (linux, mac, etc.)

suppressWarnings(suppressPackageStartupMessages( ## avoid printing warnings
  require(R.utils)
)) ## assumig you have installed R.utils
countLines(ifilename)
```

```
## [1] 10198
## attr(,"lastLineHasNewline")
## [1] TRUE
```

--- .scode .compact 
## Big data set

```r
suppressWarnings(suppressPackageStartupMessages( ## avoid printing warnings
  require(sqldf)
)) ## assumig you have installed sqldf
read.csv.sql(ifilename, "select count(*) from file", sep='\t')
```

```
##   count(*)
## 1    10197
```

--- .scode-nowrap .compact 
## Big data set

```r
sql = 'select id,title,year from file limit 1' ## read 1 row
df = read.csv.sql(ifilename, sql, sep='\t')
df
```

```
##   id     title year
## 1  1 Toy story 1995
```

--- .scode-nowrap .compact 
## Big data set

```r
sql = 'select id,title,year from file limit 10' ## read 10 rows
df = read.csv.sql(ifilename, sql, sep='\t')
df
```

```
##    id                       title year
## 1   1                   Toy story 1995
## 2   2                     Jumanji 1995
## 3   3              Grumpy Old Men 1993
## 4   4           Waiting to Exhale 1995
## 5   5 Father of the Bride Part II 1995
## 6   6                        Heat 1995
## 7   7                     Sabrina 1954
## 8   8                Tom and Huck 1995
## 9   9                Sudden Death 1995
## 10 10                   GoldenEye 1995
```

--- .scode-nowrap .compact 
## Big data set

```r
sql = 'select id,title,year from file limit 5,10' ## skip the first 5 rows, and read the next 10 rows
df = read.csv.sql(ifilename, sql, sep='\t')
df
```

```
##    id                       title year
## 1   6                        Heat 1995
## 2   7                     Sabrina 1954
## 3   8                Tom and Huck 1995
## 4   9                Sudden Death 1995
## 5  10                   GoldenEye 1995
## 6  11      The American President 1995
## 7  12 Dracula: Dead and Loving It 1995
## 8  13                       Balto 1995
## 9  14                       Nixon 1995
## 10 15            Cutthroat Island 1995
```

--- .scode-nowrap .compact 
## Big data set

```r
sql = 'select year,count(*) from file group by year limit 10' ## you can do more if you are familiar with SQL 
df = read.csv.sql(ifilename, sql, sep='\t')
df
```

```
##    year count(*)
## 1  1903        1
## 2  1915        1
## 3  1916        1
## 4  1917        2
## 5  1918        1
## 6  1919        3
## 7  1920        4
## 8  1921        2
## 9  1922        9
## 10 1923        4
```

* if you have mysql database, you can use 'RMySQL' package.
* Other tips (using 'fread'): http://davetang.org/muse/2013/09/03/handling-big-data-in-r/


--- .scode-nowrap .compact 
## Sparse matrix


--- .scode-nowrap .compact 
## Sparse matrix

