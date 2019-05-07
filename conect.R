library(rsconnect)

rsconnect::setAccountInfo(name='catalina-test',
                          token='739133E8C2DBC989A6E05CF5F9A0014F',
                          secret='<SECRET>')

rsconnect::setAccountInfo(name='catalina-test',
                          token='739133E8C2DBC989A6E05CF5F9A0014F',
                          secret='8He23+VsvdMVVVL96EfHoUIKE+jZIR0cEN97FZba')

rsconnect::deployApp('D://Documentos//Trabajo Utal//SHINY//TEST//probando')

rsconnect::configureApp(appName = "imagentest",appDir = "D://Documentos//Trabajo Utal//SHINY//TEST", size="xlarge")


