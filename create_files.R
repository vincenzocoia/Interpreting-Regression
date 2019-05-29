library(stringr)
files <- c("Uncertainty is worth explaining: distributions",
"Explaining an uncertain outcome: interpretable quantities",
"Data versions of interpretable quantities",
"Another layer of uncertainty added from estimation: sampling distributions",
"Improving estimator quality by parametric distributional assumption (and estimation via MLE)",
"Reducing uncertainty of the outcome: including predictors",
"The signal: model functions",
"Estimating parametric model functions",
"Estimating assumption-free: the world of supervised learning techniques",
"The problem with adding too many parameters (terms in the model function; number of features; roughness of the model function)",
"There's meaning in parameters",
"The meaning of interaction: interaction terms, and when relationships change given a variable.",
"Scales and the restricted range problem: link functions and alternative parameter interpretations (categorical data too)",
"Improving estimation through distributional assumptions",
"When we only want interpretation on some predictors",
"Regression when data are censored: survival analysis",
"Regression in the presence of outliers: robust regression",
"Regression in the presence of extremes: extreme value regression",
"Regression when data are ordinal",
"Regression when data are missing: multiple imputation",
"Regression under many groups: mixed effects models")
dirs <- files %>%
    str_extract("^[a-zA-Z0-9 ]*") %>%
    str_c(str_pad(1:length(.), width=2, pad=0), "0-", .) %>%
    str_c(".Rmd") %>%
    str_replace_all(" ", "_") #%>%
    file.create()
purrr::map2(files, dirs, ~ cat(.x, .y))
