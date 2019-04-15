#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
options(shiny.maxRequestSize = 30*1024^2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      ############### INICIO Side Bar Panel
    
       tabPanel("Cargar Imagen",fileInput("GetFile","Cargar Archivo"))
       
       
    ),
    ############### FIN Side Bar Panel
    
    # Show a plot of the generated distribution
    mainPanel(
      uiOutput(outputId = "image1")
    )
  )
))