### Funcion para leer imagenes
read.image <- function(image.file){
 
  r<-raster(image.file,band=1)
  #g<-raster(image.file,band=2)
  #b<-raster(image.file,band=3)
  nr<-nrow(r)/8
  nc<-ncol(r)/8
  w <- raster(nrow=nr, ncol=nc,xmn=0, xmx=r@extent@xmax, ymn=0, ymx=r@extent@ymax, crs=NA)
  remove(nr,nc)
  # Cambiar resolucion de la imagen
  rr = resample(r,w)
  remove(r)
  removeTmpFiles(h=.01)
  gc()
  im<-0.2126 * rr
  remove(rr)
  removeTmpFiles(h=.01)
  gc()
  r<-raster(image.file,band=2)
  gg = resample(r,w)
  remove(r)
  removeTmpFiles(h=.01)
  gc()
  im<-im + 0.7152 * gg
  remove(gg)
  removeTmpFiles(h=.01)
  gc()
  r<-raster(image.file,band=3)
  bb = resample(r,w)
  remove(r)
  removeTmpFiles(h=.01)
  gc()
  im<-im + 0.0722 * bb
  remove(bb,w)
  removeTmpFiles(h=.01)
  gc()
  #im<-0.2126 * rr + 0.7152 * gg + 0.0722 * bb
  im
}
### Funcion para seleccionar los puntos
select.points <- function(im, x, y){
  if(is.null(x) | is.null(y)){
    mask <- matrix(1L, nrow=nrow(im), ncol=ncol(im))
  }else{
    xym<-cbind(imgclick.x,imgclick.y)
    p1 <- Polygon(xym)
    ps1 <- Polygons(list(p1),1)
    sps1 <- SpatialPolygons(list(ps1))
    cr <- crop(im, extent(sps1), snap="out")
    #Recorta el poligono
    cr1<- mask(cr, sps1)
  }
  cr1
}


### Funcion que hace todos los puntos en la imagen que tienen un 0 en la mascara blanca
removePoints <- function(im, mask){
  im[mask==0] <- 1
  im
}

### Funcion que genera el plot de la imagen
app.plot <- function(im, clicks.x = NULL, clicks.y = NULL, lineslist = NULL){
  if(is.null(im)){
    return(NULL)
  }
  if(is.null(ranges$x) | is.null(ranges$y)){
    plot(im, xaxt='n', yaxt='n', ann=FALSE,legend=FALSE,col=rev(grey.colors(256)))
  }else{
    plot(im, xaxt='n', yaxt='n', ann=FALSE, xlim=ranges$x,  ylim=c(ranges$y[2], ranges$y[1]),legend=FALSE)
  }
  if(length(clicks.x) > 1){
    lines(c(clicks.x, clicks.x[1]), c(clicks.y, clicks.y[1]), col='red')
  }
  if(!is.null(lineslist)){
    for(i in 1:length(lineslist)){
      x <- lineslist[[i]][[1]]
      y <- lineslist[[i]][[2]]
      lines(c(x, x[1]), c(y, y[1]), col='red')
    }
  }
}

### Set ranges for zooming
ranges <- reactiveValues(x = NULL, y = NULL)

v <- reactiveValues(
  originalImage = NULL,
  croppedImage = NULL,
  imgMask = NULL,
  imgclick.x = NULL,
  imgclick.y = NULL,
  crop.img = FALSE,
  imageName = NULL
)

#Prueba con variable Lista no funciona!!
#v <- list(
#  originalImage = NULL,
#  croppedImage = NULL,
#  imgMask = NULL,
#  imgclick.x = NULL,
#  imgclick.y = NULL,
#  crop.img = FALSE,
#  imageName = NULL
#)
