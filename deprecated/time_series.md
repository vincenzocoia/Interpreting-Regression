### Time Series Ideas

- Three main things we'll look at:
    - Capture the information that *when* has to say about the response.
    - Capture the information that *past values* have to say about the response.
    - Capture the information that *predictors* have to say about the response.
- Complications/Extras:
    - Unequal spacing — resort to spatial techniques.
    - Compounded seasonality. For instance, if data are collected hourly, there's a pattern across day, too!
    - stl decomposition in Python: [http://www.statsmodels.org/dev/generated/statsmodels.tsa.seasonal.seasonal_decompose.html](http://www.statsmodels.org/dev/generated/statsmodels.tsa.seasonal.seasonal_decompose.html)
    - Spectral decomposition / fourier (number of fourier harmonics?) `forecast::fourier()` function in R.
        - Fairly useful resource: [https://ms.mcmaster.ca/~bolker/eeid/2010/Ecology/Spectral.pdf](https://ms.mcmaster.ca/~bolker/eeid/2010/Ecology/Spectral.pdf)
        - This resource indicates the connection with correlation to a sin wave: [https://faculty.washington.edu/dbp/PDFFILES/GHS-AP-Stat-talk.pdf](https://faculty.washington.edu/dbp/PDFFILES/GHS-AP-Stat-talk.pdf)
