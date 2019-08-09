# The Model-Fitting Paradigm in R

**Caution: in a highly developmental stage! See Section  \@ref(caution).**


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

```r
Wage <- ISLR::Wage
NCI60 <- ISLR::NCI60
baseball <- Lahman::Teams %>% tbl_df %>% 
  select(runs=R, hits=H)
cow <- suppressMessages(read_csv("data/milk_fat.csv"))
esoph <- as_tibble(esoph) %>% 
    mutate(agegp = as.character(agegp))
titanic <- na.omit(titanic::titanic_train)
```

Scratch notes from our in-class activities in Lecture 3. This covers the model-fitting paradigm in R.

Use the `iris` data to demonstrate. Split into training and test data:


```r
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
set.seed(100)
iris <- mutate(
	iris, 
	training = caTools::sample.split(Sepal.Width, SplitRatio=0.8))
#	   training = sample(1:2, replace=TRUE, prob=c(0.8, 0.2), size=nrow(iris)))
iris_train <- filter(iris, training)
iris_test <- filter(iris, !training)
#caret::createDataPartition()
```

Fit a LOESS model:


```r
fit <- loess(Sepal.Width ~ Petal.Width, data=iris_train)
```

Make predictions:


```r
yhat <- predict(fit, newdata=iris_test)
```

Calculate error:


```r
mean((yhat - iris_test$Sepal.Width)^2)
```

```
## [1] 0.08020987
```

## `broom` package


```r
#tidy(fit)
#glance(fit)
broom::augment(fit, newdata = iris_test)
```

```
## # A tibble: 30 x 8
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species training
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>   <lgl>   
##  1          4.9         3            1.4         0.2 setosa  FALSE   
##  2          4.6         3.4          1.4         0.3 setosa  FALSE   
##  3          4.9         3.1          1.5         0.1 setosa  FALSE   
##  4          5.1         3.8          1.5         0.3 setosa  FALSE   
##  5          5.2         3.5          1.5         0.2 setosa  FALSE   
##  6          4.7         3.2          1.6         0.2 setosa  FALSE   
##  7          4.8         3.1          1.6         0.2 setosa  FALSE   
##  8          4.9         3.6          1.4         0.1 setosa  FALSE   
##  9          4.4         3.2          1.3         0.2 setosa  FALSE   
## 10          4.8         3            1.4         0.3 setosa  FALSE   
## # … with 20 more rows, and 2 more variables: .fitted <dbl>, .se.fit <dbl>
```

With linear regression:


```r
fit2 <- lm(Sepal.Width ~ Petal.Width, data=iris_train)
#unclass(fit2)
#unclass(summary(fit2))

broom::tidy(fit2)
```

```
## # A tibble: 2 x 5
##   term        estimate std.error statistic  p.value
##   <chr>          <dbl>     <dbl>     <dbl>    <dbl>
## 1 (Intercept)    3.34     0.0717     46.6  7.64e-78
## 2 Petal.Width   -0.218    0.0500     -4.36 2.78e- 5
```

```r
broom::augment(fit2)
```

```
## # A tibble: 120 x 9
##    Sepal.Width Petal.Width .fitted .se.fit  .resid   .hat .sigma .cooksd
##          <dbl>       <dbl>   <dbl>   <dbl>   <dbl>  <dbl>  <dbl>   <dbl>
##  1         3.5         0.2    3.30  0.0634  0.203  0.0236  0.414 2.98e-3
##  2         3.2         0.2    3.30  0.0634 -0.0973 0.0236  0.415 6.86e-4
##  3         3.1         0.2    3.30  0.0634 -0.197  0.0236  0.414 2.82e-3
##  4         3.6         0.2    3.30  0.0634  0.303  0.0236  0.414 6.64e-3
##  5         3.9         0.4    3.25  0.0557  0.646  0.0182  0.410 2.31e-2
##  6         3.4         0.2    3.30  0.0634  0.103  0.0236  0.415 7.64e-4
##  7         2.9         0.2    3.30  0.0634 -0.397  0.0236  0.413 1.14e-2
##  8         3.7         0.2    3.30  0.0634  0.403  0.0236  0.413 1.18e-2
##  9         3.4         0.2    3.30  0.0634  0.103  0.0236  0.415 7.64e-4
## 10         3           0.1    3.32  0.0675 -0.319  0.0267  0.414 8.42e-3
## # … with 110 more rows, and 1 more variable: .std.resid <dbl>
```

```r
broom::glance(fit2)
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic p.value    df logLik   AIC   BIC
##       <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.139         0.132 0.413      19.0 2.78e-5     2  -63.1  132.  141.
## # … with 2 more variables: deviance <dbl>, df.residual <int>
```

