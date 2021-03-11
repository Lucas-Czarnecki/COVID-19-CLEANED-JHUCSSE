# ---- Cleaned JHU: Daily Update Script ----

# Description: 
# This script is used daily to clean data from the COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University (JHU).

# Terms of Use: 
# All data in this repository are subject to the terms and conditions per JHU CSSE. These terms and conditions are subject to change. Users should familiarize themselves with the terms of use at https://github.com/CSSEGISandData/COVID-19   

# Citations:
# Czarnecki, L. (2020). COVID-19-CLEANED-JHUCSSE: Cleaned COVID-19 Data from JHU CSSE https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE
# Please ensure that you cite the original data set from JHU CSSE at https://github.com/CSSEGISandData/COVID-19

# Packages and Functions ----

# Load required packages (or install if necessary).
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, stringi)

# Load custom functions for this project (See covid_functions.R).
source("~/GitHub/COVID-19-CLEANED-JHUCSSE/R/covid_functions.R")

# Supporting Materials ----

# The following code creates a cleaned copy of JHU's Lookup Table (i.e., UID_ISO_FIPS_LookUp_Table.csv). The table contains geographical codes and population statistics on various regions. The values in this table are later matched with JHU's daily reports and time series data.

# Read JHU's Lookup Table. 
Lookup_Table <- read.csv("~/GitHub/COVID-19/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv")

# NOTE: Tildes (i.e., "~") are shortcuts for a computer's home directory. This script assumes a folder called GitHub exists within one's home directory.

# Treat all blanks as missing values. 
Lookup_Table <- Lookup_Table %>% 
  mutate_all(na_if,"")

# Pad FIPS with leading zeros. `ifelse` is used to pad zeros conditionally. At the state-level, FIPS has a width of 2; at the county-level FIPS has a width of 5.
Lookup_Table$FIPS <- ifelse(is.na(Lookup_Table$Admin2), 
                            formatC(as.numeric(Lookup_Table$FIPS),width=2,format='f',digits=0,flag='0'), 
                            formatC(as.numeric(Lookup_Table$FIPS),width=5,format='f',digits=0,flag='0'))

# Fix how missing values are recorded. 
Lookup_Table$FIPS[Lookup_Table$FIPS == "   NA" | Lookup_Table$FIPS == "NA"] <- NA 

# NOTE: In languages like R you cannot convert a character string to numeric (or a related class) without also removing leading zeros.

# Rename variables to enforce consistent naming scheme. 
Lookup_Table <- Lookup_Table %>%
  rename(Latitude=Lat,
         Longitude=Long_)

# NOTE: JHU has changed column names in the past; the code above is not intended to capture all variants, and may need to be manually updated. Alternative code like `colnames(Lookup_Table)[9] <- "Latitude"` can work, but column order is also subject to change; identifying column names is more reliable than indexing.

# Encode variables as characters for data cleaning operations.  
Lookup_Table$Admin2 <- as.character(Lookup_Table$Admin2)
Lookup_Table$Country_Region <- as.character(Lookup_Table$Country_Region)
Lookup_Table$Province_State <- as.character(Lookup_Table$Province_State)

# Rename values in Lookup Table to enforce a consistent naming scheme (e.g., "United Kingdom" and "United States", rather than "United Kingdom" and "US"); the former also improves data exploration. Changes to the Lookup Table will be mapped onto daily reports and time series in subsequent code.
Lookup_Table$Country_Region[Lookup_Table$Country_Region == "Taiwan*"] <- "Taiwan"
Lookup_Table$Province_State <- clean_jhu_names(dirty_prov_names, clean_prov_names, Lookup_Table$Province_State)
Lookup_Table$Country_Region <- clean_jhu_names(dirty_country_names, clean_country_names, Lookup_Table$Country_Region)
Lookup_Table$Admin2 <- clean_jhu_names(dirty_admin_names, clean_admin_names, Lookup_Table$Admin2)

# Update Combined_Key. Takes into account the changes to country names above (e.g., "United States" rather than "US"), which will also later ensure consistency between the Lookup Table and other data (e.g., Daily Reports). 
Lookup_Table$Combined_Key <- paste(Lookup_Table$Admin2, Lookup_Table$Province_State, Lookup_Table$Country_Region, sep=", ")
Lookup_Table$Combined_Key <- gsub("NA, ", "", Lookup_Table$Combined_Key)

