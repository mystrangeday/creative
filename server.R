library(ggfortify)
library(plotly)
library(ggplot2)
library(ggmap)
library(rgdal)
library(sp)

ggmap(get_googlemap("saint-petersburg,russia",
                    maptype = "roadmap",
                    style = c(feature = "all", element = "labels", visibility = "off"),
                    color = "bw", zoom = 11
)) 
