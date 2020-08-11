# Time Series Data (csse_covid_19_time_series)

This folder contains global and U.S. time series data in long rather than wide format. Data includes `confirmed`, `deaths` and `recovered` cases of COVID-19. All data are from the JHU CSSE's time series csv files (which JHU CSSE creates from their daily case reports).

> Note: U.S. time series data are split starting on August 1st, 2020. The data are split to ensure future updates as GitHub does not allow users to upload files larger than 100MB (unless using Git LFS). 
>
> See [United States: County-level Data](#united-states:-county-level-data) below for more information.

## Global Time Series 

The `time_series_covid19_cases_tidy.csv` file concatenates the following data from JHU and presents it in long format: 
* time_series_covid19_confirmed_global.csv
* time_series_covid19_deaths_global.csv
* time_series_covid19_recovered_global.csv

<br>**Variables** are organized as follows:

1. Province_State                
2. Country_Region                
6. Latitude            
7. Longitude 
5. Date                   
8. Confirmed 
9. Deaths 
10. Recovered  

New variables will be added **IF** JHU CSSE make changes. However, the above variable names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

### **What else is different?**

* `Date` is encoded as date objects and adopts a standard YYYY-MM-DD format.

* Data on `Confirmed`, `Deaths`, and `Recovered` cases are concatenated into a single csv file in a tidy format.  

*  Data from JHU's **Lookup Table** are mapped to time series data to ensure consistency in `Latitude` and `Longitude` coordinates. 

> Warning: The length of `Recovered` cases is less than `Confirmed` and `Deaths`. Missing values indicate dates where data on recoveries are unavailable. JHU CSSE also warns that there are no reliable data sources reporting recovered cases for many countries. Therefore, please exercise caution when interpreting data on the number of recoveries. 

## United States: County-level Data

As of March 31st, 2020, JHU CSSE provides separate time series data on the United States. Their US-only data set features county-level information; including, the number of confirmed cases, deaths, and population statistics. 

The `time_series_covid19_tidy_US*.csv` files concatenate the following data from JHU into long format: 
* time_series_covid19_confirmed_US.csv
* time_series_covid19_deaths_US.csv

The following variables are available and are presented in this order:

1. UID
2.	iso2	
3. iso3	
4. code3
5. FIPS	
6. Admin2	
7. Province_State	
8. Country_Region	
9. Latitude	
10. Longitude	
11. Combined_Key	
12. Date	
13. Population	
14. Confirmed	
15. Deaths

New variables will be added **IF** JHU CSSE make changes. However, the above variable names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

### Split CSV Files

Becasue GitHub does not allow users to upload files larger than 100MB without the third party add-on Git LFS, I have decided to split the U.S. time series data starting on August 1st, 2020. Doing so will ensure that these csvs will continue to be updated into the future. (The decision to split rather than use Git LFS was made because users would need to install the latter on their end to pull data). 

You have two options if you want to work with the complete U.S. time series data:

#### Option 1. Pull the data and concatenate the U.S csv files. 
* R makes easy work of this task.

* If you are new to R, check out the `library(readr)` package for importing csv files, and the `rbind()` function for combining rows.


#### Option 2. If you are using R, the [csse_covid_19_clean_data](https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE/tree/master/COVID-19_CLEAN/csse_covid_19_clean_data) folder contains a single .Rdata file that contains all the U.S. time series data.

* Once you have cloned or downloaded this repository you can find the data in **csse_covid_19_clean_data**. The file is called `CSSE_US_TimeSeries.Rdata`.

* Given that .Rdata files take up considerably less space than csv files, I do not expect this file to be split any time soon. 