library(ggfortify)
library(plotly)
library(ggplot2)
library(ggmap)
library(rgdal)
library(sp)
library(leaflet)
library(jsonlite)
library(dplyr)
library("ggmap")
library("tidyr")
library("dplyr")

atm <- read.csv("~/Desktop/R/CreativeClusters/cat_table/atm.csv")
bridge <- read.csv("~/Desktop/R/CreativeClusters/cat_table/bridge.csv")
libraries <- read.csv("~/Desktop/R/CreativeClusters/cat_table/library.csv")
museums <- read.csv("~/Desktop/R/CreativeClusters/cat_table/museum.csv")


atm <- atm %>% filter(!is.na(lon))
bridge  <- bridge  %>% filter(!is.na(lon))
libraries  <- libraries  %>% filter(!is.na(lon))
museums  <- museums  %>% filter(!is.na(lon))

function(input, output, session) {
  
  #museums <- read.csv("~/Desktop/R/CreativeClusters/creative-master/museums.csv")
  #museums <- museums[-c(17, 3, 9, 47), ]
  #df <- museums
  #coordinates(df) <- ~lon+lat
  
  #atm <- read.csv("~/Desktop/R/CreativeClusters/Atm_Rec_Geo.csv")
  #df <- atm
  #coordinates(df) <- ~lon+lat

  datasetInput <- reactive({
    switch(input$dataset,
           "atm" = atm,
           "bridge" = bridge,
           "libraries" = libraries,
           "museums" = museums
           )
    
  })
  
  
  
  
  output$mymap <- renderLeaflet({  
    df <- datasetInput()
    coordinates(df) <- ~lon+lat
    leaflet(df) %>%
      addTiles() %>%
      addMarkers(data = df,
                 popup = paste0("<strong>Название: </strong>",
                                df$name,
                                "<br><strong>Адрес: </strong>",
                                df$fulladdress
                 ),
                 clusterOptions = markerClusterOptions()
      ) 
  })
}

