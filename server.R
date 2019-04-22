#library(shiny)
#library(shinyjs)
library(sp)
library(raster)

function(input, output, session) {
  
  v <- reactiveValues(
    originalImage = NULL,
    croppedImage = NULL,
    imgMask = NULL,
    imgclick.x = NULL,
    imgclick.y = NULL,
    crop.img = FALSE,
    imageName = NULL
  )
  assign("v", v, envir = .GlobalEnv)
  
  ### Code to zoom in on brushed area when double clicking for plot 1
  observeEvent(input$plot1_dblclick, {
    brush <- input$plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  ### Read in image
  ### Automatically set image name to file name
  observeEvent(input$file1, {
    v$originalImage <- read.image(input$file1$datapath)
    v$croppedImage = NULL
    v$imgMask = NULL
    v$imgclick.x = NULL
    v$imgclick.y = NULL
    v$crop.img = FALSE
    v$imageName <- gsub("(.jpg|.png)","", input$file1$name)
    updateTextInput(session, inputId = "imgName", label = NULL, value = v$imageName)
    output$plot1 <- renderPlot({
      app.plot(v$originalImage,v$imgclick.x, v$imgclick.y)
    })
    
    updateSelectInput(
      session,
      "Lista",
      choices = c("","Begin Crop","Pause Cropping","Reset Cropping","Crop Image")
    )
    
  })
  
  observeEvent(input$imgName, {
    v$imageName <- input$imgName
  })
  
  
  observeEvent(input$Lista, {
    if(input$Lista == ""){
      return()
    }else if(input$Lista == "Begin Crop"){
      v$crop.img <- TRUE
    }else if(input$Lista == "Pause Cropping"){
      v$crop.img <- FALSE
    }else if(input$Lista == "Reset Cropping"){
      v$croppedImage <- NULL
      v$imgMask <- NULL
      v$crop.img <- FALSE
      v$imgclick.x  <- NULL
      v$imgclick.y <- NULL
      
      output$plot1 <- renderPlot({
        app.plot(v$originalImage,v$imgclick.x, v$imgclick.y)
      })
    }else if(input$Lista == "Crop Image"){
      if(is.null(v$imgclick.x) | is.null(v$imgclick.y)){
        v$croppedImage <- v$originalImage
        v$imgMask <- select.points(v$originalImage, v$imgclick.x, v$imgclick.y)
      }else{
        v$imgMask <- select.points(v$originalImage, v$imgclick.x, v$imgclick.y)
        v$croppedImage <-v$imgMask 
        #removePoints(v$originalImage, v$imgMask)
        v$crop.img <- FALSE
        v$imgclick.x  <- NULL
        v$imgclick.y <- NULL
      }
      output$plot1 <- renderPlot({
        app.plot(v$croppedImage)
      })
    }
  })
  
  # Handle clicks on the plot for tracing foreground
#  observeEvent(input$selectForeground, {
#    v$crop.img <- TRUE
#    disable("selectForeground")
#    enable("pauseCropping")
#    enable("resetCropping")
#    enable("cropBackground")
#  })
  
  ### Pause cropping
#  observeEvent(input$pauseCropping, {
#    v$crop.img <- FALSE
#    disable("pauseCropping")
#    enable("selectForeground")
#    enable("resetTracePaw")
#    enable("cropBackground")
#  })
  
  
  ## Reset cropping
#  observeEvent(input$resetCropping, {
#    v$croppedImage <- NULL
#    v$imgMask <- NULL
#    v$crop.img <- FALSE
#    v$imgclick.x  <- NULL
#    v$imgclick.y <- NULL
#    enable("pauseCropping")
#    enable("selectForeground")
#    disable("resetTracePaw")
#    enable("cropBackground")
#    output$plot1 <- renderPlot({
#      app.plot(v$originalImage,v$imgclick.x, v$imgclick.y)
#    })
#  })
  
  
#  observeEvent(input$cropBackground,{
#    if(is.null(v$imgclick.x) | is.null(v$imgclick.y)){
#      v$croppedImage <- v$originalImage
#      v$imgMask <- select.points(v$originalImage, v$imgclick.x, v$imgclick.y)
#    }else{
#      v$imgMask <- select.points(v$originalImage, v$imgclick.x, v$imgclick.y)
#      v$croppedImage <-v$imgMask 
        #removePoints(v$originalImage, v$imgMask)
#      v$crop.img <- FALSE
#      v$imgclick.x  <- NULL
#      v$imgclick.y <- NULL
#      enable("pauseCropping")
#      enable("selectForeground")
#      enable("resetTracePaw")
#      disable("cropBackground")
#    }
#    output$plot1 <- renderPlot({
#      app.plot(v$croppedImage)
#    })
#  })
  
 observeEvent(input$calculateLAI,{
    
    if (is.null(v$originalImage)) {
      updateTextInput(session,inputId = "LAI",label = NULL,value = "")
    }else{
      v$croppedImage[v$croppedImage>=150]<-0
      v$croppedImage[v$croppedImage>0]<-1
      
      full<-v$croppedImage
      
      full[full>=0]<-1
      tot<-cellStats(full,'sum')
      leaf<-cellStats(v$croppedImage,'sum')
      lai<-leaf/tot
      
      updateTextInput(session, inputId = "LAI", label = NULL, value = round(lai,digits = 2))
    }
    
  })
  
  ### Keep track of click locations if tracing paw or tumor 
  observeEvent(input$plot1_click, {
    # Keep track of number of clicks for line drawing
    if(v$crop.img){
      v$imgclick.x <- c(v$imgclick.x, round(input$plot1_click$x))
      v$imgclick.y <- c(v$imgclick.y, round(input$plot1_click$y))
      assign("imgclick.x", v$imgclick.x, envir = .GlobalEnv)
      assign("imgclick.y", v$imgclick.y, envir = .GlobalEnv)
    }
  })
  
  
  ### Original Image
  output$plot1 <- renderPlot({
    app.plot(v$originalImage, v$imgclick.x, v$imgclick.y)
  })
  
 
}