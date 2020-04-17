# Cleaned Supporting Material (csse_cleaned_supporting_material)

This folder contains other miscellaneous files that JHU CSSE shares on GitHub. Currently it consists of a cleaned copy of JHU's Lookup Table (i.e., UID_ISO_FIPS_LookUp_Table.csv), which contains geographical codes and population statistics on various regions. 

## **What is different?**

* `FIPS` is encoded as a character variable rather than an integer. Relatedly, a known issue with FIPS codes is fixed such that state-level and county-level FIPS codes are appropriately padded with leading zeros. FIPS codes include an appropriate number of digits for states (e.g., Alabama's FIPS is 01 rather than 1) and counties (e.g., Alabama's Autauga is 01001 rather than 1001).
* Some country names have been modified in `Country_Region` to ensure a more consistent naming scheme across data; specifically, 
    * "US" becomes "United States".
    * "Korea, South" becomes "South Korea".
    * "Taiwan*" becomes "Taiwan".
* Blank cells are treated as missing values. 

> Warning: When opening the **Lookup_Table.csv** keep in mind that programs such as Microsoft Excel and LibreOffice Calc will, by default, truncate leading zeros. Keep this tidbit in mind when opening the file in these programs or consider using a text editor such as Notepad++. 