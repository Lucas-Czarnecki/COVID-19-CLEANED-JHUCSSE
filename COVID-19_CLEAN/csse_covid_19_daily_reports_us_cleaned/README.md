# USA daily state reports (csse_covid_19_daily_reports_us_cleaned)

This folder contains daily reports from JHU CSSE's **csse_covid_19_daily_reports_us** folder. Daily reports contain US-only data, which are aggregated at the state level.  

### File naming convention
MM-DD-YYYY.csv in UTC.

### **Variable Names**

The following columns are found in every csv file in this order (the order and number of variables differs from JHU):

1. Date_Published*
2. UID
3. iso2 **   
4. iso3            
5. code3  **      
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
22. Population **    

New variables will be added **IF and WHEN** JHU CSSE make changes. However, the above variables and their names will not change. If JHU CSSE introduce new variables, these will be added *sequentially* to the variables above. 

> Note: * `Date_Published` is the only variable above that is unique to this repository. It is used for data wrangling; to keep track of daily reports. Note then that the dates record in `Date_Published` may differ from those recorded in `Last_Update`. The latter ought to be used for time series analysis. 

>Note 2: ** Variables `iso2`, `code3` and `population` are not found in the raw data but are added. These variables exist in JHU's Lookup table and were matched to rows based on `UID`.

## What else is different?

* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. This decision is consistent with JHU, as they treat blank cells as zeros when calculating `Active` cases. (Replacing blank cells with zeros prevents programs like R from treating these as missing values). 
* All other blank cells are treated as missing variables. 
* A sanity check ensures that there are no negative `Active` cases; negative  cases are returned as missing values.
* In `Country_Region`, "US" is renamed "United States" to enforce a consistent naming scheme for this repository and to improve data exploration. 
* Columns are reordered to provide consistency with other JHU data such as US time-series data.
* `FIPS` codes are matched with a [cleaned version](https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE/tree/master/COVID-19_CLEAN/csse_cleaned_supporting_material) of JHU's Lookup table to address a [known issue](https://github.com/CSSEGISandData/COVID-19/issues/1791) regarding JHU truncating leading zeros. More sepcifically, `FIPS` is encoded as a character variable rather than an integer. FIPS codes are fixed such that state-level and county-level FIPS codes are appropriately padded with leading zeros. FIPS codes include an appropriate number of digits for states (e.g., Alabama's FIPS is 01 rather than 1) and counties (e.g., Alabama's Autauga is 01001 rather than 1001).

> Warning: When opening these csvs, keep in mind that programs such as Microsoft Excel and LibreOffice Calc will, by default, truncate leading zeros. Keep this tidbit in mind when opening daily reports or consider using a text editor such as Notepad++. Using programs such as R also avoids this issue. 

---
Below are JHU's descriptions for some of the variables in these daily reports.

**Field description:**
* <b>Province_State</b> - The name of the State within the USA.
* <b>Country_Region</b> - The name of the Country (US).
* <b>Last_Update</b> - The most recent date the file was pushed.
* <b>Latitude</b> - Latitude.
* <b>Longitude</b> - Longitude.
* <b>Confirmed</b> - Aggregated confirmed case count for the state.
* <b>Deaths</b> - Aggregated Death case count for the state.
* <b>Recovered</b> - Aggregated Recovered case count for the state.
* <b>Active</b> - Aggregated confirmed cases that have not been resolved (Active = Confirmed - Recovered - Deaths).
* <b>FIPS</b> - Federal Information Processing Standards code that uniquely identifies counties within the USA.
* <b>Incident_Rate</b> - confirmed cases per 100,000 persons.
* <b>People_Tested</b> - Total number of people who have been tested.
* <b>People_Hospitalized</b> - Total number of people hospitalized.
* <b>Mortality_Rate</b> - Number recorded deaths / Number confirmed cases.
* <b>UID</b> - Unique Identifier for each row entry. 
* <b>iso3</b> - Officialy assigned country code identifiers.
* <b>Testing_Rate</b> - Total number of people tested per 100,000 persons.
* <b>Hospitalization_Rate</b> - Total number of people hospitalized / Number of confirmed cases.


---
### Data sources
The original data from JHU can be found [HERE](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports_us).