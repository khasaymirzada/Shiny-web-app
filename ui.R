library(shiny)
library(shinydashboard)
library(openxlsx)
library(plotly)
library(readxl)
library(plotly)
library(gtrendsR)
library(ggplot2)
library(googleway)
library(ggmap)
library(rfm)
library(magrittr)
library(dplyr)
library(lubridate)
library(gapminder)
library(factoextra)
library(cluster)

shinyUI(
  dashboardPage( skin = "red",
                 dashboardHeader(title = span(img("Data analysis app",align="left")), titleWidth = 320),
                 
                 
                 
                 dashboardSidebar(width = 320,
                                  
                                  sidebarMenu(
                                    menuItem(text = "About Company", tabName = "aut", icon=icon("building")),
                                    menuItem("Data upload", tabName = "data", icon=icon("database"), badgeLabel = "new", badgeColor = "green"),
                                    menuItem("Data visualization", tabName = "report", icon=icon("chart-pie")),
                                    menuItem("SMM support", tabName = "report1", icon=icon("google")),
                                    #menuItem("Pie Chart", tabName = "report2", icon=icon("chart-pie")),
                                    menuItem("DataStat youtube channel",  href = "https://www.youtube.com/channel/UCENmzuVMSkmPkTyMOMySYMw", icon=icon("youtube")),
                                    menuItem("Clustering customer",tabName = "clus",icon=icon("funnel-dollar")),
                                    menuItem("Contact",tabName = "con",icon=icon("file-contract"),
                                             menuSubItem("If you want add more function then write mail:",tabName = "con"),
                                             menuSubItem("xasay37@gmail.com",tabName = "con"))
                                    
                                    # https://fontawesome.com/icons?d=gallery
                                  )
                 ),
                 
                 
                 dashboardBody(
                   tabItems(
                     tabItem(tabName = "aut", h1("The DataStat course has been operating since 2019. Our center teaches data science and analytics. To date, 60 people have benefited from our classes.
Classes include Statistics, R programming language, Tableau and SQL.")),
                     tabItem(tabName = "data", fileInput("file1", "Please upload your data:",
                                                         multiple = FALSE,
                                                         accept = c("text/excel",
                                                                    "text/comma-separated-values,text/plain",
                                                                    ".xlsx")),
                             
                             
                             
                             tags$hr()),
                     tabItem(tabName = "clus", plotOutput("cluster"),plotOutput("clus2"),plotOutput("clus3")),
                     tabItem(tabName = "report", tabBox(title = "Data visualization",
                                                        tabPanel("Vizual 1","",fluidRow(infoBoxOutput("empsay",width = 7),infoBoxOutput("meanage",width = 7),infoBoxOutput("pul",width = 7))),
                                                        tabPanel("Bar","", plotlyOutput("plot2")),
                                                        tabPanel("Pie","",plotlyOutput("plot3")),
                                                        tabPanel("Plot4","",plotlyOutput("plot4")),
                                                        tabPanel("Plot5","",plotlyOutput("plot5"))
                                                        
                     )),
                     tabItem(tabName = "report1", plotlyOutput("goog"),textInput("key","Enter the keyword:"),textInput("tarix","Enter date interval (Year-Month-Day):"))
                     
                   ))))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        