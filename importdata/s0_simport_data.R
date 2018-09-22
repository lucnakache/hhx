rm(list=ls())
# import libraries
library(dplyr)

# import data
folderdata="C:/Users/Bar Yokhai/Desktop/projets/Blog/smartphone/data/Phone/"



rdsfiles = list.files(path = folderdata,pattern = "*.rds",full.names = T)
amazon_description = readRDS(file = rdsfiles[1])
amazon_property = readRDS(file = rdsfiles[2])
rdc_description = readRDS(file = rdsfiles[3])
rdc_property = readRDS(file = rdsfiles[4])


most_frequent_properties = as.data.frame(table(amazon_property$nameproperty))
names(most_frequent_properties) = c("property","frequence")

nb_properties_stats = amazon_property %>%
  group_by(id) %>%
  summarise(properties_count=n())


nb_modalite_stats = amazon_property %>%
  group_by(nameproperty) %>%
  summarise(modalite_count=n_distinct(valueproperty))

names(most_frequent_properties)
properties_stats = merge(x = most_frequent_properties,
                         y = nb_modalite_stats,
                         all.x = TRUE,
                         by.x = "property",
                         by.y = "nameproperty")

library(ggplot2)

ggplot(nb_properties_stats, aes(properties_count)) +
  geom_histogram()

datafiles = list.files(path = folderdata,pattern = "*.csv",full.names = T)



# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA
# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA
# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA

amazon_description = read.csv(file = datafiles[1],
                              header = F,
                              sep = "|",
                              col.names =c("id","rayon","produit","description") ,
                              nrows = 511,
                              encoding = "UTF-8",
                              stringsAsFactors = F)

# Reparation des labels flingués
bool_id_to_repair = amazon_description$description==""
corrected_label_to_add = lapply(amazon_description$id[bool_id_to_repair],function(x){
  strsplit(x,split="\t#\t",fixed = TRUE)[[1]]
})
corrected_label_to_add = as.data.frame(do.call("rbind",corrected_label_to_add))
names(corrected_label_to_add) = c("id","description")


# Destruction des labels flingués
amazon_description = amazon_description[!bool_id_to_repair,]

# Ajout des labels réparés
amazon_description = bind_rows(amazon_description,corrected_label_to_add)

# remove les descriptions qui commencent par hastag
amazon_description = amazon_description[!substr(amazon_description$description,start = 0,stop = 1) == "#",]

# il y a parfois plusieurs descriptions pour un mm produit on ne prend que le premier par defaut
amazon_description = amazon_description %>%
  group_by(id)%>%
  filter(row_number(id) ==1)


# * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * #  * # 



amazon_prop = read.csv(file = datafiles[2],
                              header = F,
                              sep = "\t",
                              encoding = "UTF-8",
                              stringsAsFactors = F,
                       quote = "",
                       col.names =c("id",
                                    "idproperty",
                                    "nameproperty",
                                    "valueproperty",
                                    "no",
                                    "no2"))

amazon_prop$no = NULL
amazon_prop$no2 = NULL

tt = as.data.frame(table(amazon_prop$nameproperty))
properties_to_keep = as.character(tt$Var1[tt$Freq>15])
amazon_prop = amazon_prop[amazon_prop$nameproperty %in% properties_to_keep,]
amazon_prop = amazon_prop[amazon_prop$nameproperty!="",]



saveRDS(object =amazon_description,
        file =paste0(folderdata,"amazon_description.rds") )
saveRDS(object = amazon_prop,
        file = paste0(folderdata,"amazon_property.rds"))

# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA
# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA
# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA# AMAZON DATA






# RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE 
# RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE 
# RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE # RUE DU COMMERCE 

RDC_description = read.csv(file = datafiles[3],
                           header = F,
                           sep = "|",
                           encoding = "UTF-8",
                           stringsAsFactors = F,
                           quote = "",
                           col.names = c("id","rayon0","rayon1","rayon2","description"))


RDC_prop = read.csv(file = datafiles[4],
                    header = F,
                    sep="\t",
                    encoding = "UTF-8",
                    stringsAsFactors = F,
                    quote = "",col.names = c("id",
                                             "idproperty",
                                             "nameproperty",
                                             "valueproperty",
                                             "no1",
                                             "no2"))
RDC_prop$no1 = NULL
RDC_prop$no2 = NULL

tt = as.data.frame(table(RDC_prop$nameproperty))


saveRDS(object = RDC_description,
        file = paste0(folderdata,"rdc_description.rds"))
saveRDS(object = RDC_prop,
        file = paste0(folderdata,"rdc_property.rds") )
