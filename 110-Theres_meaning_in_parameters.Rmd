# Describing Relationships {-}

# There's meaning in parameters

## The types of parametric assumptions

A model can be _parametric_ (i.e., containing parameters) in roughly two ways:

### 1\. When defining a __model function__.

For example, in linear regression, we assume that the model function is linear. We might also make assumptions about the conditional variance.

This tends to be the meaning of "parametric" in Computer Science.

### 2\. When defining __probability distributions__. 

For example, we might assume that residuals are Gaussian, or perhaps some other distribution.

This tends to be the meaning of "parametric" in Statistics.

## The value of making parametric assumptions

There are arguably two reasons one might bother making a parametric assumption. They are:

1. Reduced error.
2. Interpretability.

### Value \#1: Reduced Error

One value of making parametric assumptions is that we _might_ achieve reduced error. As long as we don't introduce as many parameters as there are observations (or more), here's what generally happens when we make an assumption:

1. __The model variance decreases__. You can think of the reason behind this in two ways:
    - we're adding information to our data set; or
    - we don't need to estimate as many quantities. 
2. __The bias increases the "more incorrect" your assumption is__.
    - This is because we're identifying a framework that is almost surely not true.

Recall that mean squared error has both (squared) bias and model variance as components. The hope is that your model is "correct enough" so that the increase in bias is small in comparison to the decrease in variance, resulting in an overall decrease in error.

Challenge: run a simulation to convince yourself of this -- first in the univariate setting (where bias and variance are more interpretable), then in the regression setting.

For more information on the bias-variance tradeoff, check out Section 2.2.2 of the [ISLR book](http://www-bcf.usc.edu/~gareth/ISL/).

### Value \#2: Interpretation

Sometimes making a parametric assumption does not reduce the overall error by much, even when the assumption is true. This would not be appealing if all you care about is prediction performance. But if you want to gain some insight into relationships between your predictors and response, then introducing a parameter __so that it has meaning__ will help with this task.

For example, assuming the mean response is linear in the predictors gives us meaning behind the slope parameter, as it corresponds to the expected change in response associated with a difference of 1 unit of the corresponding predictor.  

The bonus here is that we don't always need to think of the parameters as being strictly correct. Your assumptions will never hold exactly, so as long as the assumption is not completely unreasonable, the parameters at least give you a sense of what's going on in your data. 



## ANOVA

**Caution: in a highly developmental stage! See Section  \@ref(caution).**

(From 2018-2019 DSCI 561 lab1)

Remember that to make a hypothesis test, we need to first come up with some "distance metric" (called the test statistic) to measure discrepency from the null hypothesis. For example, to test whether two groups have different population means, a t-test bases its distance metric / test statistic on the difference between the two sample means -- the further this metric is from 0, the more evidence we have that the null hypothesis is not true.

There's another way to measure discrepency from the null hypothesis that all group means are equal -- a way that allows for any number of groups to be compared all at once (not just two). But, it operates under the assumption that the variance of the data in each group is the same. Here's the idea. If the population means of each group truly are the same, then we can estimate that common variance in two ways: using the "overall" variance (ignoring the groups altogether), OR by averaging the variances of each group. The distance metric / test statistic is based off of the ratio of these two values (which is more meaningful than looking at the difference between the two).

This is ANOVA -- ANalysis Of VAriance.

For the pregnancy (two-group) dataset, calculate:

1. the overall variance of the response, and store it in var_tot;
2. the average of the variances for each group, and store it in var_grp; and
3. how many times larger is (1) compared to (2)? i.e., calculate (1)/(2). Store it in my_ratio.

Take a moment to reflect as to whether you think this is a big difference or not (no need to write anything).

The actual test statistic of ANOVA has minor adjustments to the ratio you just calculated, although is based on the same concepts.

- Since (1) >= (2), the ratio will always be >1. So instead, the numerator is based on the difference between (1) and (2) (this results in a variance sometimes called the "treatment variance").
- The variance estimates don't always use n-1 -- they adjust for the number of groups, based on the concept of "degrees of freedom".

Still, the larger the ratio (test statistic), the less evidence we have to support the null hypothesis.

Your task: run the ANOVA in R using the aov() function for the pregnancy data. Quality code uses broom::tidy(). Then, store the p-value in preg_aov_p, the test statistic in preg_aov_F, and the "Species" and "Residuals" degrees of freedom (df) as a length-2 vector in the variable preg_aov_df.

If the null hypothesis is true, then the sampling distribution of this test statistic is (to a good approximation) a specific F-distribution. This "good approximation" is thanks to the CLT, and is true as long as the sample size isn't small (and it's always true if the data are Gaussian).
