#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Have commonbean underwent water stress?"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("RTP_COUNT",
                        "Number of root tips:",
                        min = 0,
                        max = 50,
                        value = 20),
            sliderInput("plantmass",
                        "Dryweigt of aboveground plant biomass:",
                        min = 0,
                        max = 50,
                        value = 25),
            sliderInput("TD_AVG",
                        "Tip average diameter:",
                        min = 0.00,
                        max = 2.50,
                        value = 0.26)
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderTable({
        data_model <- read.csv("/Users/limengxie/Desktop/INFO8000ProjectMomo/data_model.csv")
        fitControl <- trainControl(
            method="repeatedcv",
            number=10,
            repeats=10,
            verboseIter = FALSE)
        set.seed(981395)
        inTraining <- createDataPartition(y=data_model$environment, p=0.8,list=FALSE)
        training <- data_model[inTraining,]
        testing <- data_model[-inTraining,]
        # normalize training and testing datasets
        preProcValues <- preProcess(data_model, method = c("center", "scale"))
        #trainingProcessed <- predict(preProcValues,training)
        trainNormalized<- predict(preProcValues, training)
        testNormalized<- predict(preProcValues, testing)
        #model for shiny 
        svmFit<- train(environment ~RTP_COUNT+plantmass+TD_AVG,data=trainNormalized,method="svmLinear",tr=fitControl)
        newInput <- data.frame(RTP_COUNT=input$RTP_COUNT, plantmass=input$plantmass, TD_AVG=input$TD_AVG)
        newValue <- predict(svmFit, newdata = newInput)
        newValue
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
