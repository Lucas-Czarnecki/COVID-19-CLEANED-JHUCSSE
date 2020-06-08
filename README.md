# Cleaned COVID-19 Data from JHU CSSE (R-Friendly)

This repository contains cleaned daily reports and time series data from [the 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository](https://github.com/CSSEGISandData/COVID-19#2019-novel-coronavirus-covid-19-2019-ncov-data-repository-by-johns-hopkins-csse) by Johns Hopkins University for Systems Science and Engineering (JHU CSSE). 

### **Why create a new repository?**
1. To provide a stable version of the JHU CSSE data repository where variable names are not subject to change.
2. To provide an updated data set that maintains consistent naming conventions across all files. 
3. To address various inconsistencies in how data were named and managed; including how dates and time are encoded and how programs may interpret missing values.  
4. To provide time series data in long (tidy) format that will be familiar to most R-users.  

### **How are the data organized?**

The cleaned data are organized within the following folders akin to how JHU CSSE organize their data. 

1. Cleaned Daily Reports (csse_covid_19_daily_reports_cleaned)
2. Cleaned Daily Reports US (csse_covid_19_daily_reports_us_cleaned)
3. Tidy Time-Series Data (csse_covid_19_time_series_cleaned)
4. Cleaned JHU CSSE Data (csse_covid_19_clean_data)
    * This is a new folder. It contains the above daily reports (concatenated) and time series data in a .Rdata format. 
5. Cleaned Supporting Material (csse_cleaned_supporting_material)
    * This is a new folder that contains a cleaned copy of JHU CSSE's Lookup Table (i.e., UID_ISO_FIPS_LookUp_Table.csv) for mapping geographical codes to regions.

---
## 1) Cleaned Daily Reports (csse_covid_19_daily_reports_cleaned)

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

New variables will be added **IF** JHU CSSE make changes. However, the above variables and their names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

> Note: * `Date_Published` is the only variable above that is unique to this repository. It records the date that JHU CSSE publishes each daily report and is used for data wrangling purposes. Note then that the dates recorded in `Date_Published` may differ from those recorded in `Last_Update`. The latter ought to be used for time series analysis. Note also that `Date_Published` for reports - starting April 23, 2020 - are usually one day behind `Last_Update`. This is not an issue with this repo but a result of how JHU schedules its automated updates. See [#2369](https://github.com/CSSEGISandData/COVID-19/issues/2369) for more information.

### **What else is different?**

* `Last_Update` fixes inconsistencies in how dates and times were formatted across csv files. 
     * All timestamps adopt a YYYY-MM-DD HH:MM:SS (24 hour format, in UTC) POSIXct format.
* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. (Preventing programs like R from treating these as missing values). 

* `Active` cases (i.e., Active = Confirmed - Deaths - Recoveries) are recalculated to correct for errors and to replace missing values in older daily reports. A sanity check also ensures that active cases are equal to or greater than zero; cases where JHU reports negative active cases are reported as missing values.

* A consistent naming scheme is enforced in `Country_Region` and `Province_State` to uniquely identify geographical locations across daily reports and time series data. For example, "Korea, South", and "Republic of Korea" are reduced to "South Korea" across all files. Other values such as "US" are changed to "United States" to improve data exploration and enforce a consistent naming scheme (e.g., "United States" and "United Kingdom" rather than "US" and "United Kingdom").

* Values in `Combined_Key` are recreated each day based on relevent string values. Creating a new `Combined_Key` addresses various inconsistencies across daily reports (e.g., "France" and ",,France") as well as issues that occur as a result of typos (see: [#2603](https://github.com/CSSEGISandData/COVID-19/issues/2603)).

* Fixes inconsistencies found in older daily reports where string values in `Province_State` combined the names of cities/counties with provinces/states (e.g., "Los Angeles, CA" and "Calgary, AB"). Such characters are split into `Admin2` (e.g., "Los Angeles) and `Province_State` (e.g., California). See [#2](https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE/issues/2) for more information. 

* Data from JHU's **Lookup Table** are mapped to daily reports to better ensure consistent naming conventions and data accuracy for `FIPS` geographical codes as well as `Latitude` and `Longitude` coordinates. Mapping these data also updates missing values in older daily reports and ensures consistency across all files. Any changes that JHU makes to their Lookup Table are automatically applied to all files in this repository with each update.

* `FIPS` codes are fixed to address known issues pertaining to JHU truncating leading zeros (e.g., [#2638](https://github.com/CSSEGISandData/COVID-19/issues/2638) and [#2530](https://github.com/CSSEGISandData/COVID-19/issues/2530)). `FIPS` values in this repo are corrected to 2 digits at the state-level and 5 digits at the county-level. 

---
## 2) Cleaned USA daily state reports (csse_covid_19_daily_reports_us_cleaned)

This folder contains daily reports from JHU CSSE's **csse_covid_19_daily_reports_us** folder. Daily reports contain **US-only data**, which are aggregated at the state level.  

These are similar to daily reports discussed above, but include more variables. 

The following columns are found in every csv file in this order:

1. Date_Published
2. UID
3. iso2  
4. iso3            
5. code3     
6. FIPS    
7. Province_State
8. Country_Region  
9. Last_Update  
10. Latitude   
11. Longitude   
12. Confirmed          
13. Deaths     
14. Recovered    
15. Active           
16. Incident_Rate
17. People_Tested
18. People_Hospitalized
19. Mortality_Rate
20. Testing_Rate
21. Hospitalization_Rate
22. Population    

See the README in **csse_covid_19_daily_reports_us_cleaned** for more information. 

---
## 3) Tidy Time-Series Summary (csse_covid_19_time_series_cleaned)

This folder contains time-series data in a tidy rather than wide format. Data includes `confirmed`, `deaths` and `recovered` cases of COVID-19. All data are from the JHU CSSE's time series csv files (which JHU CSSE creates from their daily case reports).

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

New variables will be added **IF** JHU CSSE make changes. However, the above variable names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

### **What else is different?**

* `Date` is encoded as date objects and adopts a standard YYYY-MM-DD format.

* Data on `Confirmed`, `Deaths`, and `Recovered` cases are concatenated into a single csv file in a tidy format.  

*  Data from JHU's **Lookup Table** are mapped to time series data to ensure consistency in `Latitude` and `Longitude` coordinates. 

> Warning: The length of `Recovered` cases is less than `Confirmed` and `Deaths`. Missing values indicate dates where data on recoveries are unavailable. JHU CSSE also warns that there are no reliable data sources reporting recovered cases for many countries. Therefore, please exercise caution when interpreting data on the number of recoveries. 

## 4) Clean JHU CSSE Data (csse_covid_19_clean_data)

This folder contains the latest data from JHU CSSE in .Rdata and csv formats. **CSSE_DailyReports**, concatenates JHU's daily reports into a single master file; `Date_Published` identifies the csv file behind each daily report. **CSSE_TimeSeries** contains the latest time series data. Both are presented in long rather than wide format. Data are also cleaned per the descriptions above.   

**Addition features:**

* Geographic codes from JHU's Lookup Table are matched with geographical locations in **CSSE_DailyReports** according to `Combined_Key` to providing additional variables that are not included in JHU daily reports; for example, `UID`, `iso2`, `code3`, etc., where applicable.

* `Population` statistics are also added to **CSSE_DailyReports** based on values reported in JHU's Lookup Table. 

> Note: I will provide notices if changes to files in this folder are planned. But keep in mind that unlike the other folders, these files are more likely to be modified. 

## 5) Cleaned Supporting Material (csse_cleaned_supporting_material)

This folder contains other miscellaneous files that JHU CSSE shares on GitHub. Currently it consists of a cleaned copy of JHU's Lookup Table (i.e., UID_ISO_FIPS_LookUp_Table.csv), which contains geographical codes and population statistics on various regions. 

### **What is different?**

* `FIPS` is encoded as a character variable rather than an integer. Relatedly, a known issue with FIPS codes is fixed such that state-level and county-level FIPS codes are appropriately padded with leading zeros. FIPS codes include an appropriate number of digits for states (e.g., Alabama's FIPS is 01 rather than 1) and counties (e.g., Alabama's Autauga is 01001 rather than 1001).
* Some country names have been modified in `Country_Region` to ensure a more consistent naming scheme across data; specifically, 
    * "US" becomes "United States".
    * "Korea, South" becomes "South Korea".
    * "Taiwan*" becomes "Taiwan".
* Blank cells are treated as missing values. 

> Warning: When opening the **Lookup_Table.csv** keep in mind that programs such as Microsoft Excel and LibreOffice Calc will, by default, truncate leading zeros. Keep this tidbit in mind when opening the file in these programs or consider using a text editor such as Notepad++. 

---
## Credits

A huge thanks to everyone at Johns Hopkins University Center for Systems Science and Engineering (JHU CSSE) who are involved in collecting and maintaining the 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository. 

Data can be found at the [JHU CSSE's Data Repository](https://github.com/CSSEGISandData/COVID-19).

## Disclaimer 

I'm just one guy. If you use these data I make no warranties regarding the accuracy of this information and disclaim any liability for damages resulting from using this repository. JHU CSSE's [**Terms of Use**](https://github.com/CSSEGISandData/COVID-19) apply. 
