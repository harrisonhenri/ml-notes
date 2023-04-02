# ----------------- Setup ------------------ #
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(ggplot2)
library(ggcorrplot)
library(tidyquant)
library(GGally)

{ # Importing data ----
  data <- read_csv("./titanic_dataset.csv")
}

{ # Header and Sidebar ----
  dashboard_header <- dashboardHeader(
    title = "Titanic EDA"
  )
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("EDA", tabName = "eda", icon = icon("poll"))
    )
  )
}

{ # Body ----
  data_box <- box(
    status = "primary",
    title = "Taking a look into the data",
    dataTableOutput("data"),
    collapsible = TRUE,
    width = "100%"
  )

  missing_values <- box(
    status = "primary",
    title = "Missing values",
    dataTableOutput("missing"),
    collapsible = TRUE,
    width = "100%"
  )

  data_types <- box(
    status = "primary",
    title = "Data types",
    dataTableOutput("data_types"),
    collapsible = TRUE,
    width = "100%"
  )

  feature_survived <- box(
    status = "primary",
    title = "Feature: Survived",
    fluidRow(
      valueBoxOutput("survived", width = 6),
      valueBoxOutput("not_survived", width = 6)
    ),
    collapsible = TRUE,
    width = "100%"
  )

  feature_pclass <- box(
    status = "primary",
    title = "Feature: Pclass",
    plotOutput("pclass"),
    collapsible = TRUE,
    width = "100%"
  )

  feature_sex <- box(
    status = "primary",
    title = "Feature: Sex",
    fluidRow(
      column(valueBoxOutput("male", width = 6),valueBoxOutput("female", width = 6), width=12),
      column(plotOutput("survivors_by_sex"), width=12)
    ),
    collapsible = TRUE,
    width = "100%"
  )
  
  feature_sibsp <- box(
    status = "primary",
    title = "Feature: SibSp",
    plotOutput("survivors_by_sibsp"),
    collapsible = TRUE,
    width = "100%"
  )
  
  feature_parch <- box(
    status = "primary",
    title = "Feature: Parch",
    plotOutput("survivors_by_parch"),
    collapsible = TRUE,
    width = "100%"
  )
  
  feature_embarked <- box(
    status = "primary",
    title = "Feature: Embarked",
    plotOutput("survivors_by_embarked"),
    collapsible = TRUE,
    width = "100%"
  )
  
  heatmap_pairplot <- box(
    status = "primary",
    title = "HeatMap Pairplot",
    fluidRow(
      column(plotOutput("heatmap"), width=12),
      column(plotOutput("pairplot"), width=12)
    ),
    collapsible = TRUE,
    width = "100%"
  )
}

ui <- dashboardPage(
  dashboard_header,
  sidebar,
  dashboardBody(tabItems(
    tabItem(
      "eda", 
      data_box, 
      missing_values,
      data_types,
      feature_survived,
      feature_pclass,
      feature_sex,
      feature_sibsp,
      feature_parch,
      feature_embarked,
      heatmap_pairplot
    )
  ))
)

server <- shinyServer(function(input, output) {
  output$data <- DT::renderDataTable(data,
    server = TRUE,
    extensions = c("Scroller", "Responsive")
  )

  missing_values <- data %>%
    summarise_all(~ sum(is.na(.)))

  output$missing <- DT::renderDataTable(missing_values,
    server = TRUE,
    extensions = c("Scroller", "Responsive")
  )

  data_types <- data %>%
    summarise_all(class)

  output$data_types <- DT::renderDataTable(data_types,
    server = TRUE,
    extensions = c("Scroller", "Responsive")
  )

  not_survived <- data %>%
    filter(Survived == 0) %>%
    count()

  output$not_survived <- renderValueBox({
    valueBox(not_survived, "Non survivors", icon = icon("fire"), color = "red")
  })

  survived <- data %>%
    filter(Survived == 1) %>%
    count()

  output$survived <- renderValueBox({
    valueBox(survived, "Survivors", icon = icon("exclamation-triangle"), color = "green")
  })

  output$pclass <- renderPlot({
    ggplot(data, aes(x = Pclass)) +
      geom_histogram(aes(y = after_stat(density)), fill = "#24a0ed") +
      scale_fill_tq() +
      theme_tq(base_size = 16) +
      geom_density(alpha = .2, fill = "#24a0ed", size=1) +
      labs(
        x = "Pclass",
        y = "Density",
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })

  female <- data %>%
    filter(Sex == "female") %>%
    count()

  output$female <- renderValueBox({
    valueBox(female, "Females", icon = icon("fire"), color = "aqua")
  })

  male <- data %>%
    filter(Sex == "male") %>%
    count()

  output$male <- renderValueBox({
    valueBox(male, "Males", icon = icon("exclamation-triangle"), color = "light-blue")
  })
  
  survivors_by_sex <- data %>%
    select(Sex, Survived) %>%
    mutate(Sex = case_when(Sex == "female" ~ 1, Sex == "male" ~ 0))
  
  output$survivors_by_sex <- renderPlot({
    ggplot(survivors_by_sex, aes(x = Sex)) +
      geom_histogram(aes(y = after_stat(density), fill = factor(Survived)), position = "dodge") + 
      scale_fill_manual(values = c("#ff851b", "#3c8dbc")) +
      theme_tq(base_size = 16) +
      geom_density(aes(fill = factor(Survived)), alpha = .4) +
      labs(
        x = "Sex",
        y = "Density",
        fill = "Survived"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
  
  output$survivors_by_sibsp <- renderPlot({
    ggplot(data, aes(x = SibSp)) +
      geom_histogram(aes(y = after_stat(density), fill = factor(Survived)), position = "dodge") + 
      scale_fill_manual(values = c("#ff851b", "#3c8dbc")) +
      theme_tq(base_size = 16) +
      geom_density(aes(fill = factor(Survived)), alpha = .4) +
      labs(
        x = "SibSp",
        y = "Density",
        fill = "Survived"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
  
  output$survivors_by_parch <- renderPlot({
    ggplot(data, aes(x = Parch)) +
      geom_histogram(aes(y = ..density.., fill = factor(Survived)), position = "dodge") + 
      scale_fill_manual(values = c("#ff851b", "#3c8dbc")) +
      theme_tq(base_size = 16) +
      geom_density(aes(fill = factor(Survived)), alpha = .4) +
      labs(
        x = "Parch",
        y = "Density",
        fill = "Survived"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
  
  output$survivors_by_embarked <- renderPlot({
    ggplot(data, aes(x = Embarked)) +
      geom_bar(aes(fill = factor(Survived)), position = "dodge") + 
      scale_fill_manual(values = c("#ff851b", "#3c8dbc")) +
      theme_tq(base_size = 16) +
      coord_flip() + 
      labs(
        x = "Embarked",
        y = "Count",
        fill = "Survived"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
  
  age_fare <- data %>% 
    select(Age, Fare) 
  
  corr_data <- age_fare %>% 
    cor() %>% 
    round(.,1)
  
  output$heatmap <- renderPlot({
    ggcorrplot(corr_data) + 
      theme_tq(base_size = 16) +
      labs(
        title = "Correlation Matrix"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
  
  output$pairplot <- renderPlot({
    ggpairs(age_fare) + 
      theme_tq(base_size = 16) +
      coord_flip() + 
      labs(
        title = "Pair plot"
      ) +
      theme(
        axis.title.x = element_text(face="bold", colour = "black"),    
        axis.title.y = element_text(face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"),    
        axis.text.y = element_text(face="bold", colour = "black")
      )
  })
})
shinyApp(ui, server)
