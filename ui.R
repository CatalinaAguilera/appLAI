library(shinyjs)
library(shiny)
source("helper.R")
options(shiny.maxRequestSize = 30*1024^2)

fluidPage(
  titlePanel("Computing LAI"),
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose Image",
                accept=c(".png",
                         ".jpg")),
      textInput("imgName", "Image Name", ""),
      selectInput("Lista","Seleccione accion:",choices = ""),br(),
      #actionButton("selectForeground", "Begin Crop"),br(),br(),
      #p("Click the button to begin cropping the image"),
      #actionButton("pauseCropping", "Pause Cropping"),br(),br(),
      #p("Click the button to pause background cropping"),
      #actionButton("resetCropping", "Reset Cropping"),br(),br(),br(),
      #p("Click the button to reset background cropping"),
      #actionButton("cropBackground", "Crop Image"),br(),br(),
      #p("Click after you have cropped out the background"),
      textInput(inputId ="LAI",
                label = "LAI(m^2/m^2):",
                value ="",
                width = "75px"),
      actionButton("calculateLAI","Calculate LAI"),br(),br(),br(),
      HTML('<center><img src="citra.jpg" width="100"></center>')
      #img(src="citra.jpg",height = 100, width = 100,align="center")
      #img(src = "citra.png",height = 70, width = 100),br(),br()
    ),
    mainPanel(
      plotOutput("plot1", click="plot1_click",
                 dblclick = "plot1_dblclick",
                 brush = brushOpts(
                   id = "plot1_brush",
                   resetOnNew = TRUE
                 ))
    )
  )
)
