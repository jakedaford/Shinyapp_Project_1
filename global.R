library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shinydashboard)
library(DT)
library(rgdal)
library(sp)
library(leaflet)

collisions = data.frame(fread('./collisions_lite.csv'))
collisions$date = as.Date(collisions$date)

lethal_collisions = collisions %>%
  filter(as.numeric(number_of_persons_killed) > 0)

very_lethal_collisions = lethal_collisions %>%
  filter(as.numeric(number_of_persons_killed) > 1)

nyc_sf <- readOGR("./Borough_Boundaries/geo_export_f3ba0d5a-7d6b-4731-a782-16df3f4251b5.shp")
row.names(nyc_sf) <- c("Queens", "Staten Island", "Bronx", "Brooklyn", "Manhattan")