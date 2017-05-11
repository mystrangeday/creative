a$address = as.character(a$address)
x = data.frame()
for (i in 1:length(a$address)){
y = ggmap::geocode(a$address[i], source = "google")
x = rbind(x, y)
}
