# @see http://slidify.org/start.html

## Step 0: Install Slidify
library(devtools)
install_github('slidify', 'ramnathv')
install_github('slidifyLibraries', 'ramnathv')

## Step 3: Generate Deck
slidify("index.Rmd")
slidify("class01.Rmd")

## Step 4: Publish Deck
publish(user = "yurulin", repo = "rcodesample", host = 'github')