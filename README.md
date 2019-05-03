This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown). Please see the page "[Get Started](https://bookdown.org/yihui/bookdown/get-started.html)" at https://bookdown.org/yihui/bookdown/ for how to compile this example into HTML. You may generate a copy of the book in `bookdown::pdf_book` format by calling `bookdown::render_book('index.Rmd', 'bookdown::pdf_book')`. More detailed instructions are available here https://bookdown.org/yihui/bookdown/build-the-book.html.

You can find the preview of this example at https://bookdown.org/yihui/bookdown-demo/.


# Interpreting Regression

0. Preamble
	- Audience
	- Goals / Problems that we're focussing on solving in this book
	- Motivating problems and data

Part 1: Univariate Inference

1. Distributions
	- What is a Distribution?
	- Probabilistic Quantities
		- Mean
		- Mode
		- Median
		- Quantiles
		- Prediction Intervals
		- Variance
	- Parametric Distributions
2. Estimation
	- What is an estimator?
	- The Sampling Distribution
	- The Bootstrap Distribution
	- Measuring Uncertainty; Confidence Intervals
	- Estimator Goodness (choosing one estimator over another; the bias-variance tradeoff)
3. Prediction
	- Prediction as estimation
	- Probabilistic Forecasting
	- Irreducible error
	- Prediction Intervals
	- Proper Scoring Rules
	- E-train vs E-test?
	- Comparing E-train/E-test to bias-variance tradeoff

Part 2: Regression

4. What is Regression?
	- What is Regression?
	- Etymology (Regression towards the mean)
5. Supervised Learning
	- What is it?
	- Reducible error
	- Some techniques; especially local.
6. The Model-Fitting Paradigm in R
	- Fit-Predict
	- `broom`
7. Linear Regression
	- Non-identifiability? Perhaps in the context of turning a K-level categorical variable into K binary variables AND keeping the intercept?
8. ANOVA

Part 3: Regression under special conditions

9. Regression on different numeric scales (GLM and transformations)
10. Regression on ordinal response data (Proportional Odds model)
11. Regression on censored response data (survival analysis)
12. Regression in the presence of outliers (robust regression)
13. Regression when data are not iid (mixed effects)
14. Regression when data are missing; responsible use.
15. Regression when data are recorded over time and/or space
