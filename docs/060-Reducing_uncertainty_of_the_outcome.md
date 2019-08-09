# Prediction: harnessing the signal {-}


```r
suppressPackageStartupMessages(library(tidyverse))
```

```
## Warning: package 'ggplot2' was built under R version 3.5.2
```

```
## Warning: package 'tibble' was built under R version 3.5.2
```

```
## Warning: package 'purrr' was built under R version 3.5.2
```

```
## Warning: package 'dplyr' was built under R version 3.5.2
```

```
## Warning: package 'stringr' was built under R version 3.5.2
```


# Reducing uncertainty of the outcome: including predictors

**Caution: in a highly developmental stage! See Section  \@ref(caution).**

## Variable terminology

In supervised learning:

- The output is a random variable, typically denoted $Y$. 
- The input(s) variables (which may or may not be random), if there are $p$ of them, are typically denoted $X_1$, ..., $X_p$ -- or just $X$ if there's one. 

There are many names for the input and output variables. Here are some (there are more, undoubtedly):

- __Output__: response, dependent variable. 
- __Input__: predictors, covariates, features, independent variables, explanatory variables, regressors. 

In BAIT 509, we will use the terminology _predictors_ and _response_.

### Variable types

Terminology surrounding variable types can be confusing, so it's worth going over it. Here are some non-technical definitions. 

- A __numeric__ variable is one that has a quantity associated with it, such as age or height. Of these, a numeric variable can be one of two things:
- A __categorical__ variable, as the name suggests, is a variable that can be one of many categories. For example, type of fruit; success or failure.  


## Irreducible Error

The concept of __irreducible error__ is paramount to supervised learning. Next time, we'll look at the concept of _reducible_ error. 

When building a supervised learning model (like linear regression), we can never build a perfect forecaster -- even if we have infinite data!

Let's explore this notion. When we hypothetically have an infinite amount of data to train a model with, what we actually have is the _probability distribution_ of $Y$ given any value of the predictors. The uncertainty in this probability distribution is the __irreducible error__.

__Example__: Let's say $(X,Y)$ follows a (known) bivariate Normal distribution. Then, for any input of $X$, $Y$ has a _distribution_. Here are some examples of this distribution for a few values of the predictor variable (these are called _conditional_ distributions, because they're conditional on observing particular values of the predictors).

<img src="060-Reducing_uncertainty_of_the_outcome_files/figure-html/unnamed-chunk-2-1.png" width="576" />

This means we cannot know what $Y$ will be, no matter what! What's one to do?

- In __regression__ (i.e., when $Y$ is numeric, as above), the go-to standard is to predict the _mean_ as our best guess. 
    - We typically measure error with the __mean squared error__ = average of (observed-predicted)^2. 
- In __classification__, the conditional distributions are categorical variables, so the go-to standard is to predict the _mode_ as our best guess (i.e., the category having the highest probability). 
    - A typical measurement of error is the __error rate__ = proportion of incorrect predictions.
    - A more "complete" picture of error is the __entropy__, or equivalently, the __information measure__. 

In Class Meeting 07, we'll look at different options besides the mean and the mode.

An important concept is that _predictors give us more information about the response_, leading to a more certain distribution. In the above example, let's try to make a prediction when we don't have knowledge of predictors. Here's what the distribution of the response looks like:

<img src="060-Reducing_uncertainty_of_the_outcome_files/figure-html/unnamed-chunk-3-1.png" width="576" />

This is much more uncertain than in the case where we have predictors!

## In-class Exercises: Irreducible Error

**NOT REQUIRED FOR PARTICIPATION**

### Oracle regression

Suppose you have two independent predictors, $X_1, X_2 \sim N(0,1)$, and the conditional distribution of $Y$ is
$$ Y \mid (X_1=x_1, X_2=x_2) \sim N(5-x_1+2x_2, 1). $$
From this, it follows that:

- The conditional distribution of $Y$ given _only_ $X_1$ is
$$ Y \mid X_1=x_1 \sim N(5-x_1, 5). $$
- The conditional distribution of $Y$ given _only_ $X_2$ is
$$ Y \mid X_2=x_2 \sim N(5+2x_2, 2). $$
- The (marginal) distribution of $Y$ (not given any of the predictors) is
$$ Y \sim N(5, 6). $$

The following R function generates data from the joint distribution of $(X_1, X_2, Y)$. It takes a single positive integer as an input, representing the sample size, and returns a `tibble` (a fancy version of a data frame) with columns named `x1`, `x2`, and `y`, corresponding to the random vector $(X_1, X_2, Y)$, with realizations given in the rows. 

```
genreg <- function(n){
    x1 <- rnorm(n)
    x2 <- rnorm(n)
    eps <- rnorm(n)
    y <- 5-x1+2*x2+eps
    tibble(x1=x1, x2=x2, y=y)
}
```


1. Generate data -- as much as you'd like.

```
dat <- genreg(1000)
```


