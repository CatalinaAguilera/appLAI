### Function to read in images
read.image <- function(image.file){
  r<-raster(image.file,band=1)
  g<-raster(image.file,band=2)
  b<-raster(image.file,band=3)
  im<-0.2126 * r + 0.7152 * g + 0.0722 * b
}
### Function to select points
### Returns a mask that's the same dimension as the image
### With a 1 if that point is to be included
select.points <- function(im, x, y){
  if(is.null(x) | is.null(y)){
    mask <- matrix(1L, nrow=nrow(im), ncol=ncol(im))
  }else{
    #data<-im@extent
    #ymax<-data@ymax
    #xn<-min(v$imgclick.x)
    #yx<-ymax-min(v$imgclick.y)
    #xx<-max(v$imgclick.x)
    #yn<-ymax-max(v$imgclick.y)
    
    #e<-extent(im,yn,yx,xn,xx)
    #mask<-crop(im,e)
    #plot(mask)
    xym<-cbind(imgclick.x,imgclick.y)
    p1 <- Polygon(xym)
    ps1 <- Polygons(list(p1),1)
    sps1 <- SpatialPolygons(list(ps1))
    cr <- crop(im, extent(sps1), snap="out") 
    cr1<- mask(cr, sps1) 
    
    assign("ps1", ps1, envir = .GlobalEnv)
    
  }
  cr1
  
}


### Makes all points in image that have a 0 in the mask white
removePoints <- function(im, mask){
  im[mask==0] <- 1
  im
}

### Generic function for plotting the image
app.plot <- function(im, clicks.x = NULL, clicks.y = NULL, lineslist = NULL){
  if(is.null(im)){
    return(NULL)
  }
  if(is.null(ranges$x) | is.null(ranges$y)){
   
    plot(im, xaxt='n', yaxt='n', ann=FALSE,legend=FALSE,col=rev(gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL)))
  }else{
    plot(im, xaxt='n', yaxt='n', ann=FALSE, xlim=ranges$x,  ylim=c(ranges$y[2], ranges$y[1]))
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
