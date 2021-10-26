# Regression when data are ordinal

## Concept list

- A variable is ordinal if its values have a natural ordering.
	- For example, months have an inherent order.
- A proportional odds model is a commonly used model that allows us to interpret how predictors influence an ordinal response. Let's consider lower levels as being "worse".
	- It models an individual's odds of having an outcome "worse than" (less than or equal to) level `k` for all `k` as being some baseline odds, multiplied by `exp(eta)`, where `eta` is a linear combination of the predictors. Sometimes (like in R's `MASS::polr()`) `eta` is a _negative_ linear combination of predictors, so that the multiplicative factor is `exp(-eta)`.
	- The coefficient `beta` on a predictor `X` (contained in `eta`) has the following interpretation (if `eta` is defined as a linear combination of predictors without a negative sign in front): an increase in `X` by one unit is associated with `exp(beta)` times the odds of being worse off. If `eta` is defined with a negative sign, the same interpretation follows with `exp(-beta)` instead of `exp(beta)`.
