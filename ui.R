library(shiny)

library(recommenderlab)
data()
library(shinydashboard)
 library(leaflet)

 header <- dashboardHeader(
 title = "Креативные кластеры"
)
 fluidRow(
  column(width = 9,
   box(width = NULL, solidHeader = TRUE,
    leafletOutput("", height = 500)
   ),
   box(width = NULL,
    uiOutput("map")
   )
  )

 ),
    mainPanel(
      plotOutput("map")
    )
  )
)

server <- function(input, output) {
  output$heatMap <- renderPlot({
    
    image(main = "Map SPb")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
