## Creates the UI elements for the Import Data Page
library(mlbench)


# Allows user to import data from a list of sample libraries
sample_import_box <- box(title = "Import a Sample Dataset",
                       collapsible = TRUE, id = "sample_box",
                       status = "info", width = 12,
                       fluidRow(
                         column(12, DT::dataTableOutput("sample_table")),
                         column(12, "Datasets come from the mlbench and kohonen library")
                       )
)

# Allows user to upload data from a CSV file
upload_box <- box(title = "Upload Dataset", status = "info", width = 12, 
                  fileInput("file", "Enter CSV file"), id = "file_box", collapsible = TRUE)


# Allows user to pick if they want to upload data or use a sample dataset
pick_box <- box(title = "Import Dataset", solidHeader = TRUE, status = "primary", width = 12,
                column(width = 12, align = "center",
                  bsButton("upload_selected", 
                           label = "Upload_Data", 
                           icon = icon("upload"),
                           style = "border-width: 0"),
                  bsButton("sample_selected", 
                           label = "Use Sample Dataset", 
                           icon = icon("spinner", class = "spinner-box"), 
                           style = "border-width: 0")
                )
               )

# Shows Import options
import_tab_item <- tabItem(tabName = "Import",
                           pick_box,
                           upload_box,
                           sample_import_box
)

