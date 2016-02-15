library(shiny)

shinyUI(fluidPage(
        titlePanel ("Let's model the mtcars dataset!"),
        tabsetPanel(
                tabPanel("HELP",h1("The explomtcars shiny app"),p("This shiny app provides the students with an interactive 
                                   way to understand simple linear regression and the statistical uncertainties
                                   associated with it using the mtcars dataset in datasets package as an example
                                   dataset."),
p("The user interface comprises of a menu area and a ploting area which in turn contains three 
tab panels and a panel for documentation (This README). The mpg values are used as the outcomes and one of six variables is used as the predictor 
in the simple regression. From the menu the user is able to select the predictor and separate the dataset by one of two variables. 
The user needs to click the Plot button to refresh the plots after making any changes from the menu. The first tab panel displays a scatter plot along with the regression line and its confidence interval for each subset of data. The second panel 
displays the residual plot for each subset of data. And the third panel displays two coefficients and their corresponding confidence 
intervals for each subset of data."),
                                 p("The server.R code uses the ggplot2 packges to generate the plots. 
The raw data and the values generated after simple regression are procesed and made tidy using 
the dplyr and broom packages.")
                                 ),
                tabPanel("Regression Plot",plotOutput('edaplot')),
                tabPanel("Residual Plot",plotOutput('residplot')),
                tabPanel("Model Plot",plotOutput('modelplot'))
        ),
        hr(),
        fluidRow(
                column(3,
                       radioButtons('variable','Select Variable',c('Displacement',
                                     'Gross horsepower',
                                     'Rear axle ratio',
                                     'Weight',
                                     '1/4 mile time',
                                     'Number of carburetors')
                )),
                column(3,
                       radioButtons('groupby','Separate By',c(
                               'None',
                               #'Number of cylinders',
                               'V/S',
                               'Transmission'
                              
                       ))      
                 ),
#                  column(3,
#                        radioButtons('model',"Select Model",
#                                     c("X",
#                                       "X^2")
#                                     ) 
#                         ),
                
                column(3,
                       h4("Click to refresh"),
                       submitButton("Plot"))
                
        )
))
