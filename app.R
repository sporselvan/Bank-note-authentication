# Import libraries
library(shiny)
library(data.table)
library(randomForest)

# Read in the RF model
model <- readRDS("model.rds")


####################################
# User interface                   #
####################################

ui <- pageWithSidebar(
  
  # Page header
  headerPanel('Bank note Authentication'),
  
  # Input values
  sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
    tags$label(h3('Input parameters')),
    numericInput("variance", 
                 label = "Variance", 
                 value = 5),
    numericInput("skewness", 
                 label = "Skewness", 
                 value = 11),
    numericInput("curtosis", 
                 label = "Curtosis", 
                 value = 2.3),
    numericInput("entropy", 
                 label = "Entropy", 
                 value = 1.5),
    
    actionButton("submitbutton", "Submit", 
                 class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Authentic/Duplicate')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)

####################################
# Server                           #
####################################

server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("Variance",
               "Skewness",
               "Curtosis",
               "Entropy"),
      Value = as.character(c(input$variance,
                             input$skewness,
                             input$curtosis,
                             input$entropy)),
      stringsAsFactors = FALSE)   
    
    Species <- 0
    df <- rbind(df, class)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)
