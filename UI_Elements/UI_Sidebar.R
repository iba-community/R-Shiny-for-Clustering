# Create Sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "tabs",
    HTML("<br>"),
    tags$img(src = "logo.png", height = 90, width = 90, style = "display: block; margin-left: auto; margin-right: auto;"),
    HTML("<br>"),
    #menuItem("Welcome", tabName = "Welcome", icon = icon("child")),
    menuItem("Introduction", tabName = "Introduction", icon = icon("question")),
    menuItem("Import Data", tabName = "Import", icon = icon("folder")),
    menuItem("Visualize Data", tabName = "Visual", icon = icon("chart-bar"))
  )
)