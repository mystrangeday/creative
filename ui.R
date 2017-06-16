library(shiny)
library(recommenderlab)
library(shinydashboard)
library(leaflet)
library(shiny)
library(shinythemes)

tags <- c("Библиотеки", "Университеты","Музеи","Бары", "Книжные магазины", "Отели", "Мосты", "Парки", "Театры")

fluidPage(
  headerPanel("Где построить новый креативный кластер в Санкт-Петербурге?"),
  leafletOutput("mymap"),
  hr(),
  fluidRow(
    column(2,
           selectInput("dataset", "Показать",
                              choices = c(
                                Банкоматы = "atm",
                                Музеи = "museums",
                                Мосты = "bridge",
                                Библиотеки = "libraries"
                              ),
                              selected = c("atm", "bridge")
           )
    ),
    column(4, offset = 1,
           selectInput("cat", "Приоритет:", 
                       choices=tags),
           hr(),
           helpText("Выберите категорию, в соответствии с которой будет строиться рекомендация")
    )
)
)

