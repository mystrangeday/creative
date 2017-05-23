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
    leafletOutput("busmap", height = 500)
   ),
   box(width = NULL,
    uiOutput("numVehiclesTable")
   )
  )

 ),
    mainPanel(
      plotOutput("heatMap")
    )
  )
)

server <- function(input, output) {
  output$heatMap <- renderPlot({
    similarity_users <- similarity(MovieLense[1:input$users, ], method = "cosine", which = "users")
    image(as.matrix(similarity_users), main = "User similarity")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
