# Explaining an uncertain outcome: interpretable quantities

**Caution: in a highly developmental stage! See Section  \@ref(caution).**

Concepts:

- Probabilistic quantities and their interpretation
- Prediction as choosing a probabilistic quantity to put forth.
- Irreducible error


## Probabilistic Quantities

- Sometimes confusingly called "parameters".
- Explain the quantities by their interpretation/usefulness, using examples.
	- Mean: what number would you want if you have 10 weeks worth of data, and you want to estimate the total after 52 weeks (one year)?
	- Mode
	- Quantiles:
- Measures of discrepency/"distance" (for prediction):
    - difference
    - ratio
- Measures of spread:
    - Variance
    - IQR
    - Coefficient of Variance (point to its usefulness on a positive ratio scale)
- Information measures

When you want information about an unknown quantity, it's up to you what you decide to use. 

The mean is the most commonly sought when the unknown is numeric. I suspect this is the case for two main reasons:

1. It simplifies computations.
2. It's what's taught in school.


## What is the mean, anyway?

Imagine trying to predict your total expenses for the next two years. You have monthly expenses listed for the past 12 months. What's one simple way of making your prediction? Calculate the average expense from the past 12 months, and multiply that by 24.

In general, a mean (or expected value) can be interpreted as the _long-run average_. However, the mean tends to be interpreted as a _measure of central tendency_, which has a more nebulous interpretation as a "typical" outcome, or an outcome for which most of the data will be "nearest".

## Quantiles

It's common to "default" to using the mean to make decisions. But, the mean is not always appropriate (I wrote a [blog post](https://vincenzocoia.github.io/20180218-mean/) about this):

- Sometimes it makes sense to relate the outcome to a coin toss.
    - For example, find an amount for which next month's expenditures will either exceed or be under with a 50% chance. 
- Sometimes a conservative/liberal estimate is wanted.
    - For example, a bus company wants conservative estimates so that _most_ busses fall within the estimated travel time. 

In these cases, we care about _quantiles_, not the mean. Estimating them is called __quantile regression__ (as opposed to __mean regression__).

Recall what quantiles are: the $\tau$-quantile (for $\tau$ between 0 and 1) is the number that will be exceeded by the outcome with a $(1-\tau)$ chance. In other words, there is a probability of $\tau$ that the outcome will be _below_ the $\tau$-quantile.

$\tau$ is referred to as the _quantile level_, or sometimes the _quantile index_. 

For example, a bus company might want to predict the 0.8-quantile of transit time -- 80% of busses will get to their destination within that time.
