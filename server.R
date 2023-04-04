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


shinyServer(function(input, output, session){
  
  
  data <- reactive({
    file2 <- input$file1
    if(is.null(file2)){return()} 
    read.xlsx(input$file1$datapath)
    
  })
  
  output$cluster<-renderPlot({
    dataset=data.frame(data()$Age,data()$Revenue)
    dataset=scale(dataset)
    set.seed(29)
    kmeans = kmeans(x = dataset, centers = 5)
    y_kmeans = kmeans$cluster
    
    
    clusplot(dataset,
             y_kmeans,
             lines = 0,
             shade = TRUE,
             color = TRUE,
             labels = 2,
             plotchar = FALSE,
             span = TRUE,
             main = paste('Clusters of customers'),
             xlab = 'Age',
             ylab = 'Revenue')
    
    hc4 <- diana(dataset)
    #pltree(hc4, cex = 0.6, hang = -1, main = "Dendrogram of diana")
    #fviz_cluster(list(data = dataset, cluster = clust))
    
    
    
  })
  
  output$clus2<-renderPlot({
    dataset=data.frame(data()$Age,data()$Revenue)
    dataset=scale(dataset)
    hc4 <- diana(dataset)
    pltree(hc4, cex = 0.6, hang = -1, main = "Dendrogram of diana")
  })
  
  output$clus3<-renderPlot({
    dataset=data.frame(data()$Age,data()$Revenue)
    dataset=scale(dataset)
    hc4 <- diana(dataset)
    clust <- cutree(hc4, k = 5)
    fviz_cluster(list(data = dataset, cluster = clust))
    
  })
  
  output$goog<-renderPlotly({
    trends <- gtrends(input$key, gprop ="web",geo="HU", time = input$tarix )
    time_trend<-trends$interest_over_time
    plot<-plot_ly(y=time_trend$hits,x=time_trend$date,mode='lines',text = paste("Hits number"))
    #plot<-ggplot(data=time_trend, aes(x=date, y=hits,group=keyword,col=keyword))+
    #geom_line()+xlab('Time')+ylab('Relative Interest')+ theme_bw()+
    #theme(legend.title = element_blank(),legend.position="bottom",legend.text=element_text(size=12))+ggtitle("Google Search Volume")
    plot
    
  })
  
  # this reactive output contains the summary of the dataset and display the summary in table format
  output$filedf <- renderTable({
    if(is.null(data())){return ()}
    input$file
  })
  
  output$plot2<-renderPlotly({
    d<-table(data()$Gender)
    sal<-data.frame(cbind(d))
    USPersonalExpenditure <- data.frame("Gender"=rownames(sal), sal)
    data <- USPersonalExpenditure[,c('Gender', 'd')]
    
    fig <- plot_ly(data, labels = ~Gender, values = ~d, type = 'pie')
    fig <- fig %>% layout(title = 'Gender',
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$plot3<-renderPlotly({
    Number<-table(data()$Univerisity)
    sal1<-data.frame(cbind(Number))
    USPersonalExpenditure <- data.frame("Univerisity"=rownames(sal1), sal1)
    data <- USPersonalExpenditure[,c('Univerisity', 'Number')]
    
    fig <-plot_ly(data, x = ~Univerisity, y = ~Number, type = 'bar',
                  text = Number, textposition = 'auto',
                  marker = list(color = 'red',
                                line = list(color = 'red', width = 1.5)))
    fig <- fig %>% layout(title = 'Univerisity')
    #xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    #yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$plot4<-renderPlotly({
    Result<-table(data()$Program)
    sal2<-data.frame(cbind(Result))
    USPersonalExpenditure <- data.frame("Program"=rownames(sal2), sal2)
    data <- USPersonalExpenditure[,c('Program', 'Result')]
    
    fig <- plot_ly(data, x = ~Program, y = ~Result, type = 'bar')
    fig <- fig %>% layout(title = 'Program')
    #xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    #yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  output$plot5<-renderPlotly({
    number<-table(data()$Work)
    sal3<-data.frame(cbind(number))
    USPersonalExpenditure <- data.frame("Work"=rownames(sal3), sal3)
    data <- USPersonalExpenditure[,c('Work', 'number')]
    
    fig <- plot_ly(data, x= ~Work, y = ~number, type = 'bar')
    #fig <- fig %>% layout(title = 'Təhsil bölgüsü',
    #xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    #yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
  })
  
  output$dataset<-renderDataTable({
    
    data()
    
    
  })
  
  output$kmen<-renderDataTable({
    data<-data()
    analysis_date <- lubridate::as_date("2006-12-31", tz = "UTC")
    rfm<-rfm_table_order (data, data$customer_id, data$order_date, data$revenue, analysis_date)
    rfm$rfm
    
    
    
    
  })
  
  
  
  
  output$empsay <- renderInfoBox({
    infoBox(title = "Student number ",
            value = nrow(data()),
            fill = TRUE,color = "blue",icon = shiny::icon("user")) })
  
  output$meanage <- renderInfoBox({
    infoBox(title = "Average age ", 
            value = mean(data()$Age),
            fill = TRUE,color = "blue") })
  output$pul <- renderInfoBox({
    infoBox(title = "Total sales ", 
            value = sum(data()$Revenue),
            fill = TRUE,color = "blue") })  
  
}
) 