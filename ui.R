library(shiny)
library(recommenderlab)
library(shinydashboard)
library(leaflet)
library(shiny)
library(shinythemes)

tags <- c("Библиотеки", "Университеты","Музеи","Бары", "Книжные магазины", "Отели", "Мосты", "Парки", "Театры")

fluidPage(
  headerPanel("Где построить новый креативный кластер в Санкт-Петербурге?"),
  sidebarLayout(
    sidebarPanel(
      helpText("Выберите категорию, в соответствии с которой будет строиться рекомендация:"),
      selectInput("dataset", "Рекомендованные к постройке кластеров здания",
                  choices = c(
                    Банкоматы = "hotel_recc",
                    Музеи = "museums_recc",
                    Мосты = "bridge_recc",
                    Библиотеки = "libraries_recc",
                    Мосты ="bridge_recc", 
                    Книжные = "books_recc", 
                    Отели = "hotel_recc",
                    Метро = "station_recc", 
                    Театры = "theatre_recc" 
                  ),
                  selected = c("museums_recc")
          ),
    selectInput("category", "Показать существующие места",
                choices = c(
                  Банкоматы = "atm",
                  Музеи = "museums",
                  Мосты = "bridge",
                  Библиотеки = "libraries",
                  Мосты ="bridge", 
                  Книжные = "books", 
                  Отели = "hotel",
                  Метро = "station", 
                  Театры = "theatre" 
                ),
                selected = c("museums")     
   
          ),
          submitButton("Update View")
    ),
    mainPanel(
      leafletOutput("mymap"),
      hr()
      
)
)
)

