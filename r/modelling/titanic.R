# ----------------- Setup ------------------ #
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(ggplot2)
library(ggcorrplot)
library(tidyquant)
library(GGally)
library(tidymodels)
library(discrim)
library(kernlab)
library(brulee)
library(xgboost)

{ # Importing data ----
  
  train <- read_csv("./titanic_train_dataset.csv") %>%
    drop_na(Embarked) %>%
    mutate(Survived = as.factor(Survived))
  
  selected_features <- train %>% 
    dplyr::select(Survived, SibSp, Pclass, Parch, Fare, Sex, Embarked)

  data_recipe <-
    recipe(Survived ~ ., data = selected_features) %>%
    step_dummy(all_nominal_predictors()) %>%
    step_zv(all_predictors()) %>%
    step_normalize(all_predictors())

  model_result <- function(model) {
    selected_model <- switch(model,
      "lr" = logistic_reg(),
      "knn" = nearest_neighbor() %>%
        set_engine("kknn") %>%
        set_mode("classification"),
      "nb" = naive_Bayes(),
      "svc" = svm_linear(engine = "kernlab") %>%
        set_mode("classification"),
      "dt" = decision_tree() %>%
        set_mode("classification"),
      "bt" = boost_tree() %>%
        set_mode("classification")
    )

    titanic_workflow <-
      workflow() %>%
      add_model(selected_model) %>%
      add_recipe(data_recipe)

    folds <- vfold_cv(train, v = 10)

    res <- titanic_workflow %>%
      fit_resamples(folds) %>%
      collect_metrics()
  }
  
  all_models_results <- function() {
    all_models_workflows <-
      workflow_set(
        preproc = list(data_recipe),
        models = list(
          lr = logistic_reg(),
          knn = nearest_neighbor() %>%
            set_engine("kknn") %>%
            set_mode("classification"),
          nb = naive_Bayes(),
          svc = svm_linear(engine = "kernlab") %>%
            set_mode("classification"),
          dt = decision_tree() %>%
            set_mode("classification"),
          bt = boost_tree() %>%
            set_mode("classification")
        ),
      )
    
    
    folds <- vfold_cv(train, v = 10)
    
    res <- all_models_workflows %>%
      workflow_map(resamples = folds) %>%
      collect_metrics()
    
    return(res)
  }
  
}

{ # Header and Sidebar ----
  
  dashboard_header <- dashboardHeader(
    title = "Titanic Modelling"
  )
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("EDA", tabName = "eda", icon = icon("poll")),
      menuItem("Modelling", tabName = "modelling", icon = icon("poll"))
    )
  )
  
}

{ # Body ----

  { # EDA ----

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
      title = "train types",
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
        column(valueBoxOutput("male", width = 6), valueBoxOutput("female", width = 6), width = 12),
        column(plotOutput("survivors_by_sex"), width = 12)
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
        column(plotOutput("heatmap"), width = 12),
        column(plotOutput("pairplot"), width = 12)
      ),
      collapsible = TRUE,
      width = "100%"
    )
  }

  { # ML ----
    preprocessed_box <- box(
      status = "primary",
      title = "Pre-processed data",
      dataTableOutput("preprocessed_data"),
      collapsible = TRUE,
      width = "100%"
    )
  
    ml_box <- box(
      status = "primary",
      title = "Modelling",
      fluidRow(
        column(selectInput(
          "model", "Choose a model",
          c("Logistic Regression", "KNN", "Naive Bayes", "Linear Support Vector Machines", "Decision Tree", "Boost Tree")
        ), width = 6),
        column(column(h5("Results", style = "text-align:center;font-weight:bold"), dataTableOutput("model_result"), width = 12), width = 6)
      ),
      collapsible = TRUE,
      width = "100%"
    )
    
    all_models_box <- box(
      status = "primary",
      title = "All models",
      dataTableOutput("all_models_results"),
      collapsible = TRUE,
      width = "100%"
    )
  
  }
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
    ),
    tabItem(
      "modelling",
      preprocessed_box,
      ml_box,
      all_models_box
    )
  ))
)

