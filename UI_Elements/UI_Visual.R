## Creates the UI elements for the Visualization Page

# Shows a preview of the dataset by showing the first 6 entries in a table
preview_box <- box(title = "Preview Dataset", status = "primary", width = 12,
                   column(12, DT::dataTableOutput("input_table"), style = "overflow-y: scroll"))

# Shows a list of settings that the user can change to get different plots
SOM_option_box <- box(title = "SOM Options", status = "info", width = 12,
                    useShinyjs(),
                    uiOutput("columns"),
                    uiOutput("size"),
                    checkboxInput("is_cluster", "Show Clusters", FALSE),
                    uiOutput("clusters"),
                    uiOutput("clusters_button"),
                    checkboxInput("is_toroidal", "Toroidal", TRUE),
                    actionButton("retrain_SOM", "Retrain SOM", style = "border-width: 0; 
                                 background-color: #659EC7; color: #FFFFFF"),
                    collapsible = TRUE
                    )
advanced_option_box <- box(title = "Advanced Options", status = "info", width = 12,
                           fluidRow(
                             column(12, "SOM"),
                             column(12, "Visuals"),
                             column(12, "Downloads")
                           ),
                          collapsible = TRUE, collapsed = TRUE)

# Shows mapping SOM plots
mapping_box <- tabBox(
  title = "Mapping Plots",
  # The id lets us use input$mapping on the server to find the current tab
  id = "mapping", width = 12,
  tabPanel("Colorless", textInput("colorless_name", "Enter the title of the plot"), 
           checkboxInput("is_colorless_label", "Show Labels", FALSE), uiOutput("colorless_labels"), 
           plotOutput("no_colors"), downloadButton("save_colorless")),
  tabPanel("Class", textInput("class_name", "Enter the title of the plot"), 
           uiOutput("class_labels"), plotOutput("class"), downloadButton("save_class")),
  tabPanel("Continuous", textInput("continuous_name", "Enter the title of the plot"), 
           plotOutput("continuous"), downloadButton("save_continuous"))
)

# Shows secondary plots of the SOM
analysis_box <- tabBox(
  title = "Analysis Plots",
  # The id lets us use input$mapping on the server to find the current tab
  id = "analysis", width = 12,
  tabPanel("Counts", textInput("counts_name", "Enter the title of the plot"), plotOutput("counts"), 
           downloadButton("save_counts")),
  tabPanel("Neighbourhood Distance", textInput("distance_name", "Enter the title of the plot"), 
           plotOutput("distance"), downloadButton("save_distance")),
  tabPanel("Codes", textInput("codes_name", "Enter the title of the plot"), plotOutput("codes"), 
           downloadButton("save_codes"))
)
#
visual_tab_item <- tabItem(tabName = "Visual",
                           fluidRow(preview_box,
                                    SOM_option_box,
                                    #advanced_option_box,
                                    mapping_box,
                                    analysis_box)
)