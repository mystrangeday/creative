library(dplyr)
library(geosphere)
library("recommenderlab")
library(tidyr)

#-------------Танцы с бубнами--------------
areas <-  read.csv("~/Desktop/R/CreativeClusters/TOTAL_AREAS.csv")
points <-  read.csv("~/Desktop/R/CreativeClusters/cattotal.csv")

#nas  <- as.data.frame(which(is.na(points), arr.ind=TRUE))
#nas.cat <- points[nas$row,4]
#table(nas.cat)

points <- points %>% filter(!is.na(lon))
areas  <- areas  %>% filter(!is.na(lon))

table(points[,4]) #веса отсюда

#-------------Распределение весов--------------
wgt  <- 0.0003205742
main <- 5
atm = rep(wgt, 137)
books = rep(wgt, 46)
bridge = rep(wgt, 133)
hotel = rep(wgt, 296)
libraries = rep(wgt, 56)
museum = rep(wgt,176)
parks = rep(wgt, 218)
station = rep(wgt, 47)
theatre = rep(main, 69)
tot_vec = c(atm, books,bridge, hotel, libraries, museum, parks, station, theatre)

#---------------------------------------------

points1 <- points[,5:6]
areas1 <- areas[,3:4]


dist <- distm(points1, areas1)

#----------Умножаем исходную матрицу расстояний на веса----------
  for(i in 1:ncol(dist)){
    dist[,i]  <- dist[,i]*tot_vec
  }

#----------Рекомендательная модель----------
dist.m <- as(dist, "realRatingMatrix")

percentage_training <- 0.95
items_to_keep <- 15
rating_threshold <- 3
n_eval <-1

set.seed(712)
eval_sets <- evaluationScheme(data = dist.m, method = "split",
                              train = percentage_training, given = items_to_keep, goodRating = rating_threshold, k = n_eval) 
model_to_evaluate <- "RANDOM"
model_parameters <- NULL

eval_recommender <- Recommender(data = getData(eval_sets, "train"),
                                method = model_to_evaluate, parameter = model_parameters)


items_to_recommend <- 2
eval_prediction <- predict(object = eval_recommender, newdata =
                          getData(eval_sets, "known"), n = items_to_recommend,
                           type = "ratings")

evpdf <- as(eval_prediction, "matrix")
evpdfdf <- as.data.frame(evpdf)

evpdfdf[is.na(evpdfdf)] <- 0

#----------Ищем максимальный рейтинг по строкам, который даст рекомендацию пустого здания из areas----------
xdf <- as.data.frame(colnames(evpdfdf)[apply(evpdfdf,1,which.max)])
colnames(xdf) <- "X"

#----------Находим итоговые геоточки для рекомендации----------
areas$X <- interaction( "V", areas$X, sep = "")
final_areas <- dplyr::inner_join(areas, xdf, by="X")

write.csv(final_areas, file = "Theatre_Rec_Geo.csv")


