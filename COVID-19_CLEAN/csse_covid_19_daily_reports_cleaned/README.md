# Cleaned Daily Reports (csse_covid_19_daily_reports)

This folder contains cleaned daily reports from CSSE JHU. Unlike CSSE JHU's raw csv files, every file in this folder consists of the same variables. These variables adopt a consistent naming scheme and order that will not change (although new variables may be added sequentially). Cleaned daily reports will be added daily to this folder to reflect the latest additions and updates from JHU CSSE. 

**A record of changes is recorded below.**

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
     * All timestamps adopt a YYYY-MM-DD HH:MM:SS (24 hour format, in UTC) POSIXct format.
* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. (Preventing programs like R from treating these as missing values). 

* `Active` cases (i.e., Active = Confirmed - Deaths - Recoveries) are recalculated to correct for errors and to replace missing values in older daily reports. A sanity check also ensures that active cases are equal to or greater than zero; cases where JHU reports negative active cases are reported as missing values.

* A consistent naming scheme is enforced in `Country_Region` and `Province_State` to uniquely identify geographical locations across daily reports and time series data. For example, "Korea, South", and "Republic of Korea" are reduced to "South Korea" across all files. Other values such as "US" are changed to "United States" to improve data exploration and enforce a consistent naming scheme (e.g., "United States" and "United Kingdom" rather than "US" and "United Kingdom").

* Values in `Combined_Key` are recreated each day based on relevent string values. Creating a new `Combined_Key` addresses various inconsistencies across daily reports (e.g., "France" and ",,France") as well as issues that occur as a result of typos (see: [#2603](https://github.com/CSSEGISandData/COVID-19/issues/2603)).

* Fixes inconsistencies found in older daily reports where string values in `Province_State` combined the names of cities/counties with provinces/states (e.g., "Los Angeles, CA" and "Calgary, AB"). Such characters are split into `Admin2` (e.g., "Los Angeles) and `Province_State` (e.g., California). See [#2](https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE/issues/2) for more information. 

* Data from JHU's **Lookup Table** are mapped to daily reports to better ensure consistent naming conventions and data accuracy for `FIPS` geographical codes as well as `Latitude` and `Longitude` coordinates. Mapping these data also updates missing values in older daily reports and ensures consistency across all files. Any changes that JHU makes to their Lookup Table are automatically applied to all files in this repository with each update.

* `FIPS` codes are fixed to address known issues pertaining to JHU truncating leading zeros (e.g., [#2638](https://github.com/CSSEGISandData/COVID-19/issues/2638) and [#2530](https://github.com/CSSEGISandData/COVID-19/issues/2530)). `FIPS` values in this repo are corrected to 2 digits at the state-level and 5 digits at the county-level. 

---
## Record of Changes from JHU CSSE

The following is a log of how JHU CSSE naming conventions for daily reportes has changed over time. 

<ins>Daily reports from January 22nd to February 29th, 2020:</ins>
 1) Province/State 
 2) Country/Region 
 3) Last Updated 
 4) Confirmed 
 5) Deaths 
 6) Recovered 

<ins>Daily reports starting March 1st until March 21st, 2020:</ins> 
 1) Province/State 
 2) Country/Region 
 3) Last Updated 
 4) Confirmed 
 5) Deaths 
 6) Recovered 
 7) Latitude            **(NEW !!!)**
 8) Longitude           **(NEW !!!)**

<ins>Daily Reports starting March 22nd, 2020, to the present:</ins>
 1) FIPS                 **(NEW !!!)**
 2) Admin2               **(NEW !!!)**
 3) Province_State       **(RENAMED !!!)** 
 4) Country_Region       **(RENAMED !!!)**
 5) Last_Updated         **(RENAMED !!!)**
 6) Lat                  **(RENAMED !!!)**
 7) Long_                **(RENAMED !!!)**              
 8) Confirmed 
 9) Deaths 
 10) Recovered 
 11) Active              **(NEW !!!)**
 12) Combined_Key        **(NEW !!!)**

___

<ins>The data in this repository uses the following R-friendly naming conventions for all daily reports:</ins>
1. Date_Published 
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
