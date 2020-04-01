# Time Series Summary (csse_covid_19_time_series)

This folder contains time series data in a tidy rather than wide format. Data includes `confirmed`, `deaths` and `recovered` cases of COVID-19. All data are from the JHU CSSE's time series csv files (which JHU CSSE creates from their daily case reports).

### **Variable Names**

The following variables are recorded in this order:

1. Province_State                
2. Country_Region                
6. Latitude            
7. Longitude 
5. Date                   
8. Confirmed 
9. Deaths 
10. Recovered  

New variables will be added **IF and WHEN** JHU CSSE make changes. However, the above variable names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

### **What else is different?**

* `Date` is encoded as date objects and adopts a standard YYYY-MM-DD format.
* Data on `Confirmed`, `Deaths`, and `Recovered` cases are concatenated into a single csv file in a tidy format.  

> Warning: The length of `Recovered` cases is less than `Confirmed` and `Deaths`. Missing values indicate dates where data on recoveries are unavailable. JHU CSSE also warns that there are no reliable data sources reporting recovered cases for many countries. Therefore, please excercise caution when interpreting data on the number of recoveries. 

## Updates from JHU CSSE 

JHU CSSE is working on a new data structure, which may result in further changes to their time series tables. See JHU CSSE for [Upcoming changes in time series tables (3/22)](https://github.com/CSSEGISandData/COVID-19/issues/1250).

### **United States: County-level Data**

As of March 31st, 2020, JHU CSSE provides separate time series data on the United States. Their US-only data set features county-level information; including, the number of confirmed cases, deaths, and population statistics. 

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

New variables will be added **IF and WHEN** JHU CSSE make changes. However, the above variable names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 
