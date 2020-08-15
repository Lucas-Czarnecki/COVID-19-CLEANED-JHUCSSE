# Functions for cleaning JHU CSSE's COVID-19 Data Repository.

# A function for reading csv files (Hat tip to Aaron Left Stack Overflow). Creates a new variable `Date_Published`, which records the date that each daily report was published.
custom_read_csv <- function(x) {
  out <- read_csv(x)
  site <- as.character(stri_extract_all_regex(x, "([[:digit:]]{2}-[[:digit:]]{2}-[[:digit:]]{4})", simplify=TRUE))
  cbind(Date_Published=site, out)
}

# Clean names (Hat tip to Jean-Robert). 
clean_jhu_names <- function(pattern, replacement, x, ...) {
  for(i in 1:length(pattern))
    x <- gsub(pattern[i], replacement[i], x, ...)
  x
}

# Clean Country names. 
dirty_country_names <- c("US", "Mainland China", "Macao SAR", "Hong Kong SAR", "Hong Kong", "Taiwan*", "Taipei and environs", "Korea, South", "Republic of Korea", "Ivory Coast", "UK", "North Ireland", "`Iran (Islamic Republic of)`", "Republic of Ireland", "Vatican City", "Viet Nam", "Russian Federation", "Republic of Moldova", "Palestine", "occupied Palestinian territory", "Czech Republic", "The Gambia", "Gambia, The", "The Bahamas", "Bahamas, The", "Cape Verde", "East Timor", "Macau")
clean_country_names <- c("United States", "China","China", "China", "China",  "Taiwan", "Taiwan", "South Korea", "South Korea", "Cote d'Ivoire", "United Kingdom", "United Kingdom","Iran","Ireland","Holy See","Vietnam", "Russia", "Moldova", "West Bank and Gaza", "West Bank and Gaza", "Czechia", "Gambia","Gambia","Bahamas","Bahamas","Cabo Verde","Timor-Leste", "China")

# Clean U.S. states names.
us_state_abb <- c("AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT",	"VT","VA","WA","WV","WI","WY")
us_state_names <- c( "Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming")

# Clean provincial names.
dirty_prov_names <- c("Toronto, ON", "London, ON", "Montreal, QC", "Calgary, Alberta", "Edmonton, Alberta", "United States Virgin Islands", "Virgin Islands, U.S.", "QC", "ON", "Chicago", "Hong Kong SAR", "Macau SAR")
clean_prov_names <- c("Ontario","Ontario","Quebec","Alberta","Alberta","Virgin Islands","Virgin Islands", "Quebec", "Ontario", "Illinois", "Hong Kong", "Macau")

# Clean Admin2 names.
dirty_admin_names <- c("Yolo County", "Williamson County", "Do<f1>a Ana", "\\<Bristol Bay plus Lake Peninsula\\>")
clean_admin_names <- c("Yolo", "Williamson", "Dona Ana", "Bristol Bay and Lake and Peninsula") 

# General exceptions.
dirty_general_names <- c("Bristol Bay")
clean_general_names <- c("Bristol Bay and Lake and Peninsula")



