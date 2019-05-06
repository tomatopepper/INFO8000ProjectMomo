# install shiny
#install.packages("shiny")
setwd("/Users/limengxie/Desktop/INFO8000_Project_Momo/")
library(shiny)
ui <- fluidPage (
    # Application title
   titlePanel("svm model to predict common bean under drought or not "),
    # sidebar with a slider input for number of bins 
    sidebarLayout(
        mainPanel(tableOutput("distPlot")),
        #RTP_COUNT+plantmass+TD_AVG,
        sidebarPanel(sliderInput("RTP", "Number of root tips",
                                 min=1,max=100,value=2),
                    sliderInput("Plant Biomass", "The dry weight of plant aboveground tissue",
                    min=1,max=100,value=2))
                   # selectInput('treatment','water treatment',levels(root$treatment)),
                    #numericInput('TAP_DIA', 'TAP_DIA', 0.50, min=0, max=1.0)
        ))
                 

    #numericInput(inputId = "n", label="DS_Curve Class", value=5),
     #         plotOutpuy(outputId="hist")  )
server <- function(input,output){
    output$distPlot <- renderPlot()

}
shinyApp(ui, server)
