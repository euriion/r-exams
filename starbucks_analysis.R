# 스타벅스 목록을 읽어서 간단한 통곗값을 출력하는 R 스크립트
# install.packages(c("httr", "urltools", "jsonlite"))
library(httr)
library(urltools)
library(jsonlite)

# 데이터를 긁어올 사이트: https://www.starbucks.co.kr

# 시도 목록을 가져오는 부분
url <- "https://www.starbucks.co.kr/store/getSidoList.do"
res_content <- POST(url)
res_object <- fromJSON(content(res_content, "text"))
sido_items <- tibble(sido_nm=res_object$list$sido_nm, sido_cd=res_object$list$sido_cd)

# 구군 목록을 가져오는 코드. 구군은 분석에 필요하지 않으므로 리마킹
# url = "https://www.starbucks.co.kr/store/getGugunList.do"
# post_params = "sido_cd=01&rndCod=4X93H0I94L"
# res_content <- POST(url, body=parse_url(sprintf("%s?%s", url, post_params))$query)
# res_object <- fromJSON(content(res_content, "text"))

# 각 시도별 주소를 가져오는 부분
url <- "https://www.starbucks.co.kr/store/getStore.do"
payload <- "in_biz_cds=0&in_scodes=0&search_text=&p_sido_cd=08&p_gugun_cd=&in_distance=0&in_biz_cd=&isError=true&searchType=C&set_date=&all_store=0&whcroad_yn=0&P90=0&new_bool=0&iend=1000"
post_params <- parse_url(sprintf("%s?%s", url, payload))$query
res_content <- POST(url, body = post_params)
res_object <- fromJSON(content(res_content, "text"))

# 시도 코드와 이르을 받아서 주소목록이 들어 있는 data.frame을 리턴하는 함수
get_addrs <- function(sido_cd, sido_nm) {
  url <- "https://www.starbucks.co.kr/store/getStore.do"
  payload <- sprintf("in_biz_cds=0&in_scodes=0&search_text=&p_sido_cd=%s&p_gugun_cd=&in_distance=0&in_biz_cd=&isError=true&searchType=C&set_date=&all_store=0&whcroad_yn=0&P90=0&new_bool=0&iend=10000", sido_cd)
  post_params <- parse_url(sprintf("%s?%s", url, payload))$query
  res_content <- POST(url, body = post_params)
  res_object <- fromJSON(content(res_content, "text"))
  cbind(rep(sido_cd, length(res_object$list$addr)), rep(sido_nm, length(res_object$list$addr)), res_object$list$addr)
}

# 데이터랭글링
# install.packags(c("tidyverse", "stringi"))
library(tibble)
library(dplyr, warn.conflicts = FALSE)
library(stringi)

df <- sido_items |> rowwise() |> mutate(addr=list(get_addrs(sido_cd, sido_nm)))

tbl <- do.call(rbind.data.frame, df$addr)
names(tbl) <- c("sido_cd", "sido_nm", "addr")
tbl <- tbl |> rowwise() |> mutate(addrsplit=stri_split_fixed(addr, " ", 4))
tbl <- as_tibble(do.call(rbind.data.frame, tbl$addrsplit))
names(tbl) <- c( "sido", "gugun", "dong", "bunji")

tbl |> count()  # 전체 매장 개수
stat_sido <- tbl |> count(sido) |> arrange(desc(n))  # 시도별 매장 수
stat_gugun <- tbl |> count(sido, gugun) |> arrange(desc(n)) |> mutate(sido_gugun=paste(sido, " ", gugun))  # 시도별 매장 수

# 시각화
library(ggplot2)

p <- ggplot(stat_sido, aes(x =reorder(sido, n), y = n)) +
  geom_col(aes(fill = n), width = 0.7)
p <- p + coord_flip()
p <- p + xlab('시/도')
p

p <- ggplot(head(stat_gugun, 20), aes(x =reorder(sido_gugun, n), y = n)) +
  geom_col(aes(fill = n), width = 0.7)
p <- p + coord_flip()
p <- p + xlab('구/군')
p

# 데이터 출처: # https://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1B040A3&checkFlag=N

pop_sido_text_data <- "sido,total,male,female
서울특별시,9505926,4615631,4890295
부산광역시,3348874,1638207,1710667
대구광역시,2383858,1174667,1209191
인천광역시,2949150,1476663,1472487
광주광역시,1441636,713037,728599
대전광역시,1451272,724026,727246
울산광역시,1121100,575939,545161
세종특별자치시,374377,186907,187470
경기도,13571450,6830317,6741133
강원도,1538660,774315,764345
충청북도,1597097,810548,786549
충청남도,2118638,1083242,1035396
전라북도,1785392,888291,897101
전라남도,1832604,922190,910414
경상북도,2624310,1322509,1301801
경상남도,3311438,1666968,1644470
제주특별자치도,676691,339071,337620
"

pop_sido_tbl <- read.csv(textConnection(pop_text_data))
sido_tbl <- pop_sido_tbl |> inner_join(stat_sido, by = "sido")

# 상관계수
cor(sido_tbl$n, sido_tbl$total)
# 결괏값: 0.8926678
cor.test(sido_tbl$n, sido_tbl$total)