2. For now, ignore the $Y$ values. Use the means from the distributions listed above to predict $Y$ under four circumstances:
    1. Using both the values of $X_1$ and $X_2$.
    2. Using only the values of $X_1$.
    3. Using only the values of $X_2$.
    4. Using neither the values of $X_1$ nor $X_2$. (Your predictions in this case will be the same every time -- what is that number?)
    
```
dat <- mutate(dat,
       yhat = FILL_THIS_IN,
       yhat1 = FILL_THIS_IN,
       yhat2 = FILL_THIS_IN,
       yhat12 = FILL_THIS_IN)
```
    

3. Now use the actual outcomes of $Y$ to calculate the mean squared error (MSE) for each of the four situations. 
    - Try re-running the simulation with a new batch of data. Do your MSE's change much? If so, choose a larger sample so that these numbers are more stable.
    
```
(mse <- mean((dat$FILL_THIS_IN - dat$y)^2))
(mse1 <- mean((dat$FILL_THIS_IN - dat$y)^2))
(mse2 <- mean((dat$FILL_THIS_IN - dat$y)^2))
(mse12 <- mean((dat$FILL_THIS_IN - dat$y)^2))
knitr::kable(tribble(
    ~ Case, ~ MSE,
    "No predictors", mse,
    "Only X1", mse1,
    "Only X2", mse2,
    "Both X1 and X2", mse12
))
```

    
4. Order the situations from "best forecaster" to "worst forecaster". Why do we see this order?


### Oracle classification

Consider a categorical response that can take on one of three categories: _A_, _B_, or _C_. The conditional probabilities are:
$$ P(Y=A \mid X=x) = 0.2, $$
$$ P(Y=B \mid X=x) = 0.8/(1+e^{-x}), $$

To help you visualize this, here is a plot of $P(Y=B \mid X=x)$ vs $x$ (notice that it is bounded above by 0.8, and below by 0).


```r
ggplot(tibble(x=c(-7, 7)), aes(x)) +
    stat_function(fun=function(x) 0.8/(1+exp(-x))) +
    ylim(c(0,1)) +
    geom_hline(yintercept=c(0,0.8), linetype="dashed", alpha=0.5) +
    theme_bw() +
    labs(y="P(Y=B|X=x)")
```

<img src="060-Reducing_uncertainty_of_the_outcome_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Here's an R function to generate data for you, where $X\sim N(0,1)$. As before, it accepts a positive integer as its input, representing the sample size, and returns a tibble with column names `x` and `y` corresponding to the predictor and response. 

```
gencla <- function(n) {
    x <- rnorm(n) 
    pB <- 0.8/(1+exp(-x))
    y <- map_chr(pB, function(t) 
            sample(LETTERS[1:3], size=1, replace=TRUE,
                   prob=c(0.2, t, 1-t-0.2)))
    tibble(x=x, y=y)
}
```


1. Calculate the probabilities of each category when $X=1$. What about when $X=-2$? With this information, what would you classify $Y$ as in both cases?
    - BONUS: Plot these two conditional distributions. 

```
## X=1:
(pB <- FILL_THIS_IN)
(pA <- FILL_THIS_IN)
(pC <- FILL_THIS_IN)
ggplot(tibble(p=c(pA,pB,pC), y=LETTERS[1:3]), aes(y, p)) +
    geom_col() +
    theme_bw() +
    labs(y="Probabilities", title="X=1")
## X=-2
(pB <- FILL_THIS_IN)
(pA <- FILL_THIS_IN)
(pC <- FILL_THIS_IN)
ggplot(tibble(p=c(pA,pB,pC), y=LETTERS[1:3]), aes(y, p)) +
    geom_col() +
    theme_bw() +
    labs("Probabilities", title="X=-2")
```

2. In general, when would you classify $Y$ as _A_? _B_? _C_?

### (BONUS) Random prediction

You might think that, if we know the conditional distribution of $Y$ given some predictors, why not take a random draw from that distribution as our prediction? After all, this would be simulating nature.

The problem is, this prediction doesn't do well. 

Re-do the regression exercise above (feel free to only do Case 1 to prove the point), but this time, instead of using the mean as a prediction, use a random draw from the conditional distributions. Calculate the MSE. How much worse is it? How does this error compare to the original Case 1-4 errors?

### (BONUS) A more non-standard regression

The regression example given above is your perfect, everything-is-linear-and-Normal world. Let's see an example of a joint distribution of $(X,Y)$ that's _not_ Normal. 

The joint distribution in question can be respresented as follows:
$$ Y|X=x \sim \text{Beta}(e^{-x}, 1/x), $$
$$ X \sim \text{Exp}(1). $$

Write a formula that gives a prediction of $Y$ from $X$ (you might have to look up the formula for the mean of a Beta random variable). Generate data, and evaluate the MSE. Plot the data, and the conditional mean as a function of $x$ overtop. 

### (BONUS) Oracle MSE

What statistical quantity does the mean squared error (MSE) reduce to when we know the true distribution of the data? Hint: if each conditional distribution has a certain variance, what then is the MSE?

What is the error rate in the classification setting?
