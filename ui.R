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


shinyUI(dashboardPage(
  dashboardHeader(title = "NYC Traffic Collisions"),
  dashboardSidebar(
    
    sidebarUserPanel("NYC DSA",
                     image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Hourly Collision Data", tabName = "data", icon = icon("bar-chart-o")),
      menuItem("Data by borough", tabName = "data_by_borough", icon = icon("bar-chart-o")),
      menuItem("Fatality Map", tabName = "map", icon = icon("map")),
      menuItem("Interactive Fatality Map", tabName = "leafletmap", icon = icon("map"))
    ),
    sliderInput("hour_slider", label = h3("Hour Range"),
                min = 0, max = 24, value = c(0, 24)),
    checkboxGroupInput("days_of_week", label = h3("Days of Week"), 
                       choices = list("Monday" = "Monday",
                                      "Tuesday" = "Tuesday",
                                      "Wednesday" = "Wednesday",
                                      "Thursday" = "Thursday",
                                      "Friday" = "Friday",
                                      "Saturday" = "Saturday",
                                      "Sunday" = "Sunday"),
                       selected = c("Monday","Tuesday", "Wednesday", "Thursday",
                                    "Friday", "Saturday", "Sunday"))
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "map",
              fluidRow(box(plotOutput("fatality_map"), width = 8),
              box(DTOutput("fatality_table_by_borough"), width = 4))),
      tabItem(tabName = "leafletmap",
              fluidRow(box(leafletOutput("leaflet_fatality_map"), width = 12)),
              fluidRow(box(
                checkboxGroupInput("year", label = h3("Year"),
                                   choices = list("2012" = "2012",
                                                  "2013" = "2013",
                                                  "2014" = "2014",
                                                  "2015" = "2015",
                                                  "2016" = "2016",
                                                  "2017" = "2017"),
                                   selected = c("2012", "2013",
                                                "2014", "2015",
                                                "2016", "2017")),
                checkboxInput("checkbox", label = "Only Show Multi-death Accidents", value = FALSE),
                width = 4, height = 350),
                box(DTOutput("fatality_table_by_year"), width = 8, height = 350))),
      tabItem(tabName = "data_by_borough",
             fluidRow(box(plotOutput("borough_plot"), width = 8),
                      box(
                        checkboxGroupInput("borough", label = h3("Borough"),
                                           choices = list("MANHATTAN" = "MANHATTAN",
                                                          "BROOKLYN" = "BROOKLYN",
                                                          "QUEENS" = "QUEENS",
                                                          "BRONX" = "BRONX",
                                                          "STATEN ISLAND" = "STATEN ISLAND"),
                                           selected = c("MANHATTAN", "STATEN ISLAND")),
                        width = 4))),
      tabItem(tabName = "data",
              fluidRow(box(plotOutput("accident_density_plot"), width = 12)))
    )
  )
))