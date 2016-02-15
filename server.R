library(shiny)
library(ggplot2)
library(dplyr)
library(broom)
grouping <- c('cyl',"vs","am","gear")
varmap <- list ('Displacement' ='disp',
                'Gross horsepower'='hp',
                'Rear axle ratio'='drat',
                'Weight'='wt',
                '1/4 mile time'='qsec',
                'Number of carburetors'='carb')
groupmap <- list(
        'None'='none',
        #'Number of cylinders'='cyl',
        'V/S'='vs',
        'Transmission'='am')
##'Number of forward gears'='gear')
mainplot <- function(variable,group){
        plotmap <- ggplot(data=mtcars,aes_string(x=variable,y="mpg"))
        if (group == "none"){
                baseplot <- plotmap + geom_point(size=3,color="salmon")
        } else {
                baseplot <-plotmap + geom_point(aes_string(color=group),size=3) + facet_grid(paste0(".~",group))
        }
        baseplot + geom_smooth(method="lm")
        
}

my_group_by <- function(datatb,group){
        #Takes a data table and a character string
        if(group=='none'){
                return(datatb)
        }else{
                group_by_(datatb,group)
        }
}

#make these two variable categorical
mtcars <- mtcars %>% mutate(am=as.factor(am))%>%mutate(vs=as.factor(vs))
shinyServer(
        function(input,output){
                
                output$edaplot <- renderPlot({
                        mainplot(varmap[[input$variable]],groupmap[[input$groupby]])
                })
                output$modelplot <- renderPlot(
                        {
                                baseplot <- mtcars %>% 
                                        my_group_by(groupmap[[input$groupby]])%>%
                                        do(tidy(lm(as.formula(paste0("mpg~",varmap[[input$variable]])),data=.),conf.int=T))%>%
                                        ggplot(aes_string('term','estimate'))+
                                        geom_errorbar(aes(ymin=conf.low,ymax=conf.high))
                                if (groupmap[[input$groupby]]=="none"){
                                        baseplot + geom_point(color="salmon",size=3)
                                }else{
                                        baseplot + geom_point(aes_string(color=groupmap[[input$groupby]]),size=3)
                                }
                                
                        })
                output$residplot <- renderPlot(
                        {
                                baseplot <- mtcars  %>% 
                                        my_group_by(groupmap[[input$groupby]])%>%
                                        do(augment(lm(as.formula(paste0("mpg~",varmap[[input$variable]])),data=.)))%>%
                                        ggplot(aes_string(varmap[[input$variable]],'.resid')) +
                                        geom_hline(yintercept=0)
                                if (input$groupby=='None'){
                                        baseplot + geom_point(color='salmon',size=3)
                                }else{
                                        baseplot + facet_grid(paste0('.~',groupmap[[input$groupby]])) + 
                                        geom_point(aes_string(color=groupmap[[input$groupby]]),size=3)
                                }
                        }
                )
        }
)


