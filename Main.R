# Import Libraries
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(shinyBS)
library(DT)
library(dplyr)

# Import R Scripts
source("UI_Elements/UI_Sidebar.R")
source("UI_Elements/UI_Body.R")
source("Server.R")

# Create Header
header <- dashboardHeader(title = "Self Organizing Map")

# Combine UI elements
ui <- dashboardPage(
  header,
  sidebar,
  body
)

shinyApp(ui, server)
