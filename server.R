require(rCharts)
require(googleVis)

shinyServer(function(input, output) {
  
  views <- as.numeric(read.table("viewFile.txt", header = FALSE)[1, 1]) + 1
  write(views, file = "viewFile.txt")
  
  output$count <- renderText({
    paste("Views:", views, sep = " ")
  })
  
  output$yearChart <- renderChart({
    sport <- "NBA"
    year <- input$year
    
    yearDataSet <- read.csv(paste("~/ShinyApps/team-ratings/Data/", sport, "_Year.csv", sep = ""), header = TRUE, sep = ",")
    yearDataSet <- yearDataSet[which(yearDataSet$Year == year), ]
    sportMin <- floor(min(yearDataSet$Lower.Bound)/2) * 2
    sportMax <- ceiling(max(yearDataSet$Upper.Bound)/2) * 2
    
    if (input$sortTeam == "rating") {
      yearDataSet <- yearDataSet[order(yearDataSet$Rating, decreasing = TRUE), ]
    }
    
    h1 <- Highcharts$new()
    h1$chart(borderWidth = 0, height = 680, width = 760)
    
    h1$title(text = paste(sport, " Team Ratings: ", year, sep = ""))
    h1$yAxis(title = list(text = "Adjusted Margin of Victory"), tickInterval = 2, min = sportMin, max = sportMax)
    
    h1$tooltip(shared = TRUE)
    h1$legend(enabled = FALSE)
    
    h1$xAxis(categories = as.list(yearDataSet$Team.Name))
    h1$series(name = "Rating", type = "bar", data = as.list(yearDataSet$Rating), 
              tooltip = list(pointFormat = "<b>{series.name}:</b> {point.y:.3f}<br>"))
    
    intervalWidths <- list()
    for (team in 1:nrow(yearDataSet)) {
      intervalWidths[[team]] <- c(yearDataSet[team, 5], yearDataSet[team, 6])
    }
    h1$series(name = "Range", type = "errorbar", color = "#0038A8", whiskerLength = "40%", 
              lineWidth = "1.25", data = intervalWidths, 
              tooltip = list(pointFormat = "<b>{series.name}:</b> ({point.low: .3f}, {point.high: .3f})"))
    
    h1$set(dom = 'yearChart')
    return(h1)
  })
  
  output$homeChart <- renderChart({
    sport <- "NBA"
    
    homeDataSet <- read.csv(paste("~/ShinyApps/team-ratings/Data/", sport, "_Home.csv", sep = ""), header = TRUE, sep = ",")
    homeDataSet <- homeDataSet[-which(homeDataSet$Team == "Brooklyn Nets"), ]
#    sportMin <- floor(min(homeDataSet$Lower.Bound)/2) * 2
    sportMin <- 0
    sportMax <- ceiling(max(homeDataSet$Upper.Bound)/2) * 2
    
    if (input$sortHome == "rating") {
      homeDataSet <- homeDataSet[order(homeDataSet$Rating, decreasing = TRUE), ]
    }
    
    h3 <- Highcharts$new()
    h3$chart(borderWidth = 0, height = 800, width = 760)
    
    h3$title(text = paste(sport, " Team Homecourt Advantages", sep = ""))
    h3$yAxis(title = list(text = "Homecourt Benefit (Points)"), tickInterval = 1, min = sportMin, max = sportMax)
    
    h3$tooltip(shared = TRUE)
    h3$legend(enabled = FALSE)
    
    h3$xAxis(categories = as.list(homeDataSet$Team))
    h3$series(name = "Benefit", type = "bar", data = as.list(homeDataSet$Rating), 
              tooltip = list(pointFormat = "<b>{series.name}:</b> {point.y:.3f}<br>"))
    
    intervalWidths <- list()
    for (team in 1:nrow(homeDataSet)) {
      intervalWidths[[team]] <- c(homeDataSet[team, 3], homeDataSet[team, 4])
    }
    h3$series(name = "Range", type = "errorbar", color = "#0038A8", whiskerLength = "40%", 
              lineWidth = "1.1", data = intervalWidths, 
              tooltip = list(pointFormat = "<b>{series.name}:</b> ({point.low: .3f}, {point.high: .3f})"))
    
    h3$set(dom = 'homeChart')
    return(h3)
  })

  output$teamChart <- renderChart({
    sport <- "NBA"
    selTeams <- input$cbTeams
    
    teamDataSet <- read.csv(paste("~/ShinyApps/team-ratings/Data/", sport, "_Team.csv", sep = ""), 
                            header = TRUE, sep = ",", check.names = FALSE)
    teamDataSet <- teamDataSet[ , which(names(teamDataSet) %in% selTeams), drop = FALSE]
    sportMin <- floor(min(teamDataSet)/2) * 2
    sportMax <- ceiling(max(teamDataSet)/2) * 2
    
    h2 <- Highcharts$new()
    h2$chart(borderWidth = 0, height = 680, width = 760)
    
    h2$title(text = paste(sport, " Team Ratings", sep = ""))
    h2$yAxis(title = list(text = "Adjusted Margin of Victory"), tickInterval = 2, min = sportMin, max = sportMax)
    
    h2$tooltip(shared = FALSE)
    h2$legend(enabled = TRUE)
    
    h2$xAxis(categories = seq(1980, 2013, by=1), labels = list(rotation = 60, y = 20), tickPosition = "inside")
    
    for (team in 1:ncol(teamDataSet)) {
      h2$series(name = names(teamDataSet)[team], type = "line", data = as.list(teamDataSet[, team]), 
                tooltip = list(pointFormat = "<b>{series.name}:</b> {point.y:.3f}<br>"))
    }
    
    h2$set(dom = 'teamChart')
    return(h2)
  })
  
  output$fullTable <- renderGvis({
    sport <- "NBA"
    tableDataSet <- read.csv(paste("~/ShinyApps/team-ratings/Data/", sport, "_Year.csv", sep = ""), header = TRUE, sep = ",")
    tableDataSet$Lower.Bound <- NULL
    tableDataSet$Upper.Bound <- NULL
    tableDataSet$Team.ID <- NULL
    tableDataSet$Rating <- round(tableDataSet$Rating, digits = 3)
    tableDataSet$Team.Name <- paste("<center>", tableDataSet$Team.Name, "</center>", sep = "")
    tableDataSet$Year <- paste("<center>", tableDataSet$Year, "</center>", sep = "")
    colnames(tableDataSet) <- c("Year", "Team Name", "Rating")
    t1 <- gvisTable(tableDataSet,options=list(allowHtml = TRUE, width = 450, height = 450))
    return(t1)
  })
})