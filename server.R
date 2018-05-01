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



shinyServer(function(input, output, session) {
  
  collisions_subset <- reactive({
    collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week)
  })
  
  lethal_collisions_subset <- reactive({
    lethal_collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week)
  })
  
  very_lethal_collisions_subset <- reactive({
    very_lethal_collisions %>%
      filter(time_24 >= input$hour_slider[1] &
               time_24 <= input$hour_slider[2] &
               weekdays(date) %in% input$days_of_week)
  })
  
  lethal_collisions_subset_year <- reactive({
    if (input$checkbox == FALSE) {
      lethal_collisions_subset() %>%
      filter(year(date) %in% input$year)
      }
    else {
      very_lethal_collisions_subset() %>%
      filter(year(date) %in% input$year)
    }
  })

  output$accident_density_plot <- renderPlot({
    collisions_subset() %>%
      ggplot(aes(time_24, fill = weekdays(date), colour = weekdays(date))) +
      geom_density(alpha=0.1) +
      ggtitle("Hourly Accident Distribution") +
      xlab("Time of Day") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
      axis.title.x = element_text(size = 20),
      axis.title.y = element_text(size = 20)) + 
      labs(fill = "Day of Week", color = "Day of Week")
  })
  
  output$borough_plot <- renderPlot({
    collisions_subset() %>%
      filter(borough %in% input$borough) %>%
      ggplot(aes(time_24, fill = borough, colour = borough)) +
      geom_density(alpha=0.1) +
      ggtitle("Hourly Accident Distribution") +
      xlab("Time of Day") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 20, face = 'bold'),
            axis.title.x = element_text(size = 15),
            axis.title.y = element_text(size = 15)) + 
      labs(fill = "Borough", color = "Borough")
  })
  
  
  output$fatality_map <- renderPlot({
    ggplot() +
      geom_polygon(data = nyc_sf,
                   aes(x=long, y=lat, group=group)) +
      coord_equal() + geom_point(data = lethal_collisions_subset(),
                                 aes(x=longitude, y=latitude), color="red", alpha = .2) +
      ggtitle("Traffic Fatalities in NYC") +
      xlab("Latitude") + ylab("Longitude") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  output$leaflet_fatality_map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-73.96, 40.72, zoom = 12) %>%
      addCircleMarkers(lng=lethal_collisions_subset_year()$longitude,
                 lat=lethal_collisions_subset_year()$latitude,
                 popup=paste(lethal_collisions_subset_year()$number_of_persons_killed,
                             ifelse(lethal_collisions_subset_year()$number_of_persons_killed == 1,
                                    " person died here on ",
                                    " people died here on "),
                             lethal_collisions_subset_year()$date))
  })
  
  output$fatality_table_by_borough <- DT::renderDataTable(
    lethal_collisions_subset() %>%
      group_by(borough) %>%
      summarise(Death_Count = n()), rownames = F)
  
  output$fatality_table_by_year <- DT::renderDataTable(
    lethal_collisions_subset() %>%
      group_by(year(date)) %>%
      summarise(Death_Count = n()), rownames = F)
  
  
  
})


