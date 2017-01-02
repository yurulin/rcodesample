---
title       : R Lab -- Part II
subtitle    : 
author      : 
job         : 
framework   : shower        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
--- #toc

## R Lab -- Part II

* [Review the Basics](rlab01.html)
* [Plotting](#plot)
* [Errors & Debugging](#debug)
* [Manipulating Data](#dataframe)
* [More about Functions](#functions)
* [References](#ref)

--- #intro
## Introduction 

In this R Lab class, I will point you to several wonderful online resources (see [References](#ref)), and ask you to follow the materials to master the basics of R.

**Learning activity**: Follow the mini **Exercise** and **Learning Check** in this tutorial.

--- #plot
## Plotting
**Exercise**
* Go over [Basic Plots](http://www.cyclismo.org/tutorial/R/plotting.html)
* [Data visualisation](http://r4ds.had.co.nz/data-visualisation.html) (3.1--3.6 in class)

**Learning check**
* How do you see if your data is close to being normally distributed using a normal quantile plot? Are the data in `trees91.csv` normally distributed?
* How do you make a scatterplot of 'hwy' vs 'cyl' from the dataset `mpg` using `ggplot`?
* What's gone wrong with this code? Why are the points not blue?
`ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))`

--- #debug
## Errors & Debugging
**Exercise**
* Go over [Deciphering Common R Errors](https://ismayc.github.io/rbasics-book/6-errors.html), [Debugging](https://bookdown.org/rdpeng/rprogdatascience/debugging.html)

**Learning check**
* What does `traceback()` do?
* How do you initiates an interactive debugger and turn it off?

--- #dataframe
## Manipulating Data
**Exercise**
* Go over [Managing Data Frames with the dplyr package](https://bookdown.org/rdpeng/rprogdatascience/managing-data-frames-with-the-dplyr-package.html)

**Further reading**
* [Manipulating Data](http://www.cookbook-r.com/Manipulating_data/)

--- #functions
## More about Functions
**Exercise**
* [Functions](https://bookdown.org/rdpeng/rprogdatascience/functions.html)

--- #ref
## References
* [R Tutorial by Kelly Black](http://www.cyclismo.org/tutorial/R/index.html)
* [R Programming for Data Science by Roger D. Peng](https://bookdown.org/rdpeng/rprogdatascience/)
* [Exploratory Data Analysis with R by Roger D. Peng](https://bookdown.org/rdpeng/exdata/)
* [R Basics Book by Chester Ismay](https://ismayc.github.io/rbasics-book/)
* [R for Data Science by Garrett Grolemund, Hadley Wickham](http://r4ds.had.co.nz/)
* [Cookbook for R](http://www.cookbook-r.com/)
