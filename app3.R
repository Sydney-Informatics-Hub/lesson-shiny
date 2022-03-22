# load package
library(shiny)
library(palmerpenguins)
# devtools::install_github("vqv/ggbiplot")
library(ggbiplot)
library(skimr)
data(package = 'palmerpenguins')

### UI ###
ui <- fluidPage(
  h1("An app that presents data"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("species", 
                         label = h3("Select species"), 
                         choices = setNames(as.list(levels(penguins$species)), 
                                            levels(penguins$species)),
                         selected = levels(penguins$species))
      ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("peng_pca")),
                  tabPanel("Summary", tableOutput("summary")),
                  tabPanel("Table", tableOutput("rawdata"))
      )
    )
  )
)

### SERVER ###

server <- function(input, output, session){
  
  # Make the pca visualisation ----
  # adapted from https://rpubs.com/friendly/penguin-biplots
  # run a pca ------------
  peng_filt <- reactive(
    # keep only complete cases & the species we've selected
    penguins[(penguins$species %in% input$species) & (complete.cases(penguins)),]
  )
  
  peng_prcomp <- reactive(
    prcomp(~ bill_length_mm + bill_depth_mm + flipper_length_mm + body_mass_g,
                        data=peng_filt(),
                        na.action=na.omit, 
                        scale. = TRUE))
  
  output$peng_pca <- renderPlot(
    {
      ggbiplot(peng_prcomp(), 
               obs.scale = 1, 
               var.scale = 1,
              groups = peng_filt()$species, 
              ellipse = TRUE, circle = TRUE) +
        scale_color_discrete(name = 'Penguin Species') +
        theme_minimal() +
        theme(legend.direction = 'horizontal', legend.position = 'top') 
    }
  )
  
  
  # Get the summary ------
  output$summary <- renderTable({
    skim(peng_filt())
    })
  
  # Raw data table -------
  output$rawdata <- renderTable(
    peng_filt()
  )
}

# put UI and server together
shinyApp(ui, server)
