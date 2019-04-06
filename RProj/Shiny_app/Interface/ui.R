#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Datafest19 - Team Model Overfit",
                   theme = shinytheme("lumen"),
                   
                   tabPanel("WELCOME!",icon=icon("heart"),
                            tags$h2("Team Member:"),
                            tags$h3("Alda Chau, Cindy Wang, Andrea Wan, Wilson Zhang"),
                            img(src='icon.png', width = "100px", height = "150px", align = "middle"),
                            tags$h3("Fun Facts about Canada women's national rugby union team:"),
                            tags$h4("5th in World Rugby's inaugural women's rankings"),
                            tags$h4(" currently ranked as the second best team in the world")
                   ),
                   
                   tabPanel("Profile", icon=icon("bar-chart-o"),
                            
                            selectInput('Pet kind', 'My Pet is...', c('Mammal', 'Reptile','marine')),
                            selectInput('Flu', 'Symptoms', c('wet nose', 'Fever','Eye discharge', 'Others')),
                            radioButtons('Urgent', 'Need a doctor in...', c('1 hour or less', '2-3 hour', '4-5 hour', 'Long-term appointment')),
                            dateRangeInput("dates", label = h3("When would you like to see the doctor?")),
                            checkboxGroupInput("Would you like...", label = h3("Checkbox group"), 
                                               choices = list("One Time Check-In" = 1, "Appointment" = 2, "Long-Term" = 3),
                                               selected = 1),
                            checkboxInput("checkbox", label = "I agree to keep all the information from this survey confidential.", value = TRUE),
                            
                            actionButton('sumbit', 'submit survey')
                   ),
                   
                   tabPanel("Find",icon = icon("refresh"),
                            
                            sidebarPanel(
                                #User input address they want to search
                                textInput("location", "Where are you?", "I'm at...."),
                                verbatimTextOutput("value"),
                                #Open Now
                                selectInput('Open Now', 'Open Now', c('Yes', 'No')),
                                #Price Range
                                radioButtons('price', 'Price Range', c('$', '$$', '$$$', '$$$$', '$$$$$')),
                                actionButton('add', 'Find')
                            ),
                            
                            #display map
                            mainPanel(leafletOutput("mymap"),
                                      p()
                            ))
)
)
