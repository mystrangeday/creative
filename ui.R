library(shiny)

library(recommenderlab)
data(MovieLense)

ui <- fluidPage(
  titlePanel("Similarity between users"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("users",
                  "Number of users:",
                  min = 2,
                  max = 30,
                  value = 10)
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