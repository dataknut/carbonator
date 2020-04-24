# deploy
library(rsconnect)
library(here)
rsconnect::deployApp(appDir = paste0(here::here(),"/app"),
                     appName = "Carbonator")