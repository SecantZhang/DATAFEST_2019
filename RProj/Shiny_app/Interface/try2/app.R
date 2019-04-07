library(shiny)
library(shinydashboard)
library(leaflet)
runExample("03_reactivity")
gps <- read.csv("/Users/andreawan/onedrive/Spring_19/datafest19/github_repo/DATAFEST_2019/RProj/small_dataset/gameid1_half1_playerid2_gps_subset.csv")
games <- read.csv("/Users/andreawan/onedrive/Spring_19/datafest19/DataFest_2019/DataFest-Dataset-2019/games.csv")

ui <- dashboardPage(
    dashboardHeader(title = "Team Model Overfit"),
    ## Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Game", tabName = "game", icon = icon("th")),
            menuItem("Info", tabName = "info", icon = icon("fas fa-info"))
        )
    ),
    dashboardBody(
        tags$head(tags$style(HTML('
                                  .skin-red .main-header .logo {
                                  background-color: #3c8dbc;
                                  }
                                  .skin-red-header .logo:hover {
                                  background-color: #3c8dbc;
                                  }'
        ))),
        
        tabItems(
            
            # Second tab content
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
                    tags$h2("Previous Games that Canadian Rugby had played"),
                    fluidRow(
                        box(plotOutput("plot1", height = 250), status = "danger"),
                        
                        box(
                            title = "Controls",
                            status = "danger", 
                            sliderInput("slider", "Number of observations:", 1, 100, 50)
                        )
                    ),
                    fluidRow(
                        tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                        #leafletOutput("map"),
                        leaflet(data = gps[1:20,]) %>% addTiles() %>%
                            addMarkers(~Longitude, ~Latitude, label = ~as.character(GameID))
                    )
            ),
            
            tabItem(tabName = "info",
                    fluidRow(
                        column(4,
                               hr(),
                               verbatimTextOutput('out1'),
                               selectInput('in1', 'Game', c(Choose='Which Game?', unique(games$Tournament)), selectize=FALSE)
                        ),
                        column(4,
                               hr(),
                               verbatimTextOutput('out2'),
                               selectInput('in2', 'Opponent', c(Choose='Who is the opponent', unique(games$Opponent)), selectize=FALSE)
                        ),
                        column(4,
                               hr(),
                               verbatimTextOutput('out3'),
                               selectInput(inputId = "dataset",
                                           label = "Choose a dataset:",
                                           choices = c("rock", "pressure", "cars"))
                        )
                    )
            )
            
        )
        ),
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
    
    output$out1 <- renderPrint(input$in1)
    output$out2 <- renderPrint(input$in2)
    output$out3 <- renderPrint(input$in3)
    output$out4 <- renderPrint(input$in4)
    output$out5 <- renderPrint(input$in5)
    output$out6 <- renderPrint(input$in6)
    
    datasetInput <- reactive({
        switch(input$dataset,
               "rock" = rock,
               "pressure" = pressure,
               "cars" = cars)
    })
    
    # Generate a summary of the dataset ----
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    # Show the first "n" observations ----
    output$view <- renderTable({
        head(datasetInput(), n = input$obs)
    })
}

shinyApp(ui, server)
