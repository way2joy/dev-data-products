require(markdown)
library(shiny)
shinyUI(navbarPage(
    "Rossi Criminal Recidivism Dataset",
    tabPanel("Application",
        sidebarPanel(
            # Some form of input (widget: textbox, radio button, checkbox, ...)
            h4("Input covariate values for prediction"),
            helpText("Note: Input covariate values, and the ", 
                     "survival curve will be updated based on ",
                     "the input covariate values."),
            sliderInput("age", "Age", min = 17, max = 44, value = 25),
            checkboxInput("race", "Race is black", value=FALSE),
            checkboxInput("wexp", "Has work experience", value=FALSE),
            checkboxInput("mar", "Is married", value=FALSE),
            checkboxInput("paro", "Was released on parole", value=FALSE)
        ),
        mainPanel(
            tabsetPanel(
                tabPanel('Prediction', 
                    h4('Survival Prediction'),
                    tableOutput("values"),
                    h4('Predicted survival curve vs Baseline survival curve (age = 25 years, 0 for all other covariates)'),
                    # Some reactive output displayed as a result of server calculations
                    plotOutput('survplot')
                ),
                tabPanel('Weibull parametric survival regression model',
                    h4('Summary of fitted Weibull survival regression model'),
                    verbatimTextOutput("summary"),
                    
                    h4('Kaplan Meier estimator for whole population'),
                    plotOutput("kmplot")
                )
            )
        )
    ),
    tabPanel("About",mainPanel(includeMarkdown("README.md")))
))
