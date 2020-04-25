#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(data.table)

# Parameters ----
appUrl <- "https://twitter.com/intent/tweet?text=carbonator%20from%20@dataknut%20@energySoton&url=https://dataknut.shinyapps.io/Carbonator/"
dSource <- "https://lowcarbonbuildings.wordpress.com/2020/02/29/the-carbon-footprint-of-production-and-how-much-it-matters-part-1"
beisSource <- "https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2019"
cseReport <- "https://www.cse.org.uk/downloads/file/distribution_of_uk_carbon_emissions_implications_for_domestic_energy_policy.pdf#page=32&zoom=auto,-22,787"

# load conversion factors ----
factor_dt <- data.table::fread("data/2019.csv") # coding and labels matter - we use them below

# Define UI ----
ui <- fluidPage(

    # > Application title ----
    titlePanel("The Carbonator - a UK personal emissions explorer"),
    
    # > plot def ----
    sidebarLayout(position = "left",
        sidebarPanel(
            # Output: col chart here
            plotOutput(outputId = "distPlot"),
            hr(),
            # > brought to you by ----
            code("The carbonator is brought to you by ",
              a("@dataknut", href="https://twitter.com/dataknut"), ",",
              a("@energySoton", href="https://twitter.com/energysoton"), " and ",
              a("@UoSEngineering", href="https://twitter.com/UoSEngineering")
            ),
            hr()
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                # > info header ----
                p("The carbonator is pre-set with the UK 'average' consumption patterns. Enter your own numbers and the plot will dynamically update.",
                  " Or you can just play with the numbers. Try setting everything to 0 except for a 1000 mile train vs 1000 mile plane trip for example.",
                  "To reset the default values just reload the page.")
            ),
            tabsetPanel(type = "tabs",
                        tabPanel("Public transport", 
                                 # >> Public transport tab ----
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Bus (", factor_dt[Contributor %like% "Bus", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("bus", 
                                                           value = factor_dt[Contributor %like% "Bus", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "Bus", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Train (", factor_dt[Contributor %like% "Train", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("train", 
                                                           value = factor_dt[Contributor %like% "Train", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "Train", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Air (", factor_dt[Contributor %like% "Air", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("air", 
                                                           value = factor_dt[Contributor %like% "Air", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "Air", mFactor], " Kg CO2e/mile")
                                     )
                                 )
                        ),
                        tabPanel("Car use",
                                 # >> Car use tab ----
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car petrol < 1.4l (", factor_dt[Contributor %like% "< 1.4", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("car14l", 
                                                           value = factor_dt[Contributor %like% "< 1.4", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "< 1.4", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car petrol > 1.4l (", factor_dt[Contributor %like% "> 1.4", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("car14m", 
                                                           value = factor_dt[Contributor %like% "> 1.4", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "> 1.4", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car diesel < 1.7l (", factor_dt[Contributor %like% "< 1.7", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("diesel17l", 
                                                           value = factor_dt[Contributor %like% "< 1.7", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "< 1.7", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car diesel > 1.7l (", factor_dt[Contributor %like% "> 1.7", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("diesel17m", 
                                                           value = factor_dt[Contributor %like% "> 1.7", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "> 1.7", mFactor], " Kg CO2e/mile")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car elec (small) (", factor_dt[Contributor %like% "small", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("elecSmall", 
                                                           value = factor_dt[Contributor %like% "small", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "small", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car elec (medium) (", factor_dt[Contributor %like% "medium", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("elecMedium", 
                                                           value = factor_dt[Contributor %like% "medium", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "medium", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Car elec (large) (", factor_dt[Contributor %like% "large", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("elecLarge", 
                                                           value = factor_dt[Contributor %like% "large", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor  %like% "large", mFactor], " Kg CO2e/mile (BEIS 2019)")
                                     )
                                 )
                                 ),
                        tabPanel("Heat and hot water", 
                                 # >> Heat & hot water tab ----
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Electricity (", 
                                                       factor_dt[Contributor == "Electricity", unit],")"
                                     )
                                     ),
                                     column(3,numericInput("elec", 
                                                           value = factor_dt[Contributor == "Electricity", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor == "Electricity", mFactor], " Kg CO2e/kWh (BEIS 2019)")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Gas (", factor_dt[Contributor == "Gas", unit],")"
                                     )
                                     ),
                                     column(3,numericInput("gas", 
                                                           value = factor_dt[Contributor == "Gas", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor == "Gas", mFactor], " Kg CO2e/kWh")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Oil (", factor_dt[Contributor == "Oil", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("oil", 
                                                           value = factor_dt[Contributor == "Oil", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor == "Oil", mFactor], " Kg CO2e/l")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Coal (", factor_dt[Contributor == "Coal", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("coal", 
                                                           value = factor_dt[Contributor == "Coal", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor == "Coal", mFactor], " Kg CO2e/t")
                                     )
                                 ),
                                 fluidRow(
                                     column(3,helpText(style="padding:20px;", "Wood (", factor_dt[Contributor == "Wood", unit], ")"
                                     )
                                     ),
                                     column(3,numericInput("wood", 
                                                           value = factor_dt[Contributor == "Wood", Usage],
                                                           label = ""
                                     )
                                     ),
                                     column(4,helpText(style="padding:20px;", factor_dt[Contributor == "Wood", mFactor], " Kg CO2e/t")
                                     )
                                 )
                        ),
                        tabPanel("Diet", 
                                 # >> Diet tab ----
                                 fluidRow(
                                     column(4,helpText(style="padding:20px;", "Diet (choose)"
                                     )
                                     ),
                                     column(4,selectInput("diet", label = "",
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
                        tabPanel("How do I...", 
                                 # >> How to tab ----
                                 h3("Keep my graph?"),
                                 p("The plots are licensed for re-use as 'Free Cultural Works' under ", a("CC-BY", 
                                                                                                                 href="https://creativecommons.org/licenses/by/4.0/"),
                                     ". What does this mean? Save them, tweet them (",
                                   a("#carbonator", href = "https://twitter.com/hashtag/carbonator?f=live"),
                                   "), do what you want with them but please tell people where you got them.",
                                 ),
                                 h3("Check my results are 'right'?"),
                                 p("Tricky one. We think the calculations are 'right' given the inputs (conversion factors).",
                                   "But if you want to get technical you could look at the Centre for Sustainable Energy's ",
                                   a("excellent report", 
                                     href = cseReport),
                                   ". ",
                                   "If you really really think they're wrong, please raise an issue on the code ",
                                     a("repo.", 
                                       href="https://github.com/dataknut/carbonator/issues?q=is%3Aissue")
                                   ),
                                 h3("Spread the word?"),
                                 p( 
                                     #https://community.rstudio.com/t/include-a-button-in-a-shiny-app-to-tweet-the-url-to-the-app/8113/2
                                     # Create url with the 'twitter-share-button' class
                                     tags$a(href=appUrl, "Twitter", class="twitter-share-button"),
                                     # Copy the script from https://dev.twitter.com/web/javascript/loading into your app
                                     # You can source it from the URL below. It must go after you've created your link
                                     includeScript("http://platform.twitter.com/widgets.js"),
                                     " is our viral medium of choice."
                                 ),
                                 h3("Check the data sources?"),
                                 p("We've used United Kingdom (UK) conversion factors from Judith Thornton's ",
                                   a("carbon footprint calculator", 
                                     href = dSource), " except, where noted, for the BEIS (2019) ",
                                   a("table", href = beisSource, "."), "These factors may not be valid for other countries #ymmv."),
                                 h3("Update the conversion factors?"),
                                 p("Clearly the conversion factors we use will go out of date as e.g. the carbon intensity of electricity generation and the efficiency of other technologies change."),
                                 p("They are also different in different countries and at different",
                                 a("times of day", href="https://www.electricitymap.org/zone/GB?solar=false&remote=true&wind=true")," in the case of electricity."),
                                 p("We're working on it..."),
                                 h3("Give feedback?"),
                                 p("Raise an issue on the code ",
                                   a("repo", href="https://github.com/dataknut/carbonator/issues?q=is%3Aissue"), ".",
                                 ),
                                 h3("Get the code?"),
                                 p("The code is open source under an ", a("MIT license", 
                                                                          href="https://github.com/dataknut/carbonator/blob/master/LICENSE"), 
                                 )
                        )
            )
        )
    )
)

# Define server ----
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # > generate input$xxxx from ui.R ----
        dt <- data.table()
        dt <- rbind(dt,
                    # has to be an easier way
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
        # > draw the bar chart ----
        dt[, source := V1]
        dt[, co2e := as.numeric(V2)]
        totalCarbon <- sum(dt$co2e, na.rm = TRUE) # may be 0 etc
        ggplot2::ggplot(dt[co2e > 0], aes(x = source, y = co2e/1000, fill = V1)) +
            geom_col() +
            scale_fill_viridis_d(guide=FALSE) +
            labs(title = "Your numbers, carbonated",
                 y = "Tonnes CO2e",
                 x = "Source",
                 caption = paste0("Total CO2e: ", round(totalCarbon/1000,1), " tonnes (UK conversion factors)", 
                                  "\n\nSource: dataknut.shinyapps.io/Carbonator/")
                 ) +
            theme(plot.title = element_text(face = "bold", hjust = 1)) +
            coord_flip() # so it's horizontal
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
