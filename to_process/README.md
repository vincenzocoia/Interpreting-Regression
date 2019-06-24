Ideas and notes to process before putting into the book.


### Things to include

- Why MVUE is kind of silly.
- Linear regression slope parameter as approximately being the average change in y for a change in x.
- Linear regression interpretation example: Jason's blue-light blocking glasses experiment: lm(sleep_time ~ glasses + person), so that blue light glasses has the same effect on everyone. Key: even if this is not true (i.e., if the glasses have a different effect on everyone), so that a more realistic model is lm(sleep_time ~ glasses * person), this is not useful because it doesn't give us something to test. What we really care about is the *average* effect that the blue light glasses have on people. So, the average of the individual slopes. But this is exactly the model without interaction.

### Ideas

- Perhaps have a section on carrying modelling over to hypothesis testing. For example, a paired t-test as being the same as lm(y ~ category + individual).
- Something on scales: whether differences are meaningful, or ratios.

### Things to look into

- Least median of squares is defined in Siegel, A.F. (1982), Robust Regression Using Repeated Medians. Biometrika, 69, 242- 244. But, in the context of robust regression.

