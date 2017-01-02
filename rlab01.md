---
title       : R Lab -- Part I
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
## R Lab -- Part I

* [Overview](#overview)
* [Input](#input)
* [Basic Data Types](#basic-data-types)
* [Basic Operations & Numerical Descriptions](#operations)
* [R Programming](#prog)
* [Data Manipulation](#data-manipulation)
* [Example](#example)
* [References](#ref)

--- #intro
## Introduction 

In this R Lab class, I will point you to several wonderful online resources (see [References](#ref)), and ask you to follow the materials to master the basics of R.

**Learning activity**: Follow the mini **Exercise** and **Learning Check** in this tutorial.

--- #overview

## Overview

* Why R?
* What is R?
* What is RStudio?
* [Installation](https://bookdown.org/rdpeng/exdata/getting-started-with-r.html)

--- 
## Why R?

**Exercise**
* Read [Why R](https://ismayc.github.io/rbasics-book/2-whyR.html), [the pros & cons](http://thegrantlab.org/bio3d/79-static-content/85-why-use-r), [Why use the R Language?](http://www.burns-stat.com/documents/tutorials/why-use-the-r-language/)

**Further reading**
* [History and Overview of R](https://bookdown.org/rdpeng/rprogdatascience/history-and-overview-of-r.html)

**Learning check**
* Can you list three pros & cons of R?
* Is R a statistics software or a language?
* How does R facilitate statistical thinking?

--- 
## R & RStudio

**Exercise**
* Go over [R and RStudio Basics](https://ismayc.github.io/rbasics-book/3-rstudiobasics.html), [Getting Started with R](https://bookdown.org/rdpeng/rprogdatascience/getting-started-with-r.html).
* Follow the instruction to install R and RStudio on your computer.

**Learning check**
* Have you installed R and RStudio on your computer?
* Do you know how to set your working directory?

--- #input
## Input

**Exercise**
* Go over [Assignment](http://www.cyclismo.org/tutorial/R/input.html#assignment), [Reading from a file](http://www.cyclismo.org/tutorial/R/input.html#reading-a-csv-file).

**Learning check**
* What does `c()` mean?
* What does `[]` mean in `bubba[2]`?
* How do you get columes and colume names from the file `simple.csv`?

**Further reading**
* [Getting Data In and Out of R](https://bookdown.org/rdpeng/rprogdatascience/getting-data-in-and-out-of-r.html)
* [Use = or <- for assignment?](http://blog.revolutionanalytics.com/2008/12/use-equals-or-arrow-for-assignment.html)

--- #basic-data-types
## Basic Data Types

**Exercise**
* Go over [Basic Data Types](http://www.cyclismo.org/tutorial/R/types.html).

**Learning check**
* How do you get access to particular entries in the vector?
* How do you get the data type for a variable?
* What is `factor`? How do you calculate the frequency that each factor occurs in a table?

**Further reading**
* [R Nuts and Bolts](https://bookdown.org/rdpeng/rprogdatascience/r-nuts-and-bolts.html)

--- #operations
## Basic Operations & Numerical Descriptions

**Exercise**
* Go over [Basic Operations and Numerical Descriptions](http://www.cyclismo.org/tutorial/R/basicOps.html).
* Read [Use = or <- for assignment?](http://blog.revolutionanalytics.com/2008/12/use-equals-or-arrow-for-assignment.html)

**Learning check**
* How do you assign a value to a variable? How do you create vectors?
* What is the difference between `=` and `->`?
* How do you take the square root, find e raised to each number, the logarithm, etc., of a number?
* How do you sort the given vector in either ascending or descending order?

**Further reading**
* [Vectorized Operations](https://bookdown.org/rdpeng/rprogdatascience/vectorized-operations.html)

--- #prog
## R Programming

**Exercise**
* Go over [Introduction to Programming](http://www.cyclismo.org/tutorial/R/scripting.html).

**Learning check**
* How do you executed commands in a file as if you had typed them in from the command line?
* What are different ways to repeat a set of instructions? How do you stop the execution of the current loop?
* How do you define a function and assign default values to the arguments?

**Further reading**
* [Control Structures](https://bookdown.org/rdpeng/rprogdatascience/control-structures.html)

--- #data-manipulation
## Data Manipulation

**Exercise**
* Go over [Data Management](http://www.cyclismo.org/tutorial/R/dataManagement.html).

**Further reading**
* [Subsetting R Objects](https://bookdown.org/rdpeng/rprogdatascience/subsetting-r-objects.html)

**Learning check**
* How do you append rows or columns to a data frame?
* What are the differences among `[]`, `[[]]` and `$`?
* How do you remove missing values?

--- #example
## Example: Using R with periodic table dataset

**Exercise**
* Go over [Intro to R using R Markdown](https://ismayc.github.io/rbasics-book/5-rmdanal.html)

**Learning check**

How do you get the 'block' variable from the periodic table dataset? 

How do you convert 'block' into a `factor` and count the number of elements in each block?

What does the expression `friend_names[-c(2, 4)]` mean?

--- #ref
## References
* [R Tutorial by Kelly Black](http://www.cyclismo.org/tutorial/R/index.html)
* [R Programming for Data Science by Roger D. Peng](https://bookdown.org/rdpeng/rprogdatascience/)
* [Exploratory Data Analysis with R by Roger D. Peng](https://bookdown.org/rdpeng/exdata/)
* [R Basics Book by Chester Ismay](https://ismayc.github.io/rbasics-book/)
* [Why should I use R?](http://thegrantlab.org/bio3d/79-static-content/85-why-use-r)
* [Why use the R Language?](http://www.burns-stat.com/documents/tutorials/why-use-the-r-language/)
