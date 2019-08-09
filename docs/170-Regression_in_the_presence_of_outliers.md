# Regression in the presence of outliers: robust regression

**Caution: in a highly developmental stage! See Section  \@ref(caution).**

## Robust Regression in R

DSCI 562 Lab 4 Tutorial

There are many R packages out there to assist with robust estimation. It depends on the task at hand. We'll go over a few.

For robust linear regression, there are a few options. 

There's the `rlm` function in the `MASS` package. It works in a similar way as the `lm` function. Can also use the functions `predict`, `residuals`, `coefficients`, etc. on the output. I like this option because it allows for different psi functions besides the Huber.


```r
library(MASS)
(fit6 <- rlm(mpg ~ disp + wt, data=mtcars))
```

```
## Call:
## rlm(formula = mpg ~ disp + wt, data = mtcars)
## Converged in 7 iterations
## 
## Coefficients:
## (Intercept)        disp          wt 
## 34.60475194 -0.01640037 -3.39317550 
## 
## Degrees of freedom: 32 total; 29 residual
## Scale estimate: 3.15
```

```r
(fit7 <- rlm(mpg ~ disp + wt, data=mtcars, psi=psi.bisquare))
```

```
## Call:
## rlm(formula = mpg ~ disp + wt, data = mtcars, psi = psi.bisquare)
## Converged in 7 iterations
## 
## Coefficients:
## (Intercept)        disp          wt 
## 34.64727079 -0.01692585 -3.36447640 
## 
## Degrees of freedom: 32 total; 29 residual
## Scale estimate: 3.22
```

The package `robustbase` has the function `lmrob` for linear models, but also has `glmrob` for GLM's. Similarly, the `robust` package has similar functions `lmRob` and `glmRob`. 

A robust version of GAM's can be obtained with the `robustgam` function in the `robustgam` package. 

A robust version of LME's can be obtained with the `rlmer` function in the `robustlmm` package. 

### Heavy Tailed Regression

For a heavy tailed extension of `lm`, one can use the `tlm` function in the `hett` package. The package `heavy` has some regression techniques using heavy tailed distributions. 
