#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

dSource <- "https://lowcarbonbuildings.wordpress.com/2020/02/29/the-carbon-footprint-of-production-and-how-much-it-matters-part-1"
beisSource <- "https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019"

library(shiny)
library(ggplot2)
library(data.table)

# Parameters ----
appUrl <- "https://twitter.com/intent/tweet?text=carbonator%20from%20@dataknut%20@energySoton&url=https://dataknut.shinyapps.io/Carbonator/"

# load conversion factors ----
factor_dt <- data.table::fread("data/2019.csv") # coding and labels matter - we use them below

# Define UI ----
ui <- fluidPage(

    # Application title
    titlePanel("The Carbonator - a UK personal emissions explorer)"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(position = "right",
        sidebarPanel(
            h3("Your carbon"),
            # Output: Bar chart
            plotOutput(outputId = "distPlot")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Heat and hot water", 
                                 # > Heat & hot water ----
                                 fluidRow(
                                     column(3,helpText("Electricity (", 
                                                       factor_dt[Contributor == "Electricity", unit],")"
                                     )
                                     ),
                                     column(2,numericInput("elec", 
                                                           value = factor_dt[Contributor == "Electricity", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor == "Electricity", mFactor], " Kg CO2e/kWh (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Gas (", factor_dt[Contributor == "Gas", unit],")"
                                     )
                                     ),
                                     column(2,numericInput("gas", 
                                                           value = factor_dt[Contributor == "Gas", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor == "Gas", mFactor], " Kg CO2e/kWh")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Oil (", factor_dt[Contributor == "Oil", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("oil", 
                                                           value = factor_dt[Contributor == "Oil", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor == "Oil", mFactor], " Kg CO2e/l")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Coal (", factor_dt[Contributor == "Coal", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("coal", 
                                                           value = factor_dt[Contributor == "Coal", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor == "Coal", mFactor], " Kg CO2e/t")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Wood (", factor_dt[Contributor == "Wood", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("wood", 
                                                           value = factor_dt[Contributor == "Wood", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor == "Wood", mFactor], " Kg CO2e/t")
                                     )
                                 )
                                 ),
                        tabPanel("Car use",
                                 # > Car use ----
                                 fluidRow(
                                     column(4,helpText("Car petrol < 1.4l (", factor_dt[Contributor %like% "< 1.4", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("car14l", 
                                                           value = factor_dt[Contributor %like% "< 1.4", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "< 1.4", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car petrol > 1.4l (", factor_dt[Contributor %like% "> 1.4", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("car14m", 
                                                           value = factor_dt[Contributor %like% "> 1.4", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "> 1.4", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car diesel < 1.7l (", factor_dt[Contributor %like% "< 1.7", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("diesel17l", 
                                                           value = factor_dt[Contributor %like% "< 1.7", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "< 1.7", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car diesel > 1.7l (", factor_dt[Contributor %like% "> 1.7", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("diesel17m", 
                                                           value = factor_dt[Contributor %like% "> 1.7", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "> 1.7", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car elec (small) (", factor_dt[Contributor %like% "small", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("elecSmall", 
                                                           value = factor_dt[Contributor %like% "small", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "small", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car elec (medium) (", factor_dt[Contributor %like% "medium", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("elecMedium", 
                                                           value = factor_dt[Contributor %like% "medium", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "medium", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText("Car elec (large) (", factor_dt[Contributor %like% "large", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("elecLarge", 
                                                           value = factor_dt[Contributor %like% "large", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "large", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 )
                                 ),
                        tabPanel("Public transport", 
                                 # > Pubic transport ----
                                 fluidRow(
                                     column(3,helpText("Bus (", factor_dt[Contributor %like% "Bus", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("bus", 
                                                           value = factor_dt[Contributor %like% "Bus", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "Bus", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Train (", factor_dt[Contributor %like% "Train", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("train", 
                                                           value = factor_dt[Contributor %like% "Train", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "Train", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText("Air (", factor_dt[Contributor %like% "Air", unit], ")"
                                     )
                                     ),
                                     column(2,numericInput("air", 
                                                           value = factor_dt[Contributor %like% "Air", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(factor_dt[Contributor  %like% "Air", mFactor], " Kg CO2e/mile")
                                     )
                                 )
                                 ),
                        tabPanel("Diet", 
                                 # > Diet ----
                                 fluidRow(
                                     column(4,helpText("Diet (choose)"
                                     )
                                     ),
                                     column(3,selectInput("diet", label = "",
                                                          choices = list("Standard " = 2200, 
                                                                         "Vegan with minimal processed food & low waste " = 1100,
                                                                         "Ignore my diet" = 0),
                                                          selected = 2200)
                                     ),
                                     column(4,p("Standard: 2200 kg C02e"),
                                            p("Vegan, low waste: 1100 Kg CO2e"),
                                            p("Ignore diet: 0 Kg CO2e"),
                                                p("If you want to investigate the carbon footprint of your food try the ",
                                                a("BBC calculator.", 
                                                  href = "https://www.bbc.co.uk/news/science-environment-46459714")
                                                )
                                     )
                                 )
                                 ),
                        tabPanel("How to...", 
                                 # > How to ----
                                 h3("Use the carbonator:"),
                                 p("Enter your own yearly numbers to get your annual CO2e carbon footprint (in kg)."),
                                 p("Or just enter any old number to see what happens. For example you can compare trains & planes for the same journey distance."),
                                 p("To reset the default values just reload the page."),
                                 h3("Find the data sources:"),
                                 p("We've used United Kingdom (UK) conversion factors from Judith Thornton's ",
                                   a("carbon footprint calculator", 
                                     href = dSource), " and also the BEIS (2019). The calculations may not be valid for other countries #ymmv.",
                                   a("table", href = beisSource, ".")),
                                 h3("Update the conversion factors:"),
                                 p("Clearly the conversion factors we use will go out of date as e.g. the carbon intensity of electricity generation and the efficiency of other technologies change."),
                                 p("They are also different in different countries and at different times of day in the case of electricity."),
                                 p("We're working on it..."),
                                 h3("Give feedback:"),
                                 p("Raise an issue on the code ",
                                 a("repo.", href="https://git.soton.ac.uk/ba1e12/carbonator/-/issues")
                                 ),
                                 h3("Spread the word:"),
                                 p( 
                                   #https://community.rstudio.com/t/include-a-button-in-a-shiny-app-to-tweet-the-url-to-the-app/8113/2
                                 # Create url with the 'twitter-share-button' class
                                   tags$a(href=appUrl, "Twitter", class="twitter-share-button"),
                                   # Copy the script from https://dev.twitter.com/web/javascript/loading into your app
                                   # You can source it from the URL below. It must go after you've created your link
                                   includeScript("http://platform.twitter.com/widgets.js"),
                                   " is our viral medium of choice."
                                   )
                        )
            )
        )
    )
)
# <a href="https://twitter.com/share?ref_src=twsrc%5Etfw" class="twitter-share-button" data-via="dataknut" data-hashtags="carbonator" data-show-count="false">Tweet</a><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
# Define server ----
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate input$xxxx from ui.R
        dt <- data.table()
        dt <- rbind(dt,
                    # must be an easier way
                      cbind("Energy: Electricity", input$elec * factor_dt[Contributor == "Electricity", mFactor]),
                      cbind("Energy: Gas", input$gas * factor_dt[Contributor == "Gas", mFactor]),
                    cbind("Energy: Oil", input$oil * factor_dt[Contributor == "Oil", mFactor]),
                    cbind("Energy: Coal", input$coal * factor_dt[Contributor == "Coal", mFactor]),
                    cbind("Energy: Wood", input$wood * factor_dt[Contributor == "Wood", mFactor]),
                    cbind("Car petrol < 1.4l", input$car14l * factor_dt[Contributor %like% "< 1.4l", mFactor]),
                    cbind("Car petrol > 1.4l", input$car14m * factor_dt[Contributor  %like% "> 1.4l", mFactor]),
                    cbind("Car diesel < 1.7l", input$diesel17l * factor_dt[Contributor  %like% "< 1.7l", mFactor]),
                    cbind("Car diesel > 1.7l", input$diesel17m * factor_dt[Contributor  %like% "> 1.7l", mFactor]),
                    cbind("Car elec (small)", input$elecSmall * factor_dt[Contributor  %like% "small", mFactor]),
                    cbind("Car elec (medium)", input$elecMedium * factor_dt[Contributor  %like% "medium", mFactor]),
                    cbind("Car elec (lqrge)", input$elecLarge * factor_dt[Contributor  %like% "large", mFactor]),
                    cbind("Transport: Train", input$train * factor_dt[Contributor  %like% "Train", mFactor]),
                    cbind("Transport: Bus", input$bus * factor_dt[Contributor  %like% "Bus", mFactor]),
                    cbind("Transport: Air", input$air * factor_dt[Contributor  %like% "Air", mFactor]),
                    cbind("Diet", input$diet)
                      )
        # draw the bar chart
        dt[, source := V1]
        dt[, co2e := as.numeric(V2)]
        ggplot2::ggplot(dt[co2e > 0], aes(x = source, y = co2e/1000, fill = V1)) +
            geom_col() +
            scale_fill_viridis_d(guide=FALSE) +
            labs(y = "Tonnes CO2e",
                 x = "Source") +
            coord_flip()
        #totalCarbon <- sum(dt$co2e)
        #p("Total carbon footprint:" , totalCarbon)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
