# Clean JHU CSSE Data (csse_covid_19_clean_data)

This folder contains the latest data from JHU CSSE in .Rdata and csv formats. **CSSE_DailyReports**, concatenates JHU's daily reports into a single .Rdata master file as well as across csv files. Both .csv and .Rdata files contain the same data. The `Date_Published` column identifies the file behind each daily report. 

**CSSE_TimeSeries** contains the latest time series data, which are presented in long rather than wide format. 

Data in this folder are cleaned per the same operations as those documented for daily reports and time series in this repository.

**Addition features:**

* Geographic codes from JHU's Lookup Table are matched with geographical locations in **CSSE_DailyReports** according to `Combined_Key` to providing additional variables that are not included in JHU daily reports; for example, `UID`, `iso2`, `code3`, etc., where applicable.

* `Population` statistics are also added to **CSSE_DailyReports** based on values reported in JHU's Lookup Table. 

* `ID` is added to **CSSE_DailyReports** to supplement JHU's `UID`. Note that because the data are concatenated `UID` **does not** provide a "Unique Identifier for each row entry" for data in this folder. The values in `UID` are not changed in the interest of preserving consistency with JHU's original data. 

> **Note: I will provide notices if changes to files in this folder are planned. But keep in mind that unlike the other folders, these files are more likely to be modified.**

Data will be updated to reflect the latest updates from JHU CSSE. 

## Split CSV Files

Because GitHub does not allow users to upload files larger than 100MB without the third party add-on Git LFS, I have decided to split csv files that become too large to update. Doing so will ensure that these csvs will continue to be updated into the future. (The decision to split rather than use Git LFS was made because users would need to install the latter on their end to pull data).

You have two options if you want to work with the complete global data:

Option 1. Pull the data and concatenate the relevant csv files.
* R makes easy work of this task.
* If you are new to R, check out the `library(readr)` package for importing csv files, and the `rbind()` function for combining rows.

Option 2. If you are an R-user, consider working with the file **CSSE_DailyReports.Rdata**, which contains the same data as the csv files.
* Given that .Rdata files take up considerably less space than csv files, I do not expect this file to be split any time soon.
