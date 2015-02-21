library(shiny)
library(survival)

# Read dataset
rossi <- read.table("Rossi.txt", header=T)
rossi <- rossi[c("week", "arrest", "fin", "age", "race", "wexp", "mar", "paro")] # only keep subset of variables

tmax <- max(rossi$week)

# Helper function to plot Weibull hazard function
Weibh <- function(t, lambda, kappa) lambda*kappa*t^(kappa-1)
# Helper function to plot Weibull survival function
WeibS <- function(t, lambda, kappa) exp(-lambda*t^kappa)

# just a quick KM for the entire population
fit <- survfit(Surv(week, arrest)~1,data= rossi,conf.type="log-log")

# Fit Weibull 
mod_weib <- survreg(Surv(week, arrest)~fin + age + race + wexp + mar + paro, dist="weib", data=rossi)
kappa0 <- 1/mod_weib$scale
lambda0 <- exp(-mod_weib$coef['(Intercept)']*kappa0)
beta_age <- -mod_weib$coef[['age']]
beta_race <- mod_weib$coef[['race']]
beta_wexp <- mod_weib$coef[['wexp']]
beta_mar <- mod_weib$coef[['mar']]
beta_paro <- mod_weib$coef[['paro']]

shinyServer(
    function(input, output) {
        # KM fit of whole population
        output$kmplot <- renderPlot({
            plot(fit, main="KM estimator of survival function for whole population", ylab="S(t)", xlab="Time (in weeks)") # follow-up up to around 50 weeks, around 20% fails (gets arrested)
        })

        output$survplot <- renderPlot({
            # baseline of aged 25 yrs with all other covars equal to zero
            curve(WeibS(x, lambda = lambda0*exp((beta_age*25)*kappa0), kappa = kappa0), col = "purple", 
                  ylim = c(0,1), xlim = c(0,tmax),
                  ylab = "S(t)", xlab = "Time")
            # Predicted curve
            curve(WeibS(x, 
                        lambda = lambda0*exp((beta_age*input$age+beta_race*input$race+beta_wexp*input$wexp+beta_mar*input$mar+beta_paro*input$paro)*kappa0), 
                        kappa = kappa0), col = 1, lwd = 1, add=T)
             legend("bottomleft", legend = c("Baseline", "Prediction"), col = c("purple",1), lwd = 1)
        })

        # summary of fitted Weibull regression model
        output$summary <- renderPrint({
            summary(mod_weib)
        })
        
        # Covariate values from input widgets for prediction
        covarValues <- reactive({
            # Compose data frame
            data.frame(
                Name = c("Age", "Race", "Work Experience", "Married", "Released on parole"),
                Value = as.character(c(paste(input$age, "years", sep=" "),
                                       ifelse(input$race, "Black", "Not Black"), 
                                       ifelse(input$wexp, "Has work experience", "No work experience"), 
                                       ifelse(input$mar, "Married", "Not married"), 
                                       ifelse(input$paro, "Released on parole", "Not released on parole"))), 
                stringsAsFactors=FALSE)
        }) 
        
        # Show the values using an HTML table
        output$values <- renderTable({
            covarValues()
        }) 
    }
)