server <- shinyServer(function(input, output) {
  { # EDA ----

    output$data <- DT::renderDataTable(train,
      server = TRUE,
      extensions = c("Scroller", "Responsive")
    )

    missing_values <- train %>%
      summarise_all(~ sum(is.na(.)))

    output$missing <- DT::renderDataTable(missing_values,
      server = TRUE,
      extensions = c("Scroller", "Responsive")
    )

    data_types <- train %>%
      summarise_all(class)

    output$train_types <- DT::renderDataTable(train_types,
      server = TRUE,
      extensions = c("Scroller", "Responsive")
    )

    not_survived <- train %>%
      filter(Survived == 0) %>%
      count()

    output$not_survived <- renderValueBox({
      valueBox(not_survived, "Non survivors", icon = icon("fire"), color = "red")
    })

    survived <- train %>%
      filter(Survived == 1) %>%
      count()

    output$survived <- renderValueBox({
      valueBox(survived, "Survivors", icon = icon("exclamation-triangle"), color = "green")
    })

    output$pclass <- renderPlot({
      ggplot(train, aes(x = Pclass)) +
        geom_histogram(aes(y = after_stat(density)), fill = "#24a0ed") +
        scale_fill_tq() +
        theme_tq(base_size = 16) +
        geom_density(alpha = .2, fill = "#24a0ed", size = 1) +
        labs(
          x = "Pclass",
          y = "Density",
        ) +
        theme(
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })

    female <- train %>%
      filter(Sex == "female") %>%
      count()

    output$female <- renderValueBox({
      valueBox(female, "Females", icon = icon("fire"), color = "aqua")
    })

    male <- train %>%
      filter(Sex == "male") %>%
      count()

    output$male <- renderValueBox({
      valueBox(male, "Males", icon = icon("exclamation-triangle"), color = "light-blue")
    })

    survivors_by_sex <- train %>%
      dplyr::select(Sex, Survived) %>%
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
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })

    output$survivors_by_sibsp <- renderPlot({
      ggplot(train, aes(x = SibSp)) +
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
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })

    output$survivors_by_parch <- renderPlot({
      ggplot(train, aes(x = Parch)) +
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
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })

    output$survivors_by_embarked <- renderPlot({
      ggplot(train, aes(x = Embarked)) +
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
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })

    age_fare <- train %>%
      dplyr::select(Age, Fare)

    corr_train <- age_fare %>%
      cor() %>%
      round(., 1)

    output$heatmap <- renderPlot({
      ggcorrplot(corr_train) +
        theme_tq(base_size = 16) +
        labs(
          title = "Correlation Matrix"
        ) +
        theme(
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
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
          axis.title.x = element_text(face = "bold", colour = "black"),
          axis.title.y = element_text(face = "bold", colour = "black"),
          axis.text.x = element_text(face = "bold", colour = "black"),
          axis.text.y = element_text(face = "bold", colour = "black")
        )
    })
  }
  
  { # ML ----
    
    data_recipe_baked <- data_recipe %>%
      prep(training = train) %>%
      bake(new_data = NULL)
  
    output$preprocessed_data <- DT::renderDataTable(data_recipe_baked,
      server = TRUE,
      extensions = c("Scroller", "Responsive")
    )
  
    model <- reactive({
      switch(input$model,
        "Logistic Regression" = "lr",
        "KNN" = "knn",
        "Naive Bayes" = "nb",
        "Linear Support Vector Machines" = "svc",
        "Decision Tree" = "dt",
        "Boost Tree" = "bt"
      )
    })
  
    output$model_result <- DT::renderDataTable(model_result(model()),
      server = TRUE,
      extensions = c("Scroller", "Responsive")
    )
    
    output$all_models_results <- DT::renderDataTable(all_models_results(),
                                               server = TRUE,
                                               extensions = c("Scroller", "Responsive")
    )
  
  }
})
shinyApp(ui, server)
