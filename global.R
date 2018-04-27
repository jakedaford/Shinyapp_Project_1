library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)

collisions = data.frame(fread('./collisions.csv'))
collisions$date = as.Date(collisions$date)