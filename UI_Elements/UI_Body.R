## Creates body of dashboard
# Welcome Page
source("UI_Elements/UI_Welcome.R")
# Introduction
source("UI_Elements/UI_Intro.R")
# Import Data
source("UI_Elements/UI_Import.R")
# Visualization
source("UI_Elements/UI_Visual.R")

## Create Body
body <- dashboardBody(
  tabItems(
    #welcome_tab_item,
    intro_tab_item,
    import_tab_item,
    visual_tab_item
  )
)