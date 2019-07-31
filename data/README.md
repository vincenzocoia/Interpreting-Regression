Milk fat data comes from the paper ["Transform or Link?"](https://core.ac.uk/download/pdf/79036775.pdf).

-----

`EuStockMarkets.csv` contains log returns of four European stock market indices, obtained from the R object `datasets::EuStockMarkets` through the following code:

```
EuStockMarkets %>% 
    as_tibble() %>% 
    mutate_all(.fun = function(x) log(x/lag(x))) %>% 
    drop_na() %>% 
    gather(key = "index", value = "log_return")
```

-----

`house.csv` was obtained from the [housing prices training dataset from Kaggle](https://www.kaggle.com/alphaepsilon/housing-prices-dataset#train.csv).