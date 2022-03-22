# load package
library(shiny)

### UI ###
ui <- fluidPage(
  print("A Basic App"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("range",
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0,100))
    ),
    mainPanel(
      textOutput("min_max")
    )
  )
)

### SERVER ###

server <- function(input, output, session){
  
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",
          input$range[1]," to ", input$range[2])
  })
}

# put UI and server together
shinyApp(ui, server)
