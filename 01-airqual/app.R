library(shiny)
require(graphics)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Air Quality in NYC - 1973"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("month",
                     "Month:",
                     min = 5,
                     max = 9,
                     value = c(5,9))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("pairs"),
         tableOutput("values")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$pairs <- renderPlot({
     # suppress days from pairs graph
     d <- airquality[,1:5]
     d <- d[d$Month >= input$month[1] & d$Month <= input$month[2], ]
     pairs(d, panel = panel.smooth,
           pch=".", lwd = 2, col = "blue", 
           main = "airquality data")
   })
   
   output$values <- renderTable({
     d <- airquality
     d <- d[d$Month >= input$month[1] & d$Month <= input$month[2], ]
     
     head(d[order(d$Month, d$Day),], n=10)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

