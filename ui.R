require(rCharts)

shinyUI(pageWithSidebar(
  headerPanel("NBA Team Ratings v1.0"),
  
  sidebarPanel(
    conditionalPanel(condition = "input.tab == 1",
       sliderInput("year", "Year:", 
                   min=1980, max=2013, value=2013, format="####"),
       
       tags$br(),
       radioButtons("sortTeam", "Sort Method:",
                    list("Alphabetical" = "alph",
                         "Rating" = "rating")),
       tags$br(),
       tags$p("This app shows NBA Teams' regular season",
              "ratings (with 95% confidence intervals) for each year.",
              "The ratings can be interpreted as expected",
              "margins of victory against an average opponent.",
              "For example, a team rated +12 should beat the average", 
              "team by 12 points. A team rated +12 facing a team",
              "rated -4 should expect to win by 16 points."),
       
       tags$br(),
       tags$p("The rating is determined by strength of opponents",
              "and margins of victory (or loss) in each game.",
              "It does not account for homecourt advantage",
              "or injuries, and it assumes that teams have a constant",
              "rating for the entire season. This rating scheme",
              "is simply meant to be a better tool to summarize a season",
              "than Win % or Average Margin of Victory.")
    ),
    
    conditionalPanel(condition = "input.tab == 2",
       checkboxGroupInput("cbTeams", "Teams:",
          c("Atlanta Hawks",
            "Boston Celtics",
            "Brooklyn Nets",
            "Charlotte Bobcats",
            "Chicago Bulls",
            "Cleveland Cavaliers",
            "Dallas Mavericks",
            "Denver Nuggets",
            "Detroit Pistons",
            "Golden State Warriors",
            "Houston Rockets",
            "Indiana Pacers",
            "Los Angeles Clippers",
            "Los Angeles Lakers",
            "Memphis Grizzlies",
            "Miami Heat",
            "Milwaukee Bucks",
            "Minnesota Timberwolves",
            "New Orleans Hornets",
            "New York Knicks",
            "Oklahoma City Thunder",
            "Orlando Magic",
            "Philadelphia 76ers",
            "Phoenix Suns",
            "Portland Trail Blazers",
            "Sacramento Kings",
            "San Antonio Spurs",
            "Toronto Raptors",
            "Utah Jazz",
            "Washington Wizards"), selected = c("Chicago Bulls", "Los Angeles Lakers"))
    ),
    
    conditionalPanel(condition = "input.tab == 3",
       tags$p("Unfortunately, the table takes a few seconds to load.",
              "If it hasn't shown up yet, please be patient;",
              "it'll come eventually (I promise). When it does",
              "come up, click on the headers to sort the column.",
              "Sorting takes a while too...")
    ),
    
    conditionalPanel(condition = "input.tab == 4",
                     radioButtons("sortHome", "Sort Method:",
                                  list("Alphabetical" = "alph",
                                       "Rating" = "rating")),
                     tags$br(),
                     tags$p("Some NBA homecourts are more beneficial than others.",
                            "Here are NBA teams' regular season homecourt advantages",
                            "-- measured in points -- over the past 10 years. The",
                            "Brooklyn Nets are not included because of their extremely",
                            "small sample size.")
    ),
    
    tags$br(),
    tags$p("View the",
          tags$a(href = "https://github.com/ccagrawal/team-ratings", "source code"),
          "on GitHub."),
    
    tags$br(),
    tags$h5(textOutput("count"))
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Chart by Year", showOutput('yearChart', 'highcharts'), value = 1),
      tabPanel("Chart by Team", showOutput('teamChart', 'highcharts'), value = 2),
      tabPanel("Sortable Table", htmlOutput('fullTable'), value = 3),
      tabPanel("Homecourt Advantage", showOutput('homeChart', 'highcharts'), value = 4),
      id = "tab"
    )
  )
))