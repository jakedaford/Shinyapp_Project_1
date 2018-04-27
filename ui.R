library(shiny)
library(data.table)



fluidPage(
  titlePanel("NYC Traffic Collisions"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      sliderInput("hour_slider", label = h3("Hour Range (military time)"),
                  min = 0, max = 24, value = c(2, 20)),
      checkboxGroupInput("days_of_week", label = h3("Days of Week"), 
                         choices = list("Monday" = "Monday",
                                        "Tuesday" = "Tuesday",
                                        "Wednesday" = "Wednesday",
                                        "Thursday" = "Thursday",
                                        "Friday" = "Friday",
                                        "Saturday" = "Saturday",
                                        "Sunday" = "Sunday"),
                         selected = c("Tuesday", "Wednesday", "Saturday", "Sunday")),
      checkboxGroupInput("borough", label = h3("Borough"), 
                         choices = list("MANHATTAN" = "MANHATTAN",
                                        "BROOKLYN" = "BROOKLYN",
                                        "QUEENS" = "QUEENS",
                                        "BRONX" = "BRONX",
                                        "STATEN ISLAND" = "STATEN ISLAND",
                                        "Unlabeled" = ""),
                         selected = c("MANHATTAN", "BROOKLYN"))
    ),
    mainPanel = mainPanel(
      plotOutput("accident_density_plot")
    )
  )
)