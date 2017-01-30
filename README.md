# hospitals

## Summary and Background

This project is a work-in-progress to analyze data on hospital expenses I found [here on data.gov](https://data.cms.gov/Medicare/Inpatient-Prospective-Payment-System-IPPS-Provider/97k6-zzx3). My goal is to see if I can find predictor variables that explain some of the variation in costs for identical procedures at different hospitals.

So far, I have begun by standardizing the costs of each procedure in order to get all of the procedures on a common scale, then taking the mean cost of all procedures at each hospital in order to get a single response variable for covered charges, Medicare payments, and total payments at each hospital. I've also sorted each hospital into the 10 standard federal regions created by the US Office of Management and Budget in case geography may be useful in predicting average costs. The code that does this is in **health.R**. 

I noticed that each hospital in the data set includes its ZIP code. I realized this might be useful for finding more predictor variables that could potentially explain some of the differences in costs. I searched for several zip-code level data sets online, and I found these:

* **[SOI Tax Stats - Individual Income Tax Statistics](https://www.irs.gov/uac/soi-tax-stats-individual-income-tax-statistics-2014-zip-code-data-soi)**: This IRS data set is very detailed at the zip code level. I looked through it and brainstormed about 50 possible features (mostly variables already available in the data set, some that are one variable divided by another, etc.) that could be used to make predictions.

* **[County Business Patterns](https://catalog.data.gov/dataset/county-business-patterns)**: This data set provides the number of business establishments and number of paid employees at those establishments in each zip code. Data from 2014.

* **[FDIC Summary of Deposits](https://catalog.data.gov/dataset/fdic-summary-of-deposits-sod-download-file)**: This data set contains the total amounts of deposits and assets in every FDIC-insured bank by zip code.

* **[OASDI Beneficiaries by State and ZIP Code](https://catalog.data.gov/dataset/oasdi-beneficiaries-by-state-and-zip-code-2014)**: Contains data on beneficiaries of Social Security recipients by zip code.

* **[US Population Density And Unemployment Rate](https://blog.splitwise.com/2014/01/06/free-us-population-density-and-unemployment-rate-by-zip-code/)** Contains Census-derived data on population density and unemployment rates by zip code.

All of the data I'm working with, including a slightly cleaned version of the hospital data set, is available to download [on my website](http://www.latutor.net/wp-content/uploads/2017/01/healthData.zip).

## Challenges and Next Steps

Some potential difficulties I've noticed in dealing with ZIP code-level data include:

* Not all of the data sets contain all ZIP codes, so I'll have to decide what to do about missing values.
* The geographic areas covered by ZIP codes apparently change over time, so I will want my data to be as recent as possible, and older data may not match up with newer data.

However, I've decided it will probably be worthwhile to put a good amount of effort into this zip-code level data, because if I have a data set of 50 to 60 potentially useful predictor variables by zip code, I can potentially use that data for a variety of projects, not just this one. 

## Files

* **health.R:** So far takes a few steps in organizing the health data set into a useful format and does a little feature engineering.
* **mergeZips.R:** The R script I've started working with to collate these various data.
* **processIRS.R:** So far this just contains my brainstorming on possible predictive features I could derive from the IRS data set.
