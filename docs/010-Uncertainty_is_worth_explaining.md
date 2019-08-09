# An outcome on its own {-}

How can we get a handle on an outcome that seems random? Although the score of a Canucks game, a stock price, or river flow is uncertain, this does not mean that these quantities are futile to predict or describe. This part of the book describes how to do just that, using only observations on a single outcome, by shedding light on concepts of probability and univariate analysis as they apply to data science. 

# Distributions: Uncertainty is worth explaining

Concepts:

- Variable types. Numeric variables vs. categorical. Ordinal as being "in between" numeric and categorical. Discrete as a special case of numeric, sometimes worth distinguishing.
- Distributions as the limiting collection of iid data. 
- Ways to depict a distribution, and the interpretation of each. The concept that one tells you everything about the distribution, so you can in theory derive one form from another. One does not give you more information than another. 
- These distributions might not seem practical, but they certainly are. Even in cases where we are considering many other pieces of information aside from the response, we are still dealing with univariate distributions -- we'll see later that the only difference is that they are no longer marginal distributions (they are _conditional_).
