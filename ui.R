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
      textInput(inputId ="LAI",
                label = "LAI(m^2/m^2):",
                value ="",
                width = "75px"),
      actionButton("calculateLAI","Calculate LAI"),br(),br(),br(),
      HTML('<center><img src="citra.jpg" width="100"></center>')
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
