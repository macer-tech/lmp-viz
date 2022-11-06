#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  ###
  library(rvest)
  library(magrittr)
  library(tibble)
  
  # Jalo el contenido de la página web
  url_lmp <- "https://www.lmp.mx/"
  data <- read_html(url_lmp)
  
  ### Standing
  # Jalo el contenido de la tabla de standing
  standing <- data %>% html_nodes("app-widget-standing") %>% html_nodes("table")
  # Jalo el nombre de las columnas de la tabla
  standing_heads <- standing %>% html_nodes("thead") %>% html_nodes("tr") %>% 
    html_nodes("th") %>% html_text()
  
  # Jalo el contenido del cuerpo de la tabla
  standing_body <- standing %>% html_nodes("tbody") %>% html_nodes("tr")
  n <- standing_body %>% length()
  tabla_standing <- tibble()
  for (i in seq(1:n)) {
    df_aux <- rbind(standing_body[i] %>% html_nodes("td") %>% html_text())
    print(df_aux)
    tabla_standing <- rbind(tabla_standing, df_aux)
  }
  tabla_standing <- tabla_standing %>% tibble()
  names(tabla_standing) <- rbind(standing_heads)
  ###

  output$table <- renderDataTable(tabla_standing)

})
