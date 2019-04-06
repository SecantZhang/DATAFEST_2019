#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tmap)

data(World)

varlist <- setdiff(names(World), "geometry")


ui = fluidPage(
    titlePanel("Shiny tmap!"),
    sidebarLayout(
        sidebarPanel(
            selectInput("var", label = "Variable", choices = varlist, selected = "pop_est_dens")  
        ),
        mainPanel(
            leafletOutput("map")
        )
        )
    )

# Define server logic required to draw a histogram
server = function(input, output) {
    output$map = renderLeaflet({
        if (packageVersion("tmap") >= 2.0) {
            tm <- tm_basemap(leaflet::providers$Stamen.TerrainBackground) +
                tm_shape(World) +
                tm_polygons(input$var) +
                tm_tiles(leaflet::providers$Stamen.TonerLabels, group = "Labels")  
        } else {
            tm <- tm_shape(World) +
                tm_polygons(input$var) + 
                tm_view(basemaps = "Stamen.TerrainBackground")
        }
        
        tmap_leaflet(tm)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

