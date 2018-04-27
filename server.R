library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)



function(input, output, session) {

  output$accident_density_plot <- renderPlot({
    collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week) %>%
      ggplot(aes(time_24, fill = weekdays(date), colour = weekdays(date))) +
      geom_density(alpha=0.1) +
      ggtitle("Hourly Accident Distribution")
  })
  
  
  
  
}