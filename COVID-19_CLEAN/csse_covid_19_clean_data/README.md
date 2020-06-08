# Clean JHU CSSE Data (csse_covid_19_clean_data)

This folder contains the latest data from JHU CSSE in .Rdata and csv formats. **CSSE_DailyReports**, concatenates JHU's daily reports into a single master file; `Date_Published` identifies the csv file behind each daily report. **CSSE_TimeSeries** contains the latest time series data. Both are presented in long rather than wide format. 

Data in this folder are cleaned per the same operations as those documented for daily reports and time series in this repository.

**Addition features:**

* Geographic codes from JHU's Lookup Table are matched with geographical locations in **CSSE_DailyReports** according to `Combined_Key` to providing additional variables that are not included in JHU daily reports; for example, `UID`, `iso2`, `code3`, etc., where applicable.

* `Population` statistics are also added to **CSSE_DailyReports** based on values reported in JHU's Lookup Table. 

> Note: I will provide notices if changes to files in this folder are planned. But keep in mind that unlike the other folders, these files are more likely to be modified. 

Data will be updated to reflect the latest updates from JHU CSSE. 

## Updates (03-31-2020)

### **United States: County-level Data**

As of March 31st, 2020, JHU CSSE provides separate time series data on the United States. Their US-only data set features county-level information; including, the number of confirmed cases, deaths, and population statistics. New variables may be added **IF** JHU CSSE introduce changes.
