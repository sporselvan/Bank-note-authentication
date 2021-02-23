# Import libraries
library(shiny)

# Read in the RF model
model <- readRDS("model.rds")

# User interface
ui <- fluidPage(
   pageWithSidebar(
   # Page header
   headerPanel('Bank note Authentication'),
   # Input values
   sidebarPanel(
      tags$label(h3('Input parameters')),
      numericInput("variance",
                   label = "variance",
                   value = 5),
      numericInput("skewness",
                   label = "skewness",
                   value = 11),
      numericInput("curtosis",
                   label = "curtosis",
                   value = 2.3),
      numericInput("entropy",
                   label = "entropy",
                   value = 1.5),
      actionButton("submitbutton", "Submit", class = "btn btn-primary")
      #br(),
      #downloadButton('download',"Download the data"),
   ),
   mainPanel(
      tags$label(h3('Authentic/Duplicate')), # Status/Output Text Box
      verbatimTextOutput('contents'),
      tableOutput('tabledata'), # Prediction results table
      hr(),
      tags$em("Machine Learning App with Shiny"),
      br(),
      tags$em("By Porselvan")
      
   )
   
)
)
# Server
server <- function(input, output) {
   # Reactive Data
   datasetInput <- reactive({
      df <- as.data.frame(
                     list("variance" = input$variance,
                      "skewness" = input$skewness,
                      "curtosis" = input$curtosis,
                      "entropy" = input$entropy,
                      "class" = NA)
                     )
      data.frame(Prediction = predict(model, df),probability=predict(model,df,type="prob"))
               
   })
   # Status/Output Text Box
   output$contents <- renderPrint({
      if (input$submitbutton > 0) {
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

   # Download results
   #output$download <- downloadHandler(
      #filename = function(){"output.csv"},
      #content = function(fname){
        # write.csv(datasetInput(), fname)
      #}
   #)
}
shinyApp(ui=ui,server=server)
