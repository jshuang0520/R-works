# 2017.10.17_LFP

library(rvest)

# ---------- 以下為 2017.10.17 修正部分 : 爬取超連結 ----------

# 爬取超連結
url_of_LFPlab_homepage <- "http://labfnp.com/lab"
html <- paste(readLines(url_of_LFPlab_homepage), collapse="\n")
library(stringr)
matched <- str_match_all(html, "<a href=\"(.*?)\"")
#class(matched) # list


# 把list 換成 vector
matched_vector <-  as.vector(unlist(matched[1]))
class(matched_vector) # "character"


# 取subset : 留下僅有網址連結的部分
subset_of_href_logic <- grep(pattern = "/recipe/", matched_vector)
subset_of_matched_vector <- matched_vector[subset_of_href_logic]

# 觀察結果，仍有些不符合，剔除 :
subset_of_matched_vector <- subset_of_matched_vector[203:402]
paste0("http://labfnp.com", subset_of_matched_vector[1])
#class(subset_of_matched_vector) # "character"


# 成功找出超連結們 :
set_of_href <- c()
for (i in 1:length(subset_of_matched_vector)) {
   set_of_href[i] <- paste0("http://labfnp.com", subset_of_matched_vector[i])
}

set_of_href


# 但再次發現有重複，要清理重複的部分
# 觀察到奇偶部分重複
a <- 1:length(set_of_href)
b <- a[seq(1, length(a), 2)]

clean_set_of_href <- set_of_href[b]
# 得到超連結
clean_set_of_href

# ---------- 以上為 2017.10.17 修正部分 : 爬取超連結 ----------






# 在超連結擷取範圍內，各顧客所使用的香水種類


perfume_type_list <- list()
for (i in 1:length(clean_set_of_href)){
   paste0(" Website : ", clean_set_of_href[i])
   
   # ----- load the data -----
   LFP_product_1 <- read_html(clean_set_of_href[i])
   
   
   # ----- LPF_information -----
   LFP_product_1_information <- LFP_product_1 %>%
      html_nodes(xpath = '/html/body/div[2]/comment()[4]') %>%
      html_text()
   LFP_product_1_information
   
   
   # ----- clean the data -----
   
   # 斷詞
   LFP_product_1_information_strsplit <- strsplit(LFP_product_1_information, split = "[\n]+")
   
   class(LFP_product_1_information_strsplit)
   
   
   
   # 把list 換成 vector
   LFP_product_1_information_strsplit_vector = as.vector(unlist(LFP_product_1_information_strsplit[1]))
   
   
   
   # 子集合 1 : 去掉符號、括號等，留下內文
   subset_logic_1 <- grepl(pattern = "&[A-Za-z]+", LFP_product_1_information_strsplit_vector)
   subset_1 <- LFP_product_1_information_strsplit_vector[subset_logic_1]
   
   
   # 子集合 2 : 留下有香水成分的部分
   subset_logic_2 <- grepl(pattern = "滴", subset_1)
   subset_2 <- subset_1[subset_logic_2]
   
   #  "      &quot;value&quot;: &quot;B50 - 4滴(22.2222%)&quot;"      
   
   # 子集合 3 ~ 5 : 為了只留下香水代號
   
   subset_3 <- gsub(pattern = "\\s+&quot;value&quot;: &quot;", subset_2, replacement = "")
   
   subset_4 <- strsplit(subset_3, split = "[-]")
   subset_4_vector <-  as.vector(unlist(subset_4))
   
   
   logic_subset_5 <- grep(pattern = "[A-Za-z]+[0-9]+", subset_4_vector)
   subset_5 <- subset_4_vector[logic_subset_5]
   
   
   
   
   
   print(subset_5)
   
   perfume_type_list[[i]] <- subset_5
}

# 發現第98個有異常，清理
perfume_type_list[[98]] <- perfume_type_list[[98]][8:13]


# 圖解 : ggplot2
library(ggplot2)

print("2017年9月至今(10/16)，所使用的香水種類")


# list
perfume_type_list
# list to dataframe (in order to sort & plot)
df_perfume_type <- data.frame(Type_of_Perfume = unlist(perfume_type_list), 
                              Groups = rep(letters[1:length(perfume_type_list)],times = sapply(perfume_type_list,length)))

ggplot(df_perfume_type, aes(x = Type_of_Perfume, fill = Type_of_Perfume)) +
   ylim(0, 20) +
   theme(axis.text.x = element_text(angle = 90, hjust = 1))+
   geom_bar()








# 從df選取香水名稱的那一欄位
type <- df_perfume_type$Type_of_Perfume
class(type)

# table   
table_res <- table(type)
# sort
sort_table_res <- sort(table_res, decreasing = TRUE)
sort_table_res

# plot
# 右下視窗Help，在放大鏡輸入par，find in topic輸入las(或直接找這個參數!)
barplot(sort_table_res, horiz = F, las = 2, col = sort_table_res)


