# @see http://slidify.org/start.html

## Step 0: Install Slidify
library(devtools)
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')

## Step 1: Author Deck
author("mydeck-DM-slides")

## Step 2: Edit Deck
# add mystyle.css to mydeck-DM-slides/assets/css
library(slidify)
library(knitr)
opts_knit$set(unnamed.chunk.label='class12-chunk')
opts_chunk$set(echo=TRUE, message=FALSE, warning=FALSE, fig.width=6, fig.height=5)

## Step 3: Generate Deck
slidify("index.Rmd")
slidify("class01.Rmd")
slidify("class02.Rmd")
slidify("class03.Rmd")
slidify("class04.Rmd")
slidify("class05.Rmd")
slidify("hw3-sample.Rmd")
slidify("class06.Rmd")
slidify("class07.Rmd")
slidify("class08.Rmd")
slidify("class10.Rmd")
slidify("class11.Rmd")
slidify("class12.Rmd")

slidify("rlab01.Rmd")
slidify("rlab02.Rmd")
slidify("rexp01.Rmd")

## Step 4: Publish Deck
publish(user = "yurulin", repo = "rcodesample", host = 'github')
