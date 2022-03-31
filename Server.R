source("SOM.R")

## Constants
MAX_PREVIEW_ROWS = 6

## Set up Server elements
server <- function(input, output, session) {
  
  # Decides what data to use from Import Tab
  import_type <- reactiveVal("NULL")
  
  preview_activated <- reactiveVal(FALSE)
  select_activated <- reactiveVal(FALSE)
  
  ## -----------------------------------------------------------------------------------------------
  ## Helper Functions and Reactives
  ## -----------------------------------------------------------------------------------------------
  
  # Gets file data
  get_upload_data <- reactive({
    # Shows by default until a upload is successful
    updateBox("file_box", action = "update", options = list(status = "danger"))
    
    # Get File
    file <- input$file
    ext <- tools::file_ext(file$datapath)
    
    # Checks if file is a csv file
    validate(need(ext == "csv", "Please upload a csv file"))
    
    req(file)
    
    # Show that upload was a success
    updateBox("file_box", action = "update", options = list(status = "success"))
    
    # Gives us our dataset
    read.csv(file$datapath)
  })
  
  # Gets sample dataset
  get_sample_data <- reactive({
    # Get name of dataset
    name <- sample_datasets[input$sample_table_rows_selected]
    # Get dataset
    data(list = name)
    get(name)
  })
  
  # Gets dataset
  get_dataset <- reactive({
    input_data <- NULL
    if(import_type() == "upload") {
      input_data <- get_upload_data()
    } else if(import_type() == "sample") {
      input_data <- get_sample_data()
    }
    # Checks to see if there is data
    validate(need(!is.null(input_data), "Please import data in the Import Tab"))
    # Return Data
    input_data
  })
  
  # Gets SOM
  som <- reactive({
    input$retrain_SOM
    # Checks to see if there is any columns selected
    validate(need(!is.null(input$columns), "Please select the columns to use in SOM"))
    # Get data
    data <- get_dataset()[input$columns]
    create_SOM(input = data, length = input$size, width = input$size, toroidal = input$is_toroidal)
  })
  
  # Gets Number of clusters 
  clusters <- reactive({
    if(input$is_cluster) input$clusters else NULL
  })
  
  # Plots different types of SOM maps
  plot_SOM <- function(plot_type){
    # Get data
    dataset <- get_dataset()
    # Get SOM
    som <- som()
    # True if we are plotting an analysis plot
    is_analysis <- F
    
    # Set type specific parameters
    if (plot_type == "class") {
      # Set Title
      title <- if(input$class_name != "") input$class_name else "Class Representation Map"
      # Set Labels
      labels <- dataset[, input$class_labels]
      # Set Type
      type <- plot_type
    } else if (plot_type == "continuous") {
      # Set Title
      title <- if(input$continuous_name != "") input$continuous_name else "Continuous Response Map"
      # Set Labels
      labels <- NULL
      # Set Type
      type <- plot_type
    } else if (plot_type == "colorless") {
      # Set Title
      title <- if(input$colorless_name != "") input$colorless_name else "Colorless Mapping Plot"
      # Set Labels
      labels <- if(input$is_colorless_label) dataset[, input$colorless_labels] else NULL
      # Set Type
      type <- ""
    } else if (plot_type == "counts") {
      # Indicate that we are plotting an analysis plot
      is_analysis <- T
      # Set Title
      title <- if(input$counts_name != "") input$counts_name else "Counts Plot"
      # Set Type
      type <- plot_type
    } else if (plot_type == "distance") {
      # Indicate that we are plotting an analysis plot
      is_analysis <- T
      # Set Title
      title <- if(input$distance_name != "") input$distance_name else "Neighborhood Distance Plot"
      # Set Type
      type <- "dist.neighbour"
    } else if (plot_type == "codes") {
      # Indicate that we are plotting an analysis plot
      is_analysis <- T
      # Set Title
      title <- if(input$codes_name != "") input$codes_name else "Codes Plot"
      # Set Type
      type <- plot_type
    }
    
    # Display plot
    if (is_analysis) {
      display_analysis_plot(som_model = som, type = type, clusters = clusters(), title = title)
    } else{
      display_mapping_plot(som_model = som, type = type, title = title, 
                           clusters = clusters(), labels = labels)
    }
  }
  
  ## -----------------------------------------------------------------------------------------------
  ## Updates and Initializes Visualization tab features and options
  ## -----------------------------------------------------------------------------------------------
  
  # Checks for file input and then creates selectInput
  observeEvent(input$file,{
    # Go to next tab
    if(import_type() == "upload") updateTabItems(session, "tabs", "Visual")
  })
  
  # Loads data in Visualization tab
  load_data <- reactive({
    # Get dataset from file
    dataset <- get_dataset()
    # Add options based on dataset
    output$columns = renderUI(selectInput("columns", "Which columns do you want to use?", 
                                          choices = names(dataset), multiple = TRUE))
    output$size = renderUI(sliderInput("size", "Enter the SOM size", min = 1, 
                                       max = floor(sqrt(nrow(dataset))), value = 5))
    output$clusters = renderUI(sliderInput("clusters", "Enter the number of clusters", min = 2, 
                                           max = 20, 
                                           value = 3))
    output$clusters_button = renderUI(actionButton("clusters_button", "Use Suggested Number of Clusters"))
    output$colorless_labels = renderUI(selectInput("colorless_labels", "What column do you want to use to label the dataset?", 
                                         choices = names(dataset)))
    output$class_labels = renderUI(selectInput("class_labels", "What column do you want to use to label the dataset?", 
                                                   choices = names(dataset)))
  })
  
  # Show the "labels" selectInput only is the checkbox for it is checked
  observeEvent(input$is_colorless_label, {
    if(input$is_colorless_label) show(id = "colorless_labels") else hide(id = "colorless_labels")
  })
  
  # Show the "clusters" sliderInput only is the checkbox for it is checked
  observeEvent(input$is_cluster, {
    if(input$is_cluster){
      show(id = "clusters")
      show(id = "clusters_button")
    } else {
      hide(id = "clusters")
      hide(id = "clusters_button")
    }
  })
  
  # If clusters_button is pressed, find the optimal amount of clusters and set cluster count to that
  observeEvent(input$clusters_button, {
    # Get data
    dataset <- get_dataset()[input$columns]
    # Validate data
    validate(need(sum(ncol(dataset)) >= 3, "Not enough columns selected! Need atleast 3 columns of data..."))
    validate(need(sum(is.na(dataset)) == 0, "There are some missing values from the dataset!"))
    validate(need(is.double(unlist(dataset)), "Data is not numeric!"))
    # Find optimal amount of clusters
    optimal_cluster_count <- find_optimal_clusters(dataset)
    # Set cluster amount
    updateSliderInput(session, inputId = "clusters", value = optimal_cluster_count)
  })
  
  # Renders Data Table
  output$input_table <- DT::renderDataTable({
    load_data()
    dataset <- get_dataset()
    preview_data <- dataset[1:min(nrow(dataset), MAX_PREVIEW_ROWS),]
    # Render datatable
    DT::datatable(preview_data, options = list(dom = 't'), selection = list(target = 'column'))
  })
  
  ## -----------------------------------------------------------------------------------------------
  ## Render Plots
  ## -----------------------------------------------------------------------------------------------
  
  # Renders Class Representation Map
  output$class <- renderPlot({
    plot_SOM("class")
  })
  
  # Renders Continuous SOM Plot
  output$continuous <- renderPlot({
    plot_SOM("continuous")
  })
  
  # Renders colorless SOM Plot
  output$no_colors <- renderPlot({
    plot_SOM("colorless")
  })
  
  # Renders Counts Plot
  output$counts <- renderPlot({
    plot_SOM("counts")
  })
  
  # Renders Neighbourhood Distance Plot
  output$distance <- renderPlot({
    plot_SOM("distance")
  })
  
  # Renders Codes Plot
  output$codes <- renderPlot({
    plot_SOM("codes")
  })
  
  # Gets sample datasets
  sample_datasets <- rbind(c("iris", "Dataset of Three Species of Iris"), 
                           #c("wines", "Dataset of Wines grown in Italy"),
                           data(package = "mlbench")[["results"]][, 3:4][c(3,10,16,17),])
  
  # Renders table of sample datasets
  output$sample_table <- DT::renderDataTable({
    # Get sample datasets
    DT::datatable(sample_datasets, options = list(dom = 't'),
                  selection = list(mode = "single", selected = 1, target = 'row'))
  })

  # Checks to see if Option to Upload Data was selected in Import Tab
  observeEvent(input$upload_selected, {
    # Show which button is selected
    updateButton(session = session, inputId = "upload_selected", style = "success")
    updateButton(session = session, inputId = "sample_selected", style = "border-width: 0")
    # Show which box is selected
    updateBox("file_box", action = "update", options = list(status = "success"))
    updateBox("sample_box", action = "update", options = list(status = "info"))
    # Collapse the unused boxes
    if (input$file_box$collapsed) updateBox("file_box", action = "toggle")
    if (!input$sample_box$collapsed) updateBox("sample_box", action = "toggle")
    # Change import type
    import_type("upload")
  })
  
  # Checks to see if Option to Use Sample Dataset was selected in Import Tab
  observeEvent(input$sample_selected, {
    # Show which button is selected
    updateButton(session = session, inputId = "sample_selected", style = "success")
    updateButton(session = session, inputId = "upload_selected", style = "border-width: 0")
    # Show which box is selected
    updateBox("sample_box", action = "update", options = list(status = "success"))
    updateBox("file_box", action = "update", options = list(status = "info"))
    # Collapse the unused boxes
    if (input$sample_box$collapsed) updateBox("sample_box", action = "toggle")
    if (!input$file_box$collapsed) updateBox("file_box", action = "toggle")
    # Change import type
    import_type("sample")
  })
  
  ## -----------------------------------------------------------------------------------------------
  ## Connects the preview table with the select columns options
  ## -----------------------------------------------------------------------------------------------

  onclick("columns", {
    select_activated(TRUE)
  })
  onevent("mouseenter", id = "input_table", {
    preview_activated(TRUE)
  })
  observeEvent(input$input_table_columns_selected, {
    if (preview_activated()) {
      select_activated(FALSE)
      # Get data
      dataset <- get_dataset()
      # Get column names
      column_names <- names(dataset)[input$input_table_columns_selected]
      # Update selected columns in settings box
      updateSelectInput(session, inputId = "columns", selected = column_names)
    }
  }, ignoreNULL = F)
  observeEvent(input$columns, {
    if (select_activated()) {
      preview_activated(FALSE)
      # Get data
      dataset <- get_dataset()
      # Get the numbers of the selected columns
      column_nums <- match(input$columns, names(dataset))
      # Update selected columns in the preview box
      proxy <- dataTableProxy("input_table", session)
      DT::selectColumns(proxy, selected = column_nums)
    }
  }, ignoreNULL = F)
  
  ## -----------------------------------------------------------------------------------------------
  ## Save plots
  ## -----------------------------------------------------------------------------------------------
  
  # Save Colorless Mapping Plot
  output$save_colorless <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("colorless")
      dev.off()
    }
  )
  # Save Class Representation Map
  output$save_class <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("class")
      dev.off()
    }
  )
  # Save Continuous Response Map
  output$save_continuous <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("continuous")
      dev.off()
    }
  )
  # Save Counts Plot
  output$save_counts <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("counts")
      dev.off()
    }
  )
  # Save Distance Plot
  output$save_distance <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("distance")
      dev.off()
    }
  )
  # Save Codes Plots
  output$save_codes <- downloadHandler(
    filename = "plot.png",
    content = function(file) {
      png(file)
      plot_SOM("codes")
      dev.off()
    }
  )
}