# Geographical locations are treated as factors rather than character strings.
Lookup_Table$Admin2 <- as.factor(Lookup_Table$Admin2)
Lookup_Table$Province_State <- as.factor(Lookup_Table$Province_State)
Lookup_Table$Country_Region <- as.factor(Lookup_Table$Country_Region)
Lookup_Table$Combined_Key <- as.factor(Lookup_Table$Combined_Key)

# Save data. 
save(Lookup_Table, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_cleaned_supporting_material/Cleaned_Lookup.Rdata")
write.csv(Lookup_Table, file = "~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_cleaned_supporting_material/Cleaned_Lookup.csv", row.names = FALSE)

# Global Daily Reports ----

# The following code is used to clean daily reports from JHU CSSE. Cleaned copies of these reports are found in the folder, `csse_covid_19_daily_reports_cleaned`.

# Produce a character vector of file names from JHU's data (in csse_covid_19_daily_reports), then read files into R as a large list. `Custom_read_csv` adds the variable `Date_Published`, which records the date that JHU uploaded each report.
files <- list.files(path="~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports", pattern="*.csv", full.names = TRUE)
CSSE_DailyReports <- lapply(files, custom_read_csv) 

files2021 <- list.files(path="~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports", pattern="*2021.csv", full.names = TRUE)
CSSE_DailyReports2021 <- lapply(files2021, custom_read_csv) 

# Subset more recent reports starting on March 18, 2020. This improves run time by avoiding having to re-clean messy data from before this date. Older reports may need to be cleaned manually if JHU commit retroactive updates. 
CSSE_DailyReports <- CSSE_DailyReports[180:length(CSSE_DailyReports)]  

# Encode new variables as a character for data wrangling. 
CSSE_DailyReports <- lapply(CSSE_DailyReports, function(CSSE_DailyReports) mutate_at(CSSE_DailyReports, .vars = 1, as.character)) 
CSSE_DailyReports <- lapply(CSSE_DailyReports, function(CSSE_DailyReports) mutate_at(CSSE_DailyReports, .vars = 2, as.character))
CSSE_DailyReports2021 <- lapply(CSSE_DailyReports2021, function(CSSE_DailyReports2021) mutate_at(CSSE_DailyReports2021, .vars = 1, as.character)) 
CSSE_DailyReports2021 <- lapply(CSSE_DailyReports2021, function(CSSE_DailyReports2021) mutate_at(CSSE_DailyReports2021, .vars = 2, as.character))
CSSE_DailyReports2021 <- lapply(CSSE_DailyReports2021, function(CSSE_DailyReports2021) mutate_at(CSSE_DailyReports2021, .vars = 14, as.character))
CSSE_DailyReports2021 <- lapply(CSSE_DailyReports2021, function(CSSE_DailyReports2021) mutate_at(CSSE_DailyReports2021, .vars = 15, as.character))

# Concatenate CSV files into a single data frame.
CSSE_DailyReports <- CSSE_DailyReports %>%  
  bind_rows()

CSSE_DailyReports2021 <- CSSE_DailyReports2021 %>%  
  bind_rows()

# Enforce a YYYY-MM-DD HH:MM:SS (24 hour format, in UTC) POSIXct format. Most errors from JHU can be addressed by modifying `format`.
# CSSE_DailyReports$Last_Update <- as.POSIXct(CSSE_DailyReports$Last_Update, format = "%m/%d/%y %H:%M:%S")
CSSE_DailyReports$Last_Update <- as.POSIXct(CSSE_DailyReports$Last_Update, format = "%y-%m-%d %H:%M:%S")

# Rename columns.
CSSE_DailyReports <- CSSE_DailyReports %>% 
  rename(Latitude=Lat,
         Longitude=Long_)

CSSE_DailyReports2021 <- CSSE_DailyReports2021 %>% 
  rename(Latitude=Lat,
         Longitude=Long_)

# Ensure that columns are in a consistent order. Some variables (e.g., `Incidence_rate`, `Case-fatality_Ratio`) are excluded as JHU has inconsistently uploaded them in the past. Users are able to calculate these variables themselves using the data available to them. 
CSSE_DailyReports <- CSSE_DailyReports %>% 
  subset(select=c( "Date_Published", "FIPS", "Admin2", "Province_State", "Country_Region", "Last_Update", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", "Combined_Key"))

CSSE_DailyReports2021 <- CSSE_DailyReports2021 %>% 
  subset(select=c( "Date_Published", "FIPS", "Admin2", "Province_State", "Country_Region", "Last_Update", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", "Combined_Key"))

# Use rbind() to concatenate reports.
CSSE_DailyReports <- rbind(CSSE_DailyReports, CSSE_DailyReports2021)

# Sanity check. The number of cases for any given row cannot be less than 0. Negative values are returned as missing values.
CSSE_DailyReports$Confirmed <-  ifelse(CSSE_DailyReports$Confirmed >= 0, CSSE_DailyReports$Confirmed, NA)
CSSE_DailyReports$Deaths <-  ifelse(CSSE_DailyReports$Deaths >= 0, CSSE_DailyReports$Deaths, NA)
CSSE_DailyReports$Recovered <-  ifelse(CSSE_DailyReports$Recovered >= 0, CSSE_DailyReports$Recovered, NA)

# Sanity check and corrections to `active` cases (human error appears occasionally in JHU's data). The number of cases for any given row cannot be less than 0. Negative values are treated as missing values. 
CSSE_DailyReports$Active <- CSSE_DailyReports$Confirmed - CSSE_DailyReports$Deaths - CSSE_DailyReports$Recovered
CSSE_DailyReports$Active <-  ifelse(CSSE_DailyReports$Active >= 0, CSSE_DailyReports$Active, NA)

# Clean names.
CSSE_DailyReports$Country_Region <- clean_jhu_names(dirty_country_names, clean_country_names, CSSE_DailyReports$Country_Region)
CSSE_DailyReports$Province_State <- clean_jhu_names(us_state_abb, us_state_names, CSSE_DailyReports$Province_State)
CSSE_DailyReports$Province_State <- clean_jhu_names(dirty_prov_names, clean_prov_names, CSSE_DailyReports$Province_State)
CSSE_DailyReports$Admin2 <- clean_jhu_names(dirty_admin_names, clean_admin_names, CSSE_DailyReports$Admin2)
CSSE_DailyReports$Country_Region[CSSE_DailyReports$Country_Region == "Taiwan*"] <- "Taiwan"
# CSSE_DailyReports$Admin2 <- clean_jhu_names(dirty_general_names, clean_general_names, CSSE_DailyReports$Admin2)

# Create a new `Combined_Key` to correct for inconsistencies and match values with the cleaned Lookup Table. 
CSSE_DailyReports$Combined_Key <- paste(CSSE_DailyReports$Admin2, CSSE_DailyReports$Province_State, CSSE_DailyReports$Country_Region, sep=", ")
CSSE_DailyReports$Combined_Key <- gsub("NA, ", "", CSSE_DailyReports$Combined_Key)

# Map data from the cleaned Lookup Table to JHU's daily reports.
CSSE_DailyReports$FIPS <- Lookup_Table$FIPS[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports$Latitude <- Lookup_Table$Latitude[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports$Longitude <- Lookup_Table$Longitude[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]

# Ensure that columns are in a consistent order. Some variables (e.g., `Incidence_rate`, `Case-fatality_Ratio`) are excluded as JHU has inconsistently uploaded them in the past. Users are able to calculate these variables themselves using the data available to them. 
# CSSE_DailyReports <- CSSE_DailyReports %>% 
#   subset(select=c( "Date_Published", "FIPS", "Admin2", "Province_State", "Country_Region", "Last_Update", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", "Combined_Key"))

# Geographical locations are treated as factors rather than character strings. Keeps encoding consistent with Lookup Table.
CSSE_DailyReports$Admin2 <- as.factor(CSSE_DailyReports$Admin2)
CSSE_DailyReports$Province_State <- as.factor(CSSE_DailyReports$Province_State)
CSSE_DailyReports$Country_Region <- as.factor(CSSE_DailyReports$Country_Region)
CSSE_DailyReports$Combined_Key <- as.factor(CSSE_DailyReports$Combined_Key)

# set working directory to `csse_covid_19_daily_reports_cleaned`
setwd("~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_daily_reports_cleaned")

# Revert data into a large list, dividing data into groups defined by `Date_Published`.
daily_dfs_cleaned <- split(CSSE_DailyReports, list(CSSE_DailyReports$Date_Published))

# Write a separate CSV for each date. 
for (Date_Published in names(daily_dfs_cleaned)) {
  write.csv(daily_dfs_cleaned[[Date_Published]], paste0(Date_Published, ".csv"), row.names = FALSE)
}

# Check for Updates based on JHU's Lookup Table. Applies to every daily report in the repository. 

# The line of code below is included for convenience, but is commented out for daily cleaning. This command will remove all unnecessary objects from R's environment from previous section(s). Removing these objects can help reduce **human error** when working on individual sections of this script. Note that `rm(list()=ls()...)` and its variants do not create a fresh R session; it only removes objects from your environment. 
# rm(list=setdiff(ls(), c("Lookup_Table", "clean_admin_names", "clean_country_names", "clean_prov_names", "dirty_admin_names", "dirty_country_names", "dirty_prov_names", "us_state_abb", "us_state_names", "clean_jhu_names", "custom_read_csv")))

# Produce a character vector of file names from cleaned daily reports in this repository (in csse_covid_19_daily_reports_cleaned), then read files into R as a large list. 
files <- list.files(path="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_daily_reports_cleaned", pattern="*.csv", full.names = TRUE)
CSSE_DailyReports <- lapply(files, custom_read_csv) 
CSSE_DailyReports <- lapply(CSSE_DailyReports, function(x) x[,2:ncol(x), drop = FALSE])

# Ensure character encoding. 
CSSE_DailyReports <- lapply(CSSE_DailyReports, function(CSSE_DailyReports) mutate_at(CSSE_DailyReports, .vars = 2, as.character))

# Concatenate .csv files into a single data frame. 
CSSE_DailyReports <- CSSE_DailyReports %>%  
  bind_rows()

# Update daily reports geographic codes with the latest information from JHU's Lookup Table.
CSSE_DailyReports$FIPS <- Lookup_Table$FIPS[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports$Latitude <- Lookup_Table$Latitude[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports$Longitude <- Lookup_Table$Longitude[match(CSSE_DailyReports$Combined_Key, Lookup_Table$Combined_Key)]

# setwd() to csse_covid_19_daily_reports_cleaned.
setwd("~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_daily_reports_cleaned")

# Write .csv files. Split dataframe by Date_Published.
daily_dfs_cleaned <- split(CSSE_DailyReports, list(CSSE_DailyReports$Date_Published))

# Write a separate .csv for each date. 
for (Date_Published in names(daily_dfs_cleaned)) {
  write.csv(daily_dfs_cleaned[[Date_Published]], paste0(Date_Published, ".csv"), row.names = FALSE)
}

# Finally, create/update a master file concatenating every daily report.
CSSE_DailyReports_Master <- CSSE_DailyReports

# Add additional geographic codes.
CSSE_DailyReports_Master$UID <- Lookup_Table$UID[match(CSSE_DailyReports_Master$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports_Master$iso2 <- Lookup_Table$iso2[match(CSSE_DailyReports_Master$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports_Master$iso3 <- Lookup_Table$iso3[match(CSSE_DailyReports_Master$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_DailyReports_Master$code3 <- Lookup_Table$code3[match(CSSE_DailyReports_Master$Combined_Key, Lookup_Table$Combined_Key)]

# Add population statistics from Lookup Table.
CSSE_DailyReports_Master$Population <- Lookup_Table$Population[match(CSSE_DailyReports_Master$Combined_Key, Lookup_Table$Combined_Key)]

# Concatenating data results in duplicate UID values. Add unique ID (i.e., row number) to master file.
CSSE_DailyReports_Master <- tibble::rowid_to_column(CSSE_DailyReports_Master, "ID")

# Arrange variable names to reflect a similar order to other JHU CSSE data.
CSSE_DailyReports_Master <- subset(CSSE_DailyReports_Master, select=c("ID", "Date_Published", "UID", "iso2", "iso3", "code3", "FIPS", "Admin2", "Province_State", "Country_Region", "Last_Update","Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", "Population"))

# Save master as .Rdata file.
save(CSSE_DailyReports_Master, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_DailyReports.Rdata")

# Split csv file. Starting on September 1st, 2020.
# Note: By default, GitHub does not allow users to upload files larger than 100MB. The master file csv is therefore split to ensure ongoing updates.
CSSE_DailyReports_Master2 <- CSSE_DailyReports_Master %>% 
  subset(Date_Published >= "09-01-2020")
CSSE_DailyReports_Master <- CSSE_DailyReports_Master %>% 
  subset(Date_Published < "09-01-2020")

# Save as multiple csv files.
write.csv(CSSE_DailyReports_Master, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_DailyReports.csv", row.names = FALSE)
write.csv(CSSE_DailyReports_Master2, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_DailyReports2.csv", row.names = FALSE)

# ___ end global daily reports  ____

# U.S. Daily Reports ----

# This sections details how to clean U.S. daily reports from JHU. Cleaned U.S. daily reports are found in the `csse_covid_19_daily_reports_us_cleaned` folder. The data are aggregated at the state-level by JHU.

# Commented out, but included for convenience:
# rm(list=setdiff(ls(), c("Lookup_Table", "clean_admin_names", "clean_country_names", "clean_prov_names", "dirty_admin_names", "dirty_country_names", "dirty_prov_names", "us_state_abb", "us_state_names", "clean_jhu_names", "custom_read_csv")))

# `list.files` creates a character vector of file names. Make sure to specify the file path to the folder containing raw U.S. daily reports from JHU.
files <- list.files(path="~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports_us", pattern="*.csv", full.names = TRUE) 

# Create a large list based on file names in the above directory.  
us_dfs <- lapply(files, custom_read_csv) 

# Concatenate reports and encode `Date_Published` as a character. 
US_Daily <- lapply(us_dfs, function(us_dfs) mutate_at(us_dfs, .vars = 1, as.character)) %>%  
  bind_rows()

# Rename column names. 
US_Daily <- US_Daily %>% 
  rename(Latitude=Lat,
         Longitude=Long_)

# Clean `Country_Region` and `Province_State` names.
US_Daily$Country_Region <- clean_jhu_names(dirty_country_names, clean_country_names, US_Daily$Country_Region)
US_Daily$Province_State <- clean_jhu_names(dirty_prov_names, clean_prov_names, US_Daily$Province_State)

# Replace missing values for "Confirmed", "Deaths", "Recovered" with zeros. This approach is consistent with previous JHU reporting practices for daily reports. Note, however, that zeros may indicate that data are not being reported rather than an absence of cases. Many states, for example, do not report on the number of recoveries. Historically, JHU has recorded these as zeros rather than as missing values.
US_Daily[c("Confirmed", "Deaths", "Recovered")][is.na(US_Daily[c("Confirmed", "Deaths", "Recovered")])] <- 0

# Sanity Check. 
US_Daily$Confirmed <-  ifelse(US_Daily$Confirmed >= 0, US_Daily$Confirmed, NA)
US_Daily$Deaths <-  ifelse(US_Daily$Deaths >= 0, US_Daily$Deaths, NA)
US_Daily$Recovered <-  ifelse(US_Daily$Recovered >= 0, US_Daily$Recovered, NA)

# Recalculate `Active` cases and perform a sanity check.
US_Daily$Active <- US_Daily$Confirmed - US_Daily$Deaths - US_Daily$Recovered
US_Daily$Active <- ifelse(US_Daily$Active < 0, NA, US_Daily$Active)

#  Match U.S. data on covid-19 with geographic codes from JHU's Lookup Table.

# Update FIPS codes with those in the Lookup Table. Also fixes JHU's problem with leading zeros. 
US_Daily$FIPS <- Lookup_Table$FIPS[match(US_Daily$UID, Lookup_Table$UID)]

# Add additional geographic codes similar to what is found in JHU CSSE's time series data on the United States. 
US_Daily$iso2 <- Lookup_Table$iso2[match(US_Daily$UID, Lookup_Table$UID)]
US_Daily$code3 <- Lookup_Table$code3[match(US_Daily$UID, Lookup_Table$UID)]

# Add population statistics from the cleaned Lookup Table.
US_Daily$Population <- Lookup_Table$Population[match(US_Daily$UID, Lookup_Table$UID)]

# Rename the `iso3` column for consistency.
US_Daily <- US_Daily %>% 
  rename(iso3=ISO3)

# Rearrange columns for consistency with other JHU CSSE data.
US_Daily <- subset(US_Daily, select=c("Date_Published", "UID", "iso2", "iso3", "code3", "FIPS", "Province_State", "Country_Region", "Last_Update","Latitude", "Longitude",   "Confirmed", "Deaths", "Recovered", "Active", "Incident_Rate", "People_Tested", "People_Hospitalized", "Mortality_Rate", "Testing_Rate", "Hospitalization_Rate", "Population"))

# Remove all countries other than the U.S. (JHU sometimes adds other countries in error).
US_Daily <- US_Daily %>%
  subset(Country_Region == "United States")

# set working directory to csse_covid_19_daily_reports_us_cleaned.
setwd("~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_daily_reports_us_cleaned")

# Write CSV files. Split dataframe by `Date_Published`.
US_Daily_dfs_cleaned <- split(US_Daily, list(US_Daily$Date_Published))

# Write a separate CSV for each report by `Date_Published`. 
for (Date_Published in names(US_Daily_dfs_cleaned)) {
  write.csv(US_Daily_dfs_cleaned[[Date_Published]], paste0(Date_Published, ".csv"), row.names = FALSE)
}

# Save cleaned U.S. daily reports.
save(US_Daily, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_DailyReports_US.Rdata")
write.csv(US_Daily, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_DailyReports_US.csv", row.names = FALSE)

# ___ end u.s. daily reports ___

# Global Time Series ----

# This sections cleans and converts JHU's global time series data from wide to long format. 

# Commented out, but included for convenience:
# rm(list=setdiff(ls(), c("Lookup_Table", "clean_admin_names", "clean_country_names", "clean_prov_names", "dirty_admin_names", "dirty_country_names", "dirty_prov_names", "us_state_abb", "us_state_names", "clean_jhu_names", "custom_read_csv")))

# Read raw data from JHU. Data are contained in csv files in wide format.
Confirmed_wide <- read_csv("~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
Deaths_wide <- read_csv("~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
Recovered_wide <- read_csv("~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

# Encode the subject of the data (i.e., `Country\Region`) as a factor. 
Confirmed_wide$`Country/Region` <- as.factor(Confirmed_wide$`Country/Region`)
Deaths_wide$`Country/Region` <- as.factor(Deaths_wide$`Country/Region`)
Recovered_wide$`Country/Region` <- as.factor(Recovered_wide$`Country/Region`)

# Convert data from wide to long format.
Confirmed_long <- gather(Confirmed_wide, Date, Confirmed, `1/22/20`:length(colnames(Confirmed_wide)), factor_key=TRUE)
Deaths_long <- gather(Deaths_wide, Date, Deaths, `1/22/20`:length(colnames(Deaths_wide)), factor_key=TRUE)
Recovered_long <- gather(Recovered_wide, Date, Recovered, `1/22/20`:length(colnames(Recovered_wide)), factor_key=TRUE)

# Bind the columns from the three data frames into a single data set. 
CSSE_TimeSeries <-  bind_cols(Confirmed_long, Deaths_long[6]) %>% 
  merge(Recovered_long, all.x = TRUE)

# Encode the `Date` column into a vector of date objects.  
CSSE_TimeSeries$Date <- paste0(as.character(CSSE_TimeSeries$Date), "20") %>% 
  as.Date("%m/%d/%y")

# Rename variables according to this repo's naming scheme.
CSSE_TimeSeries <- CSSE_TimeSeries %>% 
  rename(Province_State=`Province/State`,
         Country_Region=`Country/Region`,
         Latitude=Lat,
         Longitude=Long)

# Clean Country and State names.
CSSE_TimeSeries$Country_Region <- clean_jhu_names(dirty_country_names, clean_country_names, CSSE_TimeSeries$Country_Region)
CSSE_TimeSeries$Province_State <- clean_jhu_names(dirty_prov_names, clean_prov_names, CSSE_TimeSeries$Province_State)
CSSE_TimeSeries$Country_Region[CSSE_TimeSeries$Country_Region == "Taiwan*"] <- "Taiwan"

# Sanity Check. Negative values are treated as missing values. 
CSSE_TimeSeries$Confirmed <- ifelse(CSSE_TimeSeries$Confirmed >= 0, CSSE_TimeSeries$Confirmed, NA)
CSSE_TimeSeries$Deaths <- ifelse(CSSE_TimeSeries$Deaths >= 0, CSSE_TimeSeries$Deaths, NA)
CSSE_TimeSeries$Recovered <- ifelse(CSSE_TimeSeries$Recovered >= 0, CSSE_TimeSeries$Recovered, NA)

# Remove Recovered, Canada (rows do not contain any meaningful data).
CSSE_TimeSeries <- CSSE_TimeSeries[!(CSSE_TimeSeries$Province_State == "Recovered" & CSSE_TimeSeries$Country_Region =="Canada"),]

# Create a Combined_Key to compare time series' latitude and longitudinal values with those in the cleaned Lookup Table. 
CSSE_TimeSeries$Combined_Key <- paste(CSSE_TimeSeries$Province_State, CSSE_TimeSeries$Country_Region, sep=", ")
CSSE_TimeSeries$Combined_Key <- gsub("NA, ", "", CSSE_TimeSeries$Combined_Key)

# Ensure latitude and longitude values in time series match those found in the Lookup Table.
CSSE_TimeSeries$Latitude <- Lookup_Table$Latitude[match(CSSE_TimeSeries$Combined_Key, Lookup_Table$Combined_Key)]
CSSE_TimeSeries$Longitude <- Lookup_Table$Longitude[match(CSSE_TimeSeries$Combined_Key, Lookup_Table$Combined_Key)]

# Arrange columns to ensure consistent order. Excludes the `Combined_Key` created above to maintain consistency with JHU's data.
CSSE_TimeSeries <- subset(CSSE_TimeSeries, select=c("Province_State", "Country_Region", "Latitude", "Longitude", "Date", "Confirmed", "Deaths", "Recovered"))

# Save global time series file.
save(CSSE_TimeSeries, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_TimeSeries.Rdata")
write.csv(CSSE_TimeSeries, file= "~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_time_series_cleaned/time_series_covid19_cases_tidy.csv", row.names=FALSE) 

# U.S. Time Series ----

# This sections cleans and converts JHU's U.S. time series data from wide to long format.

# Commented out, but included for convenience:
# rm(list=setdiff(ls(), c("Lookup_Table", "clean_admin_names", "clean_country_names", "clean_prov_names", "dirty_admin_names", "dirty_country_names", "dirty_prov_names", "us_state_abb", "us_state_names", "clean_jhu_names", "custom_read_csv")))

# Read raw U.S. data from JHU. Data are contained in csv files in wide format. 
US_Confirmed_wide <- read_csv("~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
US_Deaths_wide <- read_csv("~/GitHub/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")

# Encode the subject of the data (i.e., `Province_State`) as a factor. 
US_Confirmed_wide$Province_State <- as.factor(US_Confirmed_wide$Province_State)
US_Deaths_wide$Province_State <- as.factor(US_Deaths_wide$Province_State)

# Convert data from wide to long format.
US_Confirmed_long <- gather(US_Confirmed_wide, Date, Confirmed, `1/22/20`:length(colnames(US_Confirmed_wide)), factor_key=TRUE)
US_Deaths_long <- gather(US_Deaths_wide, Date, Deaths, `1/22/20`:length(colnames(US_Deaths_wide)), factor_key=TRUE)

# Bind the columns from the two data frames into a single data set.
CSSE_US_TimeSeries <-  merge(US_Confirmed_long, US_Deaths_long, all.x = TRUE) 

# Rename variables.
CSSE_US_TimeSeries <- CSSE_US_TimeSeries %>% 
  rename(Latitude=Lat,
         Longitude=Long_)

# Encode the `Date` variable into a vector of date objects.
CSSE_US_TimeSeries$Date <- paste0(as.character(CSSE_US_TimeSeries$Date), "20") %>% 
  as.Date("%m/%d/%y")

# Clean names. 
CSSE_US_TimeSeries$Country_Region <- clean_jhu_names(dirty_country_names, clean_country_names, CSSE_US_TimeSeries$Country_Region)
CSSE_US_TimeSeries$Province_State <- clean_jhu_names(dirty_prov_names, clean_prov_names, CSSE_US_TimeSeries$Province_State)
CSSE_US_TimeSeries$Admin2 <- clean_jhu_names(dirty_admin_names, clean_admin_names, CSSE_US_TimeSeries$Admin2)

# Creat a new Combined_Key
CSSE_US_TimeSeries$Combined_Key <- paste(CSSE_US_TimeSeries$Admin2, CSSE_US_TimeSeries$Province_State, CSSE_US_TimeSeries$Country_Region, sep=", ")
CSSE_US_TimeSeries$Combined_Key <- gsub("NA, ", "", CSSE_US_TimeSeries$Combined_Key)

# Fix FIPS codes. 
CSSE_US_TimeSeries$FIPS <- Lookup_Table$FIPS[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]

# Add additional geographic codes similar to what is found in JHU CSSE's daily reports for the United States. 
CSSE_US_TimeSeries$iso2 <- Lookup_Table$iso2[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]
CSSE_US_TimeSeries$code3 <- Lookup_Table$code3[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]

# Add population statistics from Lookup Table.
CSSE_US_TimeSeries$Population <- Lookup_Table$Population[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]

# Ensure that latitude and longitude coordinates in U.S. data match those found in the Lookup Table.
CSSE_US_TimeSeries$Latitude <- Lookup_Table$Latitude[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]
CSSE_US_TimeSeries$Longitude <- Lookup_Table$Longitude[match(CSSE_US_TimeSeries$UID, Lookup_Table$UID)]

# Order variable.
CSSE_US_TimeSeries <- subset(CSSE_US_TimeSeries, select=c("UID", "iso2", "iso3", "code3", "FIPS", "Admin2", "Province_State", "Country_Region", "Latitude", "Longitude", "Combined_Key", "Date","Population", "Confirmed", "Deaths"))

# Sanity Check. Negative values are treated as missing values. 
CSSE_US_TimeSeries$Confirmed <- ifelse(CSSE_US_TimeSeries$Confirmed >= 0, CSSE_US_TimeSeries$Confirmed, NA)
CSSE_US_TimeSeries$Deaths <- ifelse(CSSE_US_TimeSeries$Deaths >= 0, CSSE_US_TimeSeries$Deaths, NA)

# Split U.S data
# Note: By default, GitHub does not allow users to upload files larger than 100MB. As of August 5th the U.S. time series data has, therefore, become too large to push. For this reason the U.S. data is split to ensure ongoing updates. (Git LFS is an alternative approach that I am still considering).

# Save Rdata file.
save(CSSE_US_TimeSeries, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_clean_data/CSSE_US_TimeSeries.Rdata")

# Split data on August 1st, 2020.
CSSE_US_TimeSeries2 <- CSSE_US_TimeSeries %>% 
  subset(Date >= "2020-08-01")
CSSE_US_TimeSeries <- CSSE_US_TimeSeries %>% 
  subset(Date < "2020-08-01")

# Save as multiple csv files.
write.csv(CSSE_US_TimeSeries, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_time_series_cleaned/time_series_covid19_tidy_US.csv", row.names = FALSE)
write.csv(CSSE_US_TimeSeries2, file="~/GitHub/COVID-19-CLEANED-JHUCSSE/COVID-19_CLEAN/csse_covid_19_time_series_cleaned/time_series_covid19_tidy_US2.csv", row.names = FALSE)

# Remove all objects and restart the R session. All data at this point will be saved to subfolders in the root directory. The data are organized according to JHU's scheme.
rm(list=ls())
.rs.restartR()
