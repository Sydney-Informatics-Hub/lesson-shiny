# load package
library(shiny)

# Create UI
ui <- fluidPage(
  print("My first app!")
)

server <- function(input, output, session){
}

# put UI and server together
shinyApp(ui, server)
