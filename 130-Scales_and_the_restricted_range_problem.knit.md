# Scales and the restricted range problem

**Caution: in a highly developmental stage! See Section  \@ref(caution).**


link functions and alternative parameter interpretations (categorical data too)

In Regression I, the response was allowed to take on any real number. But what if the range is restricted?


```r
suppressPackageStartupMessages(library(tidyverse))
Wage <- ISLR::Wage
NCI60 <- ISLR::NCI60
baseball <- Lahman::Teams %>% tbl_df %>% 
  select(runs=R, hits=H)
```

```
## Warning: `tbl_df()` was deprecated in dplyr 1.0.0.
## Please use `tibble::as_tibble()` instead.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.
```

```r
cow <- suppressMessages(read_csv("data/milk_fat.csv"))
esoph <- as_tibble(esoph) %>% 
    mutate(agegp = as.character(agegp))
titanic <- na.omit(titanic::titanic_train)
```

## Problems

Here are some common examples.

1. Positive values: river flow. 
    - Lower limit: 0
2. Percent/proportion data: proportion of income spent on housing in Vancouver. 
    - Lower limit: 0
    - Upper limit: 1. 
3. Binary data: success/failure data.
    - Only take values of 0 and 1.
4. Count data: number of male crabs nearby a nesting female
    - Only take count values (0, 1, 2, ...)

Here is an example of the fat content of a cow's milk, which was recorded over time. Data are from the paper ["Transform or Link?"](https://core.ac.uk/download/pdf/79036775.pdf). Let's consider data as of week 10:


```r
(plot_cow <- cow %>% 
    filter(week >= 10) %>% 
    ggplot(aes(week, fat*100)) +
    geom_point() +
    theme_bw() +
    labs(y = "Fat Content (%)") +
    ggtitle("Fat content of cow milk"))
```

<img src="130-Scales_and_the_restricted_range_problem_files/figure-html/unnamed-chunk-2-1.png" width="672" />

Let's try fitting a linear regression model. 


```r
plot_cow +
    geom_smooth(method = "lm", se = FALSE)
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<img src="130-Scales_and_the_restricted_range_problem_files/figure-html/unnamed-chunk-3-1.png" width="672" />

Notice the problem here -- __the regression lines extend beyond the possible range of the response__. This is _mathematically incorrect_, since the expected value cannot extend outside of the range of Y. But what are the _practical_ consequences of this?

In practice, when fitting a linear regression model when the range of the response is restricted, we lose hope for extrapolation, as we obtain logical fallacies if we do. In this example, a cow is expected to produce _negative_ fat content after week 35!

Despite this, a linear regression model might still be useful in these settings. After all, the linear trend looks good for the range of the data. 


## Solutions

How can we fit a regression curve to stay within the bounds of the data, while still retaining the interpretability that we have with a linear model function? Remember, non-parametric methods like random forests or loess will not give us interpretation. Here are some options:

1. Transform the data. 
2. Transform the linear model function: link functions
3. Use a scientifically-backed parametric function.

### Solution 1: Transformations

One solution that _might_ be possible is to transform the response so that its range is no longer restricted. 
The most typical example is for positive data, like river flow. If we log-transform the response, then the new response can be any real number. All we have to do is fit a linear regression model to this transformed data.

One downfall is that we lose interpretability, since we are estimating the mean of $\log(Y)$ (or some other transformation) given the predictors, not $Y$ itself! Transforming the model function by exponentiating will not fix this problem, either, since the exponential of an expectation is not the expectation of an exponential. Though, this is a mathematical technicality, and might still be a decent approximation in practice.

Also, transforming the response might not be fruitful. For example, consider a binary response. No transformation can spread the two values to be non-binary!

### Solution 2: Link Functions

Instead of transforming the data, why not transform the model function? For example, instead of taking the logarithm of the response, perhaps fit the model $$ E(Y|X=x) = \exp(\beta_0 + \beta x) = \alpha \exp(\beta x) $$. Or, in general, $$ g(E(Y|X=x)) = X^T \beta $$ for some increasing function $g$ called the _link function_. 

This has the added advantage that we do not need to be able to transform the response.

Two common examples of link functions:

- $\log$, for positive response values.
    - Parameter interpretation: an increase of one unit in the predictor is associated with an $\exp(\beta)$ times increase in the mean response, where $\beta$ is the slope parameter.
- $\text{logit}(x)=\log(x/(1-x))$, for binary response values.
    - Parameter interpretation: an increase of one unit in the predictor is associated with an $\exp(\beta)$ times increase in the odds of "success", where $\beta$ is the slope parameter, and odds is the ratio of success to failure probabilities.

### Solution 3: Scientifically-backed functions

Sometimes there are theoretically derived formulas for the relationship between response and predictors, which have parameters that carry some meaning to them.

## GLM's in R

This document introduces the `glm()` function in R for fitting a Generlized Linear Model (GLM). We'll work with the `titanic_train` dataset in the `titanic` package.


```r
str(titanic)
```

```
## 'data.frame':	714 obs. of  12 variables:
##  $ PassengerId: int  1 2 3 4 5 7 8 9 10 11 ...
##  $ Survived   : int  0 1 1 1 0 0 0 1 1 1 ...
##  $ Pclass     : int  3 1 3 1 3 1 3 3 2 3 ...
##  $ Name       : chr  "Braund, Mr. Owen Harris" "Cumings, Mrs. John Bradley (Florence Briggs Thayer)" "Heikkinen, Miss. Laina" "Futrelle, Mrs. Jacques Heath (Lily May Peel)" ...
##  $ Sex        : chr  "male" "female" "female" "female" ...
##  $ Age        : num  22 38 26 35 35 54 2 27 14 4 ...
##  $ SibSp      : int  1 1 0 1 0 0 3 0 1 1 ...
##  $ Parch      : int  0 0 0 0 0 0 1 2 0 1 ...
##  $ Ticket     : chr  "A/5 21171" "PC 17599" "STON/O2. 3101282" "113803" ...
##  $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
##  $ Cabin      : chr  "" "C85" "" "C123" ...
##  $ Embarked   : chr  "S" "C" "S" "S" ...
##  - attr(*, "na.action")= 'omit' Named int [1:177] 6 18 20 27 29 30 32 33 37 43 ...
##   ..- attr(*, "names")= chr [1:177] "6" "18" "20" "27" ...
```


Consider the regression of `Survived` on `Age`. Let's take a look at the data with jitter:


```r
ggplot(titanic, aes(Age, Survived)) +
    geom_jitter(height=0.1, alpha=0.25) +
    scale_y_continuous(breaks=0:1, labels=c("Perished", "Survived")) +
    theme_bw()
