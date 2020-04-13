# Update 04-12-2020

JHU CSSE introduced another significant change to its data format on 04-12-2020. Cleaned daily reports will be suspended for a couple of days to ensure the format is permanent. You can expect some additional variables added soon as well as additional cleaning (e.g., country names, FIPS codes, etc.).

Time series data will still be updated.

# Clean JHU CSSE Data (csse_covid_19_clean_data)

This folder contains the latest data from JHU CSSE in .Rdata format. One file, i.e., **CSSE_DailyReports.Rdata**, concatenates their daily reports; `Date_Published` identifies the csv file behind each daily report. The second file, i.e., **CSSE_TimeSeries.Rdata**,  contains the latest time series data. Both files are presented in long rather than wide format. 

Data will be updated to reflect the latest updates from JHU CSSE. 

## Updates (03-31-2020)

### **United States: County-level Data**

As of March 31st, 2020, JHU CSSE provides separate time series data on the United States. Their US-only data set features county-level information; including, the number of confirmed cases, deaths, and population statistics. New variables may be added **IF** JHU CSSE introduce changes.
