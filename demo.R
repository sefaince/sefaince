install.packages(tidyverse) 
install.packages(devtools)
# The devtools package is for github function to call a package from github.

install_github("hzambran/hydroTSM")

# I downloaded hydroTSM package to use "time2season" function.

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


clean_data <-na.omit(data)


data <- distinct(clean_data)

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

View(data)

data %>% 
  ggplot() + geom_bar(aes(x = member_casual, fill = member_casual)) 



summary(data$ride_length)

#I use the summary function to check the outliers

data %>% 
  ggplot() + geom_histogram(aes(x = ride_length), filter(data, data$ride_length < 75)) + facet_wrap(~member_casual)


data %>% 
  ggplot() + geom_bar(aes(x = start_hour, fill = member_casual)) + facet_wrap(~weekday)

data %>% 
  ggplot() + geom_bar(aes(x = season, fill = member_casual ), position = "dodge") 

data %>% 
  ggplot() + geom_bar(aes(x = month ))

data %>% 
  ggplot() + geom_bar(aes(x = member_casual, fill = member_casual )) + facet_wrap(~rideable_type)