```

<img src="130-Scales_and_the_restricted_range_problem_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Recall that the linear regression can be done with the `lm` function:


```r
res_lm <- lm(Survived ~ Age, data=titanic)
summary(res_lm)
```

```
## 
## Call:
## lm(formula = Survived ~ Age, data = titanic)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.4811 -0.4158 -0.3662  0.5789  0.7252 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.483753   0.041788  11.576   <2e-16 ***
## Age         -0.002613   0.001264  -2.067   0.0391 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4903 on 712 degrees of freedom
## Multiple R-squared:  0.005963,	Adjusted R-squared:  0.004567 
## F-statistic: 4.271 on 1 and 712 DF,  p-value: 0.03912
```

In this case, the regression line is ``0.4837526`` + ``-0.0026125`` `Age`.

A GLM can be fit in a similar way, using the `glm` function -- we just need to indicate what type of regression we're doing (binomial? poission?) and the link function. We are doing bernoulli (binomial) regression, since the response is binary (0 or 1); lets choose a `probit` link function.


```r
res_glm <- glm(factor(Survived) ~ Age, data=titanic, family=binomial(link="probit"))
```

The `family` argument takes a __function__, indicating the type of regression. See `?family` for the various types of regression allowed by `glm()`. 

Let's see a summary of the GLM regression:


```r
summary(res_glm)
```

```
## 
## Call:
## glm(formula = factor(Survived) ~ Age, family = binomial(link = "probit"), 
##     data = titanic)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.1477  -1.0363  -0.9549   1.3158   1.5929  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)  
## (Intercept) -0.037333   0.107944  -0.346   0.7295  
## Age         -0.006773   0.003294  -2.056   0.0397 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 964.52  on 713  degrees of freedom
## Residual deviance: 960.25  on 712  degrees of freedom
## AIC: 964.25
## 
## Number of Fisher Scoring iterations: 4
```

We can make predictions too, but this is not as straight-forward as in `lm()` -- here are the "predictions" using the `predict()` generic function:


```r
pred <- predict(res_glm)
qplot(titanic$Age, pred) + labs(x="Age", y="Default Predictions")
```

<img src="130-Scales_and_the_restricted_range_problem_files/figure-html/unnamed-chunk-9-1.png" width="672" />

Why the negative predictions? It turns out this is just the linear predictor, ``-0.0373331`` + ``-0.0067733`` `Age`.

The documentation for the `predict()` generic function on `glm` objects can be found by typing `?predict.glm`. Notice that the `predict()` generic function allows you to specify the *type* of predictions to be made. To make predictions on the mean (probability of `Survived=1`), indicate `type="response"`, which is the equivalent of applying the inverse link function to the linear predictor.

Here are those predictions again, this time indicating `type="response"`:


```r
pred <- predict(res_glm, type="response")
qplot(titanic$Age, pred) + labs(x="Age", y="Mean Estimates")
```

<img src="130-Scales_and_the_restricted_range_problem_files/figure-html/unnamed-chunk-10-1.png" width="672" />

Look closely -- these predictions don't actually fall on a straight line. They follow an inverse probit function (i.e., a Gaussian cdf):





