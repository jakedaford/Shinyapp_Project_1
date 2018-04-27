library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)



shinyServer(function(input, output, session) {
  
  output$hello <- renderText("hello")

  output$accident_density_plot <- renderPlot({
    collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week) %>%
      ggplot(aes(time_24, fill = weekdays(date), colour = weekdays(date))) +
      geom_density(alpha=0.1) +
      ggtitle("Hourly Accident Distribution") +
      xlab("Time of Day") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$fatality_map <- renderPlot({
    lethal_collisions_subset = lethal_collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week)
    ggplot() +
      geom_polygon(data = nyc_sf,
                   aes(x=long, y=lat, group=group)) +
      coord_equal() + geom_point(data = lethal_collisions_subset,
                                 aes(x=longitude, y=latitude), color="red", alpha = .2) +
      ggtitle("Traffic Fatalities in NYC") +
      xlab("Latitude") + ylab("Longitude") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$fatality_table_by_borough <- DT::renderDataTable(
    lethal_collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week) %>%
      filter(borough != "") %>%
      group_by(borough) %>%
      summarise(Death_Count = n())
    )
})


