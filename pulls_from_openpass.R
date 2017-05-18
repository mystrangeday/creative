library(jsonlite)
library(dplyr)
library("ggmap")
library("tidyr")
library("dplyr")

geojson <- readLines("~/Downloads/export.geojson", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyDataFrame = T)

lib <- readLines("~/Downloads/library.geojson", warn = FALSE) %>%
  paste(collapse = "\n") %>%
  fromJSON(simplifyDataFrame = T)

l <- lib$features$properties

colnames(g)  <- c("id","addr_city","addr_country","addr_housenumber","addr_letter","addr_place",
                  "addr_street","building","building_colour","building_levels","building_parts","name",
                  "name_de","name_en","name_zh","source","tourism","type","wikidata","wikipedia","alt_name",
                  "architect_wikidata","castle_type","historic","opening_hours","phone","website","addr_postcode",
                  "name_nl","name_es","name_fi","name_fr","name_pt","palace_type","roof_shape","contact_phone",
                  "contact_website","name_ru","description_en","amenity","denomination","height","religion","note",
                  "addr_street_ru","email","int_name","operator","payment_mastercard","payment_visa","building_cladding",
                  "website_en","website_ru","name_cs","wheelchair","name_ca","name_sk","ship_type","start_date",
                  "payment_cash","payment_coins","payment_notes","building_architecture","building_condition",
                  "name_it","contact_vk","old_name","subject","description","historic_name","addr_street2",
                  "design_code_SPb","ref","ref_en","vehicle","fixme","name_el","url","fax",
                  "internet_access","official_name","contact_email","full_name","reservation","fee","short_name","craft")

g2  <- dplyr::filter(g, addr_street!="NA")
g3  <- dplyr::filter(g2, addr_housenumber!="NA")
p <- unite_(g3, "fulladdress", c("addr_street","addr_housenumber"), sep=", ")

p$fulladdress = as.character(p$fulladdress)
x = data.frame()
for (i in 1:length(p$fulladdress)){
  y = ggmap::geocode(p$fulladdress[i], source = "google")
  x = rbind(x, y)
}

p$lon  <- x$lon
p$lat  <- x$lat


museums  <- select(p, name, name_en, fulladdress, building, contact_vk, lon, lat)

library(geosphere)

#расстояние между двумя точками
distm (c(p$lon[1], p$lat[1]), c(p$lon[2], p$lat[2]), fun = distHaversine)

#расстояние друг с другом
xy  <- cbind(p$lon, p$lat)
distm(xy)


