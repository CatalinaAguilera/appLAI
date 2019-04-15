#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(imager)

shinyServer(function(input, output) {
  
  imageOriginal = NULL
  imageName = NULL
  
  read.image <- function(image.file){
    im <- load.image(image.file)
    if(dim(im)[4] > 3){
      im <- imappend(channels(im, 1:3), 'c')
    }
    im
  }
 
  observeEvent(input$GetFile, {
    imageOriginal = read.image(input$GetFile$datapath)
    imageName = gsub("(.jpg|.png)","", input$GetFile$name)
    
    output$ploteo <- renderPlot({
      app.plot(imageOriginal)
    })
    
  })
  
  app.plot <- function(im){
    if(is.null(im)){
      return(NULL)
    }
    plot(im)
  }
  
})
