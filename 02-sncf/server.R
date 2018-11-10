library(shiny)
library("RColorBrewer")

# Define server logic
server <- function(input, output) {
  
  # update the array from the filter options
  dValues <- reactive({
    d <- dAge[dAge$date >= input$year[1] & dAge$date <= input$year[2],]
    d <- d[d$contrat %in% input$contrat,]
    d <- d[d$age %in% input$age,]
    d[d$college %in% input$college,]
  })
  
  f <- function(axe) {
    d = dValues()
    ta = unique(unlist(d[[axe]]))
    years <- sort(unique(unlist(d$date)))
    m <- matrix(years, ncol=1)
    colnames(m) <- 'Y'
    
    colNum <- 2
    
    for (t in ta) {
      d2 = d[d[[axe]] == t,]
      a <- aggregate(effectif ~ date, d2, sum)
      
      years <- sort(unique(unlist(a[1])))
      m2 <- matrix(years, ncol=1)
      colnames(m2) <- 'Y'
      
      m2 <- cbind(m2, unlist(a[2]))
      
      m <- merge(m, m2, by="Y", all=TRUE)
      m[is.na(m)] <- 0
      colnames(m)[colNum] <- t
      colNum <- colNum+1
    }
    m <- apply(m, c(1,2), as.integer)
    return(m)
  }
  
  # sAxis <- reactiveValues(axe='age')
  
  # update the data to be put on the graph
  dGraph <- reactive({
    f('age')
  })
  
  dDataCollege <- reactive({
    f('college')
  })
  
  output$table <- renderTable({
    head(dValues(),
         n = input$numLines)
  })
  
  output$plot <- renderPlot({
    # isolate(sAxis$axe <- 'age')
    
    d <- dGraph()
    if (nrow(d) == 0) {
      return()
    }
    
    d2 <- d[,2:ncol(d)]
    
    if (nrow(d) > 1) {
      barplot(t(d2),
              xlim = c(0, nrow(d)+4),
              names.arg = d[,1],
              legend.text = colnames(d2),
              col = brewer.pal(n = ncol(d)+1, name = "RdBu"),
              border = FALSE,
              beside = FALSE,
              main = "Effectifs par age")
    } else {
      barplot(matrix(d2),
              xlim = c(0, nrow(d)+1),
              names.arg = d[,1],
              legend.text = colnames(d)[2:ncol(d)],
              col = brewer.pal(n = ncol(d)+1, name = "RdBu"),
              border = FALSE,
              main = "Effectifs par age")
      
    }
  })
  
  output$college <- renderTable({
    a<- t(dDataCollege())
    Total <- colSums(a)
    a<-rbind(a, Total)

    colnames(a) <- a[1,]
    
    formatC(a[2:nrow(a),], format="d", big.mark = ' ')
  }, align='r', rownames = TRUE)
}