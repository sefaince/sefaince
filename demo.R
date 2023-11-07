
# MAIN IDEA OF THİS WORK

# We will use an open-source data from Google Data Analytics Certificate to analyze the differences between casual and member users of an bicycle company users.

install.packages(tidyverse) 
install.packages(devtools)      # The devtools package is for github function to call a package from github and tidyverse is a classic package for plenty of useful functions.


install_github("hzambran/hydroTSM")         # I upload hydroTSM package to use "time2season" function.




library(tidyverse)
library(devtools)
library(hydroTSM)

# I upload all packages.


october <- read.csv("202310-divvy-tripdata.csv")
september <- read.csv("202309-divvy-tripdata.csv")
august <- read.csv("202308-divvy-tripdata.csv")
july <- read.csv("202307-divvy-tripdata.csv")
june <- read.csv("202306-divvy-tripdata.csv")
may <- read.csv("202305-divvy-tripdata.csv")
april <- read.csv("202304-divvy-tripdata.csv")
march <- read.csv("202303-divvy-tripdata.csv")
february <- read.csv("202302-divvy-tripdata.csv")
january <- read.csv("202301-divvy-tripdata.csv")

data <- rbind(january,february,march,april,may,june,july,august,september,october)
View(data)


# I have downloaded each month's data and read them seperately. You can see that I have combined all the data in one data as "data" with rbind function.



clean_data <-na.omit(data)
data <- distinct(clean_data)


# I used na.omit function to clean null values and distinct function to clean duplicates from my dataset.


data$start_hour <- hour(data$started_at)

data$end_hour <- hour(data$ended_at)

data$ride_length <-  difftime(data$ended_at ,data$started_at, units = "mins")

data$ride_length <- as.integer(data$ride_length)

data$started_at <- as.Date(data$started_at)

# I have convert this column to date because the next code doesn't recognize it when it is chr

data$weekday <- weekdays(data$started_at)

data  <- data %>% 
  na.omit(ride_length) %>% 
  filter(ride_length > 0)

data$season <- time2season(data$started_at, out.fmt = "seasons", type = "default" )

data$month <- month(data$started_at, label = TRUE)


# I have created new columns from current dataset to perform my analyze.



View(data)       # I view my new dataset to check if everything is okay.




data %>% 
  ggplot() + geom_bar(aes(x = member_casual, fill = member_casual)) + labs(title = "Total Trips by Customer Type", x = "Type", y = "Count")



summary(data$ride_length)       # I use the summary function to check the outliers for next code chunk



data %>% 
  ggplot() + geom_histogram(aes(x = ride_length), filter(data, data$ride_length < 75)) + facet_wrap(~member_casual) + labs(title = "Ride Length by Customer Type", x = "Ride Length", y = "Count")


data %>% 
  ggplot() + geom_bar(aes(x = start_hour, fill = member_casual)) + facet_wrap(~weekday) + labs(title = "Ride time per day", x = "Hour", y = "Count")

data %>% 
  ggplot() + geom_bar(aes(x = season, fill = member_casual ), position = "dodge") 

data %>% 
  ggplot() + geom_bar(aes(x = month ))

data %>% 
  ggplot() + geom_bar(aes(x = member_casual, fill = member_casual )) + facet_wrap(~rideable_type)





