---
title       : Statistical Analysis for Experimentation
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
## Statistical Analysis for Experimentation

* [Overview](#overview)
* [References](#ref)

--- #what .cc
## What statistical test should I use? 

| Use | Interval/Ratio (Normality assumed) | Interval/Ratio (Normality not assumed), Ordinal  | Dichotomy (Binomial) |
| ------------- |:-------------:|:-----:|:--:|
| Compare two groups (unpaired)      | [t test](#ttest)| Mann-Whitney test | Fisher's test   |
| Compare two groups (paired)      | Paired t test      |   Wilcoxon test | McNemar's test |
| Compare 3+ groups (unmatched) | ANOVA      |    Kruskal-Wallis test | Chi-square test |
| Compare 3+ groups (matched) | Repeated-measures ANOVA      |    Friedman test | Cochran's Q test |

--- #what .cc
## What statistical analysis should I use? 

| Use | Interval/Ratio (Normality assumed) | Interval/Ratio (Normality not assumed), Ordinal  | Dichotomy (Binomial) |
| ------------- |:-------------:|:-----:|:--:|
| Find relationship between two variables      | Pearson correlation | Spearman correlation | Cramer's V  |
| Predict a value with one independent variable      | Linear/Non-linear regression | Non-parametric regression   | 	Logistic regression |
| Predict a value with 2+ independent variable      | Multiple linear/non-linear regression |  | Multiple logistic regression   |

--- #ttest 
## t test 
* How to report?

"With a `Welch's t test`, we found a `significant` effect between settings (`t(15) = 2.20`, `p < 0.05`, `Cohen's d=0.98`) with Setting 2 outperforming Setting 1."

* effect size: Cohen's d, or Pearson's r
* t test with unequal variances (Welch's t test)
* significance & p value
* df & t value
* [details](http://yatani.jp/teaching/doku.php?id=hcistats:ttest)

--- #ref
## References
* [Statistical Methods for HCI Research](http://yatani.jp/teaching/doku.php?id=hcistats:start)
