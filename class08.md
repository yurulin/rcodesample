---
title       : Class08
subtitle    : Text Mining
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
## Class08
  
* [Set up](#set-up)
* [Text processing](#text)
* [LSA](#lsa)
* [LDA](#lda)
* [NMF](#nmf)
* [Text classification](#textclassify)

--- #set-up .modal 

## Install R packages

```r
## this tutorial uses the following packages
```

--- #text .sscode-nowrap .compact
## Text processing

```r
## load libraries
library(tm)
library(lsa)
library(ggplot2)

## prepare a toy example with 9 documents in three topics: big data, global warming, government shutdown
text = c(
  "With all the buzz surrounding big data, the data management practitioner is constantly inundated with information regarding big data technologies.",
  "We create so much data every day that 90 percent of the information in the world today has been created in the last two years alone, according to IBM.",
  "Random algorithms and probabilistic data structures are algorithmically efficient and can provide shockingly good practical results.",
  "Scientists will issue their starkest warning yet about the mounting dangers of global warming.",
  "Scientists are more certain than ever that humans are causing the majority of climate change, a major new report has shown.",
  "There's a consensus among leading scientists that global warming is caused by human activity.",
  "The mood in financial markets was cautious on Monday as the partial shut-down of the American government entered a seventh day and lawmakers appeared to be making little headway in raising the country's debt ceiling.",
  "President Obama must continue to refuse to negotiate policy while the government is shut down. ",
  "The stock market is closing at its lowest level in a month as the U.S. government enters a second week of being partially shut down."
)
```

--- .scode-nowrap .compact
## Text processing
