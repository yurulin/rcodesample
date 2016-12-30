# @see http://slidify.org/start.html

## Step 0: Install Slidify
library(devtools)
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')

## Step 1: Author Deck
author("mydeck-DM-slides")

## Step 2: Edit Deck
# add mystyle.css to mydeck-DM-slides/assets/css

## Step 3: Generate Deck
slidify("index.Rmd")
slidify("class01.Rmd")
slidify("class02.Rmd")

## Step 4: Publish Deck
publish(user = "yurulin", repo = "rcodesample", host = 'github')
