# install.packages("rattle")

library(rattle)
rattle()

# ----------------------------------

# 2018.01.30 sql-r-train

install.packages("tidyverse")
library(tidyverse)

library(DBI)
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "world",
                 host = "rsqltrain.ced04jhfjfgi.ap-northeast-1.rds.amazonaws.com",
                 port = 3306,
                 user = "trainstudent",
                 password = "csietrain")

country <- dbReadTable(con, "country")
head(country, n = 10)
#dbDisconnect(con)

# 版本問題啦，我這裡要再個別裝dplyr，tidyverse裝好的我不能用
#install.packages("dplyr")
#library(dplyr)
taiwan <- filter(country, Code == "TWN")
#taiwan <- filter(country, Name == "Taiwan")
taiwan

# (1)
six_country <- filter(country, Continent == "Asia" & Population > 100000000)
six_country

#?filter

# (2)
six_country_ver1 <- dbGetQuery(con, statement = "select * from country where Continent = 'Asia' AND Population > 100000000")
six_country_ver1
six_country_ver2 <- dbGetQuery(con, statement = "SELECT * FROM country WHERE Continent = 'Asia' AND Population > 100000000")
six_country_ver2
#?dbGetQuery


twn <- country %>%
   select(Name, Population) %>% 
   filter(Name == "Taiwan")
twn




# dplyr
big_asian_contries <- country %>%
   filter(Continent == "Asia" & Population > 100000000) %>%
   select(Name, Population) %>%
   arrange(desc(Population))
big_asian_contries

# sql in r
library(DBI)
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "world",
                 host = "rsqltrain.ced04jhfjfgi.ap-northeast-1.rds.amazonaws.com",
                 port = 3306,
                 user = "trainstudent",
                 password = "csietrain")
country <- dbReadTable(con, "country")

big_asian_contries_sql <- dbGetQuery(con, statement = "
                                     select Name, Population
                                     from country
                                     where Continent = 'Asia' and Population > 100000000                                     
                                     order by Population desc
                                     ")
big_asian_contries_sql
dbDisconnect(con)








