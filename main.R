library(jsonlite)

# From http://data.okfn.org/data/datasets/geo-boundaries-wor..
geojson <- readLines("~/export.geojson", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyDataFrame = T)
g<-geojson$features$properties
c<-geojson$features$geometry$coordinates2

unl<-unlist(geojson)
nycounties <- geojsonio::geojson_read("~/export.geojson",
                                      what = "sp")
