library(dplyr)
library(data.table)
library(ggplot2)
library(rgdal)
library(sp)

#cleaning up nyc_collisions_orig.csv
#####
#collisions_orig = data.frame(fread('./nyc_collisions_orig.csv'))
#colnames(collisions_orig)

#collisions = collisions_orig %>%
#  select(c(1:6,
#           15:22,
#           23:27,
#           29:33)) %>%
#  filter(!is.na(latitude) & !is.na(longitude))

#collisions$date = as.Date(collisions$date)

#cols_to_be_factors = c(3,4, 7:24)

#collisions[cols_to_be_factors] = lapply(collisions[cols_to_be_factors], factor)

#write.csv(collisions, file='collisions_modified.csv', row.names=FALSE)
#str(collisions)

#wrote this to a csv so should be good now

##### lethal collisions


lethal_collisions = collisions %>%
  filter(as.numeric(levels(number_of_persons_killed))[number_of_persons_killed] > 0)

count_collisions_by_borough = collisions %>%
  group_by(borough) %>%
  summarise(accidents = n())

count_lethal_collisions_by_borough = lethal_collisions %>%
  group_by(borough) %>%
  summarise(lethal_accidents = n())

how_lethal = inner_join(count_collisions_by_borough, count_lethal_collisions_by_borough, by='borough')

how_lethal$percent_lethal = how_lethal$lethal_accidents / how_lethal$accidents

how_lethal

g = ggplot(how_lethal, aes(x = borough, y = percent_lethal))
g + geom_bar(stat='identity')

h = ggplot(how_lethal, aes(x = borough, y = lethal_accidents))
h + geom_bar(stat='identity')


z = ggplot(lethal_collisions) 
z +  geom_point(aes(x=longitude, y=latitude), color="red", alpha = .9)


nyc_sf <- readOGR("./Borough_Boundaries/geo_export_f3ba0d5a-7d6b-4731-a782-16df3f4251b5.shp")
row.names(nyc_sf) <- c("Queens", "Staten Island", "Bronx", "Brooklyn", "Manhattan")

# Plot of all NYC filled by boro
ggplot() +
  geom_polygon(data = nyc_sf,
               aes(x=long, y=lat, group=group)) +
  coord_equal() + geom_point(data = lethal_collisions,
                             aes(x=longitude, y=latitude), color="red", alpha = .1)

nrow(lethal_collisions)

injurious_collisions = collisions %>%
  filter(as.numeric(levels(number_of_persons_injured))[number_of_persons_injured] > 0 |
           as.numeric(levels(number_of_persons_killed))[number_of_persons_killed] > 0)

nrow(injurious_collisions)

weekdays(injurious_collisions$date[5])


d = ggplot(injurious_collisions, aes(x = weekdays(injurious_collisions$date)))
d + geom_histogram(stat='count')

str(injurious_collisions)
unique(injurious_collisions$time)
min(sapply(unique(injurious_collisions$time), nchar))

View(unique(injurious_collisions$time))

unique(injurious_collisions$vehicle_type_code1)

count_by_vehicle = injurious_collisions %>%
  group_by(vehicle_type_code1) %>%
  summarise(count = n())

View(count_by_vehicle)

nrow(injurious_collisions)

injurious_collisions_2015 = injurious_collisions %>%
  filter(year(injurious_collisions$date) == 2015)

nrow(injurious_collisions_2015)

#sample_time =unique(injurious_collisions$time)[5]
#sample_time
#short_time = injurious_collisions$time[1]
#short_time
#paste0('0', short_time)
#use mutate and ifelse to get all of them to be 5 characters long
#substring(sample_time, 1, 2)
#substring(sample_time, 4, 5)
#as.numeric(substring(sample_time, 1, 2)) +
#  as.numeric(substring(sample_time, 4, 5))/60

#collisions = collisions %>%
#  mutate(uniform_time = ifelse(nchar(time) == 4, paste0('0', time), time)) %>%
#  mutate(time_24 = as.numeric(substring(uniform_time, 1, 2)) +
#           as.numeric(substring(uniform_time, 4, 5))/60
#         )
#View(collisions$time_24)

#### certain time range, certain day of week

collisions_somehours_somedays = collisions %>%
  filter(weekdays(collisions$date) %in% c('Saturday', 'Sunday')) %>%
  filter(time_24 < 24 & time_24 > 6)

w = ggplot(collisions_somehours_somedays, aes(time_24))
w + geom_density()

collisions_somehours_somedays = collisions %>%
  filter(weekdays(collisions$date) %in% c('Monday', 'Friday', 'Saturday', 'Sunday')) %>%
  filter(time_24 < 24 & time_24 > 1)

v = ggplot(collisions_somehours_somedays, aes(time_24,
                                              fill = weekdays(date),
                                              colour = weekdays(date)))
v + geom_density(alpha=0.1)



str(collisions)

str(collisions)

