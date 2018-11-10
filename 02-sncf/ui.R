# Define UI
ui <- fluidPage(
  
  titlePanel("SNCF effectifs"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Année :",
                  min = min(dAge[1]),
                  max = max(dAge[1]),
                  value = c(min(dAge[1]), max(dAge[1])),
                  step = 1, round=TRUE, sep=""),
      
      numericInput(inputId = "numLines",
                   label = "Nombre de ligne à afficher:",
                   value = 20),
      
      checkboxGroupInput("contrat", "Contrat de Travail :",
                         unique(unlist(dAge[2])),
                         selected = unique(unlist(dAge[2])) ),
      
      checkboxGroupInput("college", "Collège :",
                         unique(unlist(dAge[3])),
                         selected = unique(unlist(dAge[3])) ),
      
      checkboxGroupInput("age", "Age :",
                         unique(unlist(dAge$age)),
                         selected = unique(unlist(dAge$age)) )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Principale",
                 plotOutput("plot"),
                 headerPanel("Données par collèges"),
                 tableOutput("college")),
        
        tabPanel("Données",
                 headerPanel('Table des données'),
                 tableOutput("table"))
      )
    )
  )
)
