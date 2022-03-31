# R Shiny for Clustering

The R Shiny SOM app provides a user interface for visualizing Self-Organizing Maps (SOMs).

## Table of contents

* [Installation](#installation)
* [Overview](#overview)
* [Credits](#credits)

## Installation

 1. Clone the repository

    This can be done from the Github website or with bash
	```    
	$ git clone https://github.com/emalderson/ThePhish.git
	```
   
 2. Make sure R is Installed

    You can install the r package [here](https://www.r-project.org/).

 3. Install the requirements

    Within R, you want to use the `install.packages()` function to download packages. The following packages need to be installed.

     - `shiny`
     - `shinyjs`
     - `shinyBS`
     - `shinydashboard`
     - `shinydashboardPlus`
     - `shinyBS`
     - `kohonen`
     - `DT`
     - `dplyr`
     - `mlbench`
     - `RColorBrewer`

    There is a requirements.R file you can run to install all of the necessary libraries

 4. Open the app

    To open the app you have to run the main file. 

## Overview

Once started up, there are three tabs in the app that navigate the user through the three main windows.

### Introduction

The *Introduction* tab is the starting tab the app opens up on. Here the user is introduced to the purpose of this application, given general directions on how to use it, and given descriptions of the plots that it produces.

### Import Data

The *Import Data* tab opens the Import Data window. This is where users are given the option to upload their own data by selecting the option Upload Data, or explore the app with data provided in the app by selecting Use Sample Data.

### Visualize Data

The *Visualize Data* tab opens the Visualize Data window. Here the user selects the variables of interest and sets the various SOM parameter values as desired. The graphics produced by the SOM app are automatically displayed in this window. Illustrations of choices in this window appear in the following complete example.

## Credits

The idea of preparing an R Shiny app was conceived by Olcay Akman and Christopher Hay-Jahans at the 2021 IBA CURE workshop. Zury Betzab-Marroquin, Joshua Walsh and Trenton Wesley conducted preliminary research into the topics of clustering and self-organizing maps. Trenton Wesley then branched into R Shiny and the actual coding of the app, and Zury Betzab-Marroquin and Joshua Walsh focused on the theoretical and quantitative background material. Olcay Akman and Christopher Hay-Jahans served as mentors for this project, providing periodic guidance in conducting research, coding, and writing.