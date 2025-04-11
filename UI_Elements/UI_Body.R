## Creates body of dashboard

# Introduction
source("UI_Elements/UI_Intro.R")

# Import Data
source("UI_Elements/UI_Import.R")

# Visualization
source("UI_Elements/UI_Visual.R")

## Create Body
body <- dashboardBody(
  tabItems(
    intro_tab_item,
    import_tab_item,
    visual_tab_item
  )
)