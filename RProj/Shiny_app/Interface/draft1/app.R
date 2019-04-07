library(shiny)
library(shinydashboard)
library(leaflet)

gps <- read.csv("/Users/andreawan/onedrive/Spring_19/datafest19/github_repo/DATAFEST_2019/RProj/small_dataset/gameid1_half1_playerid2_gps_subset.csv")
games <- read.csv("/Users/andreawan/onedrive/Spring_19/datafest19/DataFest_2019/DataFest-Dataset-2019/games.csv")
gps_new <- read.csv("/Users/andreawan/onedrive/Spring_19/datafest19/github_repo/DATAFEST_2019/RProj/request_lat_lon.csv")
ui <- dashboardPage(
    dashboardHeader(title = "Team Model Overfit"),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Game", tabName = "game", icon = icon("th")),
            menuItem("Info", tabName = "info", icon = icon("fas fa-info")),
            menuItem("Survey", tabName = "survey", icon = icon("poll-h"))
        )
    ),
    dashboardBody(
                  
        tabItems(
            # first tab content
            tabItem(tabName = "dashboard",
                    h2("Team Member:"),
                    h3("Alda Chau, Cindy Wang, Andrea Wan, Wilson Zhang"),
                    tags$img(src='icon.png', width = "100px", height = "150px", align = "middle"),
                    tags$h3("Fun Facts about Canada women's national rugby union team:"),
                    tags$h4("5th in World Rugby's inaugural women's rankings"),
                    tags$h4(" currently ranked as the second best team in the world")
            ),
            
            # First tab content
            tabItem(tabName = "game",
                    tags$h3("Locations"),
                    fluidRow(
                        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                        #leafletOutput("map"),
                        leaflet(data = gps_new) %>% addTiles() %>%
                            addMarkers(~lon, ~lat, label = ~as.character(Tournament))
                    )
            ),
            
            tabItem(tabName = "info",
                    tags$h3("Previous Games that Canadian Rugby had played"),
                    fluidRow(
                        box(plotOutput("plot1", height = 250), status = "danger"),
                        
                        box(
                            title = "Controls",
                            status = "danger", 
                            sliderInput("slider", "Number of observations:", min(games$TeamPoints), max(games$TeamPoints), mean(games$TeamPoints))
                        )
                    ),
                    
                    fluidRow(
                        column(4,
                               selectInput(inputId = "game",
                                           label = "game",
                                           choices = unique(games$Tournament))
                        ),
                        verbatimTextOutput("summary"),
                        tableOutput("view")
                        
                    )
                    ),
            tabItem(tabName = "survey",
                    selectInput('Pet kind', 'My Pet is...', c('Mammal', 'Reptile','marine')),
                    selectInput('Flu', 'Symptoms', c('wet nose', 'Fever','Eye discharge', 'Others')),
                    radioButtons('Urgent', 'Need a doctor in...', c('1 hour or less', '2-3 hour', '4-5 hour', 'Long-term appointment')),
                    dateRangeInput("dates", label = h3("When would you like to see the doctor?")),
                    checkboxGroupInput("Would you like...", label = h3("Checkbox group"), 
                                       choices = list("One Time Check-In" = 1, "Appointment" = 2, "Long-Term" = 3),
                                       selected = 1),
                    checkboxInput("checkbox", label = "I agree to keep all the information from this survey confidential.", value = TRUE),
                    
                    actionButton('sumbit', 'submit survey')
    )
    )),
    
    title = "Dashboard example",
    skin = "black"
)

server <- function(input, output) {
    output$map <- renderLeaflet({
        leaflet() %>% addTiles() %>% setView(42, 16, 4)
    })
    
    set.seed(122)
    histdata <- rnorm(500)
    
    output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
    })
    

    
    datasetInput <- reactive({
        switch(input$game,
               "Dubai" = return(subset(games, games$Tournament == "Dubai")),
               "Langford" = return(subset(games, games$Tournament == "Langford")),
               "Sydney" = return(subset(games, games$Tournament == "Sydney")),
               "Commonwealth" = return(subset(games, games$Tournament == "Commonwealth")),
               "Kitakyushu" = return(subset(games, games$Tournament == "Kitakyushu")),
               "Paris" = return(subset(games, games$Tournament == "Paris")),
               "World Cup" = return(subset(games, games$Tournament == "World Cup"))
               )
    })
    
    output$view <- renderTable({
        head(datasetInput())
    })
    
    
}

shinyApp(ui, server)
