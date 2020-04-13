# Cleaned COVID-19 Data from JHU CSSE (R-Friendly)

This repository contains cleaned daily reports and time series data from [the 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository](https://github.com/CSSEGISandData/COVID-19#2019-novel-coronavirus-covid-19-2019-ncov-data-repository-by-johns-hopkins-csse) by Johns Hopkins University for Systems Science and Engineering (JHU CSSE). 

### **Why create a new repository?**
1. To provide a stable version of the JHU CSSE data repository where variable names are not subject to change.
2. To provide an updated data set that maintains consistent naming conventions across all files. 
3. To address various inconsistencies in how data were named and managed; including how dates and time are encoded and how programs may interpret missing values.  
4. To provide time series data in long (tidy) format that will be familiar to most R-users.  

### **How are the data organized?**

The cleaned data are organized within the following folders akin to how JHU CSSE organize their data. 

1. Cleaned Daily Reports (csse_covid_19_daily_reports)
2. Cleaned Time Series Data (csse_covid_19_time_series)
3. Cleaned JHU CSSE Data (csse_covid_19_clean_data)
    * This is a new folder. It contains the above daily reports (concatenated) and time series data in a .Rdata format. 

---
## 1) Cleaned Daily Reports (csse_covid_19_daily_reports)

This folder contains cleaned daily reports from CSSE JHU. Unlike CSSE JHU's raw csv files, every file in this folder consists of the same variables. These variables adopt a consistent naming scheme and order that will not change (although new variables may be added sequentially). Cleaned daily reports will be added daily to this folder to reflect the latest additions and updates from JHU CSSE. 

### **Variable Names**

The following columns are found in every csv file in this order:

1. Date_Published *
2. FIPS                
2. Admin2             
3. Province_State      
4. Country_Region      
5. Last_Updated         
6. Latitude            
7. Longitude                    
8. Confirmed 
9. Deaths 
10. Recovered 
11. Active            
12. Combined_Key   

New variables will be added **IF and WHEN** JHU CSSE make changes. However, the above variables and their names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

> Note: * `Date_Published` is the only variable above that is unique to this repository. It is used for data wrangling; to keep track of daily reports. Note then that the dates record in `Date_Published` may differ from those recorded in `Last_Update`. The latter ought to be used for time series analysis. 

### **What else is different?**

* `Last_Update` fixes inconsistencies in how dates and times were formatted across csv files. 
     * All timestamps are in UTC (GMT+0) and adopt a standard M/DD/YYYY HH:MM:SS POSIXct format.
* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. (Preventing programs like R from treating these as missing values). 

---
## 2) Time Series Summary (csse_covid_19_time_series)

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

## 3) Clean JHU CSSE Data (csse_covid_19_clean_data)

This folder contains the latest data from JHU CSSE in .Rdata format. One file, i.e., **CSSE_DailyReports.Rdata**, concatenates their daily reports; `Date_Published` identifies the csv file behind each daily report. The second file, i.e., **CSSE_TimeSeries.Rdata**,  contains the latest time series data. Both files are presented in long rather than wide format. Data are also cleaned per the descriptions above.   

---
## Credits

A huge thanks to everyone at Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) who are involved in collecting and maintaining the 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository. 

Data can be found at the [JHU CSSE's Data Repository](https://github.com/CSSEGISandData/COVID-19).

## Disclaimer 

I'm just one guy. If you use these data I make no warranties regarding the accuracy of this information and disclaim any liability for damages resulting from using this repository. JHU CSSE's [**Terms of Use**](https://github.com/CSSEGISandData/COVID-19) apply. 
