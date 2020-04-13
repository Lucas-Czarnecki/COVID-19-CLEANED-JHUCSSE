# Update 04-12-2020

JHU CSSE introduced another significant change to its data format on 04-12-2020. Cleaned daily reports will be suspended for a couple of days to ensure the format is permanent. You can expect some additional variables added soon as well as additional cleaning (e.g., country names, FIPS codes, etc.). 

Time series data will still be updated. 

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
     * All timestamps are in UTC (GMT+0) and adopt a standard M/DD/YYYY HH:MM:SS POSIXct format.
* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. (Preventing programs like R from treating these as missing values). 

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
