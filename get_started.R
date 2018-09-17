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
opts_knit$set(unnamed.chunk.label='class02-chunk')
opts_chunk$set(echo = FALSE, message=FALSE, warning=FALSE, dependson=1)

## Step 3: Generate Deck
slidify("index.Rmd")
slidify("class01.Rmd")
slidify("class02.Rmd")
slidify("class03.Rmd")

slidify("class04.Rmd")

slidify("rlab01.Rmd")
slidify("rlab02.Rmd")
slidify("rexp01.Rmd")

## Step 4: Publish Deck
publish(user = "yurulin", repo = "rcodesample", host = 'github')
