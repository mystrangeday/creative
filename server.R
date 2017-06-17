library(shiny)
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

atm <- read.csv("./atm2.csv")
bridge <- read.csv("./bridge2.csv")
libraries <- read.csv("./library2.csv")
museums <- read.csv("./museums2.csv")
books <- read.csv("./books2.csv")
hotel <- read.csv("./hotel2.csv")
station <- read.csv("./station2.csv")
theatre <- read.csv("./theatre2.csv")

atm_rec  <- read.csv("./Atm_Rec_Geo.csv")
bridge_rec  <- read.csv("./Bridge_Rec_Geo.csv")
libraries_rec  <- read.csv("./Library_Rec_Geo.csv")
museums_rec  <- read.csv("./Museum_Rec_Geo.csv")
books_rec  <- read.csv("./Books_Rec_Geo.csv")
hotel_rec  <- read.csv("./Hotels_Rec_Geo.csv")
station_rec  <- read.csv("./Station_Rec_Geo.csv")
theatre_rec  <- read.csv("./Theatre_Rec_Geo.csv")

atm <- atm %>% filter(!is.na(lon))
bridge  <- bridge  %>% filter(!is.na(lon))
libraries  <- libraries  %>% filter(!is.na(lon))
museums  <- museums  %>% filter(!is.na(lon))
books  <- books  %>% filter(!is.na(lon))
hotel  <- hotel  %>% filter(!is.na(lon))
station  <- station  %>% filter(!is.na(lon))
theatre<- theatre %>% filter(!is.na(lon))

atm_rec <- atm_rec %>% filter(!is.na(lon))
bridge_rec  <- bridge_rec  %>% filter(!is.na(lon))
libraries_rec  <- libraries_rec  %>% filter(!is.na(lon))
museums_rec  <- museums_rec  %>% filter(!is.na(lon))
books_rec  <- books_rec  %>% filter(!is.na(lon))
hotel_rec  <- hotel_rec  %>% filter(!is.na(lon))
station_rec  <- station_rec  %>% filter(!is.na(lon))
theatre_rec<- theatre_rec %>% filter(!is.na(lon))


atm$icon_type <- rep(1, nrow(atm))
bridge$icon_type <- rep(1, nrow(bridge))
libraries$icon_type <- rep(1, nrow(libraries))
museums$icon_type <- rep(1, nrow(museums))
books$icon_type <- rep(1, nrow(books))
hotel$icon_type <- rep(1, nrow(hotel))
station$icon_type <- rep(1, nrow(station))
theatre$icon_type <- rep(1, nrow(theatre))


atm_rec$icon_type <- rep(2, nrow(atm_rec))
bridge_rec$icon_type <- rep(2, nrow(bridge_rec))
libraries_rec$icon_type <- rep(2, nrow(libraries_rec))
museums_rec$icon_type <- rep(2, nrow(museums_rec))
books_rec$icon_type <- rep(2, nrow(books_rec))
hotel_rec$icon_type <- rep(2, nrow(hotel_rec))
station_rec$icon_type <- rep(2, nrow(station_rec))
theatre_rec$icon_type <- rep(2, nrow(theatre_rec))

get_category <- function(category) {
  switch(category,
         "atm" = atm,
         "bridge" = bridge,
         "libraries" = libraries,
         "museums" = museums,
         "books" =books,
         "hotel" =hotel,
         "station"=station,
         "theatre" = theatre)
}

get_dataset <- function(dataset) {
  switch(dataset,
         "atm_recc" = atm_rec,
         "bridge_recc" = bridge_rec,
         "libraries_recc" = libraries_rec,
         "museums_recc" = museums_rec,
         "books_recc" =books_rec,
         "hotel_recc" =hotel_rec,
         "station_recc"=station_rec,
         "theatre_recc" = theatre_rec
  )
}



function(input, output, session) {
  
  #museums <- read.csv("/3kurs/creative_clusters_final/creative-master/museums.csv")
  #museums <- museums[-c(17, 3, 9, 47), ]
  #df <- museums
  #coordinates(df) <- lon+lat
  
  #atm <- read.csv("/3kurs/creative_clusters_final/Atm_Rec_Geo.csv")
  #df <- atm
  #coordinates(df) <- lon+lat
  
  datasetInput <- reactive({
    
    df1  <- get_dataset(input$dataset)
    df2  <- get_category(input$category)
    
    if(!("name" %in% colnames(df1))) { names(df1)[names(df1) == 'address'] <- 'name'}
    if(!("name" %in% colnames(df2))) { names(df2)[names(df2) == 'address'] <- 'name'}
    
    df1 <- df1[,c("lon", "lat", "icon_type", "name")]
    df2  <- df2[,c("lon", "lat", "icon_type", "name")]
    rbind(df1, df2)
  })
  
  output$mymap <- renderLeaflet({ 
    df <- datasetInput()
    coordinates(df) <- ~lon+lat
    
    leafIcons <- icons(
      iconUrl = ifelse(df$icon_type == 1,
                       "http://r.piterdata.ninja/files/3kurs/creative_clusters_final/1497642650_map-marker.png",
                       "http://r.piterdata.ninja/files/3kurs/creative_clusters_final/1497644002_FlagRed.png"
      ),
      iconWidth = 30, iconHeight = 30,
      iconAnchorX = 22, iconAnchorY = 94
    )
    
    
    leaflet(df) %>%
      addTiles() %>%
      addMarkers(data = df,
                 icon=leafIcons,
                 popup = paste0("<strong>Название и адрес: </strong>",
                                df$name
                 ),
                 clusterOptions = markerClusterOptions()
      ) 
  })
}

