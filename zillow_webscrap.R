pacman::p_load(
  # data wrangling
  tidyverse, stringr,
  #web scraping
  rvest,httr, XML
)

zillow <- 1:11

zill <- map_df(zillow,function(i){
url <-paste0("https://www.zillow.com/orlando-fl/apartments/?page/",i,"/")
res <- GET(url, add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 6.1; Win64; x86) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"))
content <- content(res,as="text")
#Read the Url 
scrap <- read_html(content)
scrap
#Prices
price <- scrap %>% html_nodes(xpath = "//*[contains(@class, 'property-card-data')]") %>% 
  html_text2() %>% tibble(id=i,text=.)
return(price)
})

write_csv(zill, "zillow2.csv")
#read csv
read <- read_csv("data/zillow.csv") %>% print()
clean_data <- read %>% mutate(text=str_replace_all(text, pattern="\n","  "))%>%
  separate(text, c("address","price", "space"), sep="  ")
write_csv(clean_data,"clean_zillow.csv")
