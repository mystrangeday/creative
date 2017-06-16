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
books <- read.csv("~/Desktop/R/CreativeClusters/cat_table/books.csv")
hotel <- read.csv("~/Desktop/R/CreativeClusters/cat_table/hotel.csv")
station <- read.csv("~/Desktop/R/CreativeClusters/cat_table/station.csv")
theatre <- read.csv("~/Desktop/R/CreativeClusters/cat_table/theatre.csv")

atm_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Atm_Rec_Geo.csv")
bridge_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Bridge_Rec_Geo.csv")
libraries_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Library_Rec_Geo.csv")
museums_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Museum_Rec_Geo.csv")
books_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Books_Rec_Geo.csv")
hotel_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Hotels_Rec_Geo.csv")
station_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Station_Rec_Geo.csv")
theatre_recc  <- read.csv("~/Desktop/R/CreativeClusters/Recommendations/Theatre_Rec_Geo.csv")

atm <- atm %>% filter(!is.na(lon))
bridge  <- bridge  %>% filter(!is.na(lon))
libraries  <- libraries  %>% filter(!is.na(lon))
museums  <- museums  %>% filter(!is.na(lon))
books  <- books  %>% filter(!is.na(lon))
hotel  <- hotel  %>% filter(!is.na(lon))
station  <- station  %>% filter(!is.na(lon))
theatre<- theatre %>% filter(!is.na(lon))

atm_recc <- atm_recc %>% filter(!is.na(lon))
bridge_recc  <- bridge_recc  %>% filter(!is.na(lon))
libraries_recc  <- libraries_recc  %>% filter(!is.na(lon))
museums_recc  <- museums_recc  %>% filter(!is.na(lon))
books_recc  <- books_recc  %>% filter(!is.na(lon))
hotel_recc  <- hotel_recc  %>% filter(!is.na(lon))
station_recc  <- station_recc  %>% filter(!is.na(lon))
theatre_recc<- theatre_recc %>% filter(!is.na(lon))


atm$icon_type <- rep(1, nrow(atm))
bridge$icon_type <- rep(1, nrow(bridge))
libraries$icon_type <- rep(1, nrow(libraries))
museums$icon_type <- rep(1, nrow(museums))
books$icon_type <- rep(1, nrow(books))
hotel$icon_type <- rep(1, nrow(hotel))
station$icon_type <- rep(1, nrow(station))
theatre$icon_type <- rep(1, nrow(theatre))


atm_recc$icon_type <- rep(1, nrow(atm_recc))
bridge_recc$icon_type <- rep(1, nrow(bridge_recc))
libraries_recc$icon_type <- rep(1, nrow(libraries_recc))
museums_recc$icon_type <- rep(1, nrow(museums_recc))
books_recc$icon_type <- rep(1, nrow(books_recc))
hotel_recc$icon_type <- rep(1, nrow(hotel_recc))
station_recc$icon_type <- rep(1, nrow(station_recc))
theatre_recc$icon_type <- rep(1, nrow(theatre_recc))


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
           "museums" = museums,
           "books" =books,
           "hotel" =hotel,
           "station"=station,
           "theatre" = theatre,
           "atm_recc" = atm_recc,
           "bridge_recc" = bridge_recc,
           "libraries_recc" = libraries_recc,
           "museums_recc" = museums_recc,
           "books_recc" =books_recc,
           "hotel_recc" =hotel_recc,
           "station_recc"=station_recc,
           "theatre_recc" = theatre_recc,
           )
    
  })
  
  output$mymap <- renderLeaflet({  
    df <- datasetInput()
    coordinates(df) <- ~lon+lat
    
    leafIcons <- icons(
      iconUrl = ifelse(df$icon_type == 1,
                       "http://leafletjs.com/examples/custom-icons/leaf-green.png",
                       "http://leafletjs.com/examples/custom-icons/leaf-red.png"
      ),
      iconWidth = 38, iconHeight = 95,
      iconAnchorX = 22, iconAnchorY = 94,
      shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
      shadowWidth = 50, shadowHeight = 64,
      shadowAnchorX = 4, shadowAnchorY = 62
    )
    
    
    leaflet(df) %>%
      addTiles() %>%
      addMarkers(data = df,
                 icon=leafIcons,
                 popup = paste0("<strong>Название: </strong>",
                                df$name,
                                "<br><strong>Адрес: </strong>",
                                df$fulladdress
                 ),
                 clusterOptions = markerClusterOptions()
      ) 
  })
}

