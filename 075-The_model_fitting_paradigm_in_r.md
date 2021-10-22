# The Model-Fitting Paradigm in R

**Caution: in a highly developmental stage! See Section  \@ref(caution).**


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

Scratch notes from our in-class activities in Lecture 3. This covers the model-fitting paradigm in R.

Use the `iris` data to demonstrate. Split into training and test data:

```
head(iris)
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

```
fit <- loess(Sepal.Width ~ Petal.Width, data=iris_train)
```

Make predictions:

```
yhat <- predict(fit, newdata=iris_test)
```

Calculate error:

```
mean((yhat - iris_test$Sepal.Width)^2)
```

## `broom` package

```
#tidy(fit)
#glance(fit)
broom::augment(fit, newdata = iris_test)
```

With linear regression:

```
fit2 <- lm(Sepal.Width ~ Petal.Width, data=iris_train)
#unclass(fit2)
#unclass(summary(fit2))

broom::tidy(fit2)
broom::augment(fit2)
broom::glance(fit2)
```

