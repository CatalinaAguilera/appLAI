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
      div(actionButton("reset","Reset"),align = "right"),br(),
      HTML('<center><img src="citra.jpg" width="100"></center>')
    ),
    mainPanel(
      plotOutput("plot1", click="plot1_click",
                 dblclick = "plot1_dblclick",
                 brush = brushOpts(
                   id = "plot1_brush",
                   resetOnNew = TRUE
                 )),
      
      column(style='border: 1px solid green',
             width=12,
             HTML("<u><h4>Instrucciones: </h4></u>",
                  "<p>- Antes de realizar una accion debe cargar una imagen.</p>",
                  "<p>- Presione Crop Begin, para luego seleccionar los vertices del poligono que desea recortar.</p>",
                  "<p>- Presione Pause Cropping, si desea detener por un instante la seleccion del poligono.</p>",
                  "<p>- Presione Reset Cropping, si desea limpiar la imagen.</p>",
                  "<p>- Presione Crop Image, si desea recortar la imagen.</p>",
                  "<p>- Presione Calculate LAI, para calcular el indice de area foliar.</p>",
                  "<p>- Presione el boton Reset, si desea resetear la aplicacion.</p>")
      )
      
      
      
      
    )
  )
)
