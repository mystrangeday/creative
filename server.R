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

atm <- read.csv("~/Desktop/R/CreativeClusters/cat_table/atm2.csv")
bridge <- read.csv("~/Desktop/R/CreativeClusters/cat_table/bridge2.csv")
libraries <- read.csv("~/Desktop/R/CreativeClusters/cat_table/library2.csv")
museums <- read.csv("~/Desktop/R/CreativeClusters/cat_table/museums2.csv")
books <- read.csv("~/Desktop/R/CreativeClusters/cat_table/books2.csv")
hotel <- read.csv("~/Desktop/R/CreativeClusters/cat_table/hotel2.csv")
station <- read.csv("~/Desktop/R/CreativeClusters/cat_table/station2.csv")
theatre <- read.csv("~/Desktop/R/CreativeClusters/cat_table/theatre2.csv")

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


atm_recc$icon_type <- rep(2, nrow(atm_recc))
bridge_recc$icon_type <- rep(2, nrow(bridge_recc))
libraries_recc$icon_type <- rep(2, nrow(libraries_recc))
museums_recc$icon_type <- rep(2, nrow(museums_recc))
books_recc$icon_type <- rep(2, nrow(books_recc))
hotel_recc$icon_type <- rep(2, nrow(hotel_recc))
station_recc$icon_type <- rep(2, nrow(station_recc))
theatre_recc$icon_type <- rep(2, nrow(theatre_recc))

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
         "atm_recc" = atm_recc,
         "bridge_recc" = bridge_recc,
         "libraries_recc" = libraries_recc,
         "museums_recc" = museums_recc,
         "books_recc" =books_recc,
         "hotel_recc" =hotel_recc,
         "station_recc"=station_recc,
         "theatre_recc" = theatre_recc
  )
}



function(input, output, session) {
  
  #museums <- read.csv("~/Desktop/R/CreativeClusters/creative-master/museums.csv")
  #museums <- museums[-c(17, 3, 9, 47), ]
  #df <- museums
  #coordinates(df) <- ~lon+lat
  
  #atm <- read.csv("~/Desktop/R/CreativeClusters/Atm_Rec_Geo.csv")
  #df <- atm
  #coordinates(df) <- ~lon+lat
  
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
                       "http://r.piterdata.ninja/files/3kurs/create/1497642650_map-marker.png",
                       "http://r.piterdata.ninja/files/3kurs/create/1497644002_FlagRed.png"
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

