# install.packages("raster")
# install.packages("rgdal")
library(raster)
# map_shape <- shapefile("SIG_201703/TL_SCCO_SIG.shp")
map_shape <- shapefile("LARD_ADM_SECT_SGG_11.shp")
library(ggplot2)
map <- fortify(map_shape, region = "SIG_CD")
str(map)
## 'data.frame': 1337742 obs. of 7 variables:
## $ long : num 127 127 127 127 127 ...
## $ lat : num 37.6 37.6 37.6 37.6 37.6 ...
## $ order: int 1 2 3 4 5 6 7 8 9 10 ...
## $ hole : logi FALSE FALSE FALSE FALSE FALSE FALSE ...
## $ piece: Factor w/ 858 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
## $ id : chr "11110" "11110" "11110" "11110" ...
## $ group: Factor w/ 5043 levels "11110.1","11140.1",..: 1 1 1 1 1 1 1 1 1 1 ...
# 데이터를 확인하고 싶으면 str(map)을 확인해보세요. 이 파일이 어디에 쓰이는 물건인지는 아마 QGIS 쓰시는 분들이 자세하게 알고 계실 듯 합니다. 궁금하다면 위에 알려드린 블로그에 들어가서 한번 확인해보세요. 짧게 설명드리면 위도와 경도를 이용해서 지도를 그린 파일이고, 시군구별 id도 들어 있습니다. 데이터가 워낙 크기 때문에 원활한 사용을 위해 서울시의 25개 자치구만 뽑아내겠습니다. id가 11740 이하면 서울 지역입니다.

map$id <- as.numeric(map$id)
seoul_map <- map[map$id <= 11740,]
seoul_map에 서울지역 정보만 담아왔다면, 앞서 만든 seoul_sum과 합쳐줍니다.

M <- merge(seoul_map, seoul_sum, by = "id")
이렇게 하면 지역명, 자치구별 id, 지도를 그릴 수 있는 지리정보파일까지 모두 하나의 데이터로 합쳤습니다. 지도를 그릴 수 있는 최소한의 작업이 끝났으니 한번 지도를 그려볼까요?

ggplot() +
geom_polygon(data = M,
aes(x = long,
y = lat,
group = group,
fill = sum_n),
color = "white")