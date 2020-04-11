###########################################################################
###########################################################################
###                                                                     ###
###            INTRODUCTION TO COMPARATIVE POLITICAL ECONOMY            ###
###                                                                     ###
###########################################################################
###########################################################################



##################################################################
##                       Loading Packages                       ##
##################################################################

library(tidyverse)
library(OECD)
library(eurostat)
library(RColorBrewer)
library(readxl)
library(countrycode)
library(scales)
library(ggthemes)
library(ggrepel)

.rs.restartR()


rm(list = setdiff(
  ls(),
  c(
    "gdp_df_base",
    "trade_union_df",
    "patents_eurostat",
    "patents",
    "spending_oecd"
  )
))

#################################################################
##              Define Good Theme and Colors                   ##
#################################################################

theme_publication <- function(base_size=14, base_family="helvetica") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.4), hjust = 0.5),
            plot.subtitle = element_text(face = "plain",
                                      size = rel(1), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(0.2, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}

scale_fill_Publication <- function(...){
  library(scales)
  discrete_scale("fill","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

scale_colour_Publication <- function(...){
  library(scales)
  discrete_scale("colour","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

###########################################################################
###########################################################################
###                                                                     ###
###                          GENERAL VARIABLES                          ###
###                                                                     ###
###########################################################################
###########################################################################



#getting a list of all OECD datasets that can then be searched
dataset_list <- get_datasets()

search_dataset("social", data = dataset_list)



#################################################################
##                             GDP                             ##
#################################################################

#OECD GDP

#get data structure for variable inspection

gdp_ds <- get_data_structure("SNA_TABLE1")

gdp_ds$MEASURE

unique(gdp_df1$TRANSACT)

#get actual dataset

gdp_df_base <- get_dataset(dataset = "SNA_TABLE1")

#extract gdp per capita ("HCPC" & "B1_GE" = Per head, current (US Dollar) prices, 
#current PPPs & expenditure approach, same as on OECD website)

gdp_df <- gdp_df_base%>%
  mutate(Country = countrycode(LOCATION, origin = 'iso3c',
                               destination = 'country.name'))%>%
  filter(MEASURE == "HCPC" & TRANSACT == "B1_GE" & Country != "NA")%>%
  select(Country, obsTime, obsValue)%>%
  rename("Year" = obsTime)%>%
  rename("GDP_per_Capita" = obsValue)


#WORLDBANK GDP (per capita, current US $)


gdp_worldbank <- read_excel("raw-data/gdp_worldbank.xlsx")%>%
  gather(Year, GDP_per_Capita, `1960`:`2019`)%>%
  rename("Country" = `Country Name`)%>%
  select(Country, Year, GDP_per_Capita)


############################################################################
############################################################################
###                                                                      ###
###                               SESSIONS                               ###
###                                                                      ###
############################################################################
############################################################################


##################################################################
##                 First Session - Introduction                 ##
##################################################################



bannerCommenter::banner("Second Session - Capitalism and the Law")






#################################################################
##           Second Session - Capitalism and the Law           ##
#################################################################


#get gdp wordlbank for only 2012

gdp_worldbank_2012 <- gdp_worldbank%>%
  filter(Year == 2012)


#import rule of law index and create composite scores (and normalize this score)


Rule_of_Law_Index <- read_excel("raw-data/Rule of Law Index.xlsx",
                                sheet = "WJP ROL Index 2012-2013 Scores") %>%
  mutate(Year = "2012") %>%
  group_by(Country) %>%
  mutate(
    com_score = `Factor 5: Open Government` +
      `Factor 6: Regulatory Enforcement` + `Factor 7: Civil Justice` + `Factor 8: Criminal Justice`
  ) %>%
  ungroup() %>%
  mutate(sd_com_score = sd(com_score)) %>%
  mutate(mean_com_score = mean(com_score)) %>%
  group_by(Country) %>%
  mutate(com_score_norm = (com_score - mean_com_score) / sd_com_score) %>%
  ungroup() %>%
  mutate(min_score = min(com_score_norm)) %>%
  mutate(com_score_norm = com_score_norm - min_score)


#merge 

gdp_law <- 
  merge(
    gdp_worldbank_2012,
    Rule_of_Law_Index,
    by = c("Country", "Year"),
    all = T
  )%>%
  mutate(country_label = ifelse(
    Country %in% c("United Arab Emirates", "Malawi", "Liberia", "Denmark", "Singapore", "Kazakhstan"),
    Country,
    NA
  ))


#plotting


gdp_law %>%
  filter(`Income Group` != "NA") %>%
  ggplot(aes(com_score_norm, GDP_per_Capita)) +
  geom_point(size = 3, shape = 1, alpha = 1) +
  geom_smooth(method = "lm", se = F, color = "black") +
  geom_label_repel(aes(label = country_label))+
  ggpubr::stat_cor() +
  #geom_text(data=gdp_law[45,],
                       # aes(com_score_norm, GDP_per_Capita,label=Country))+
  scale_y_log10(
    breaks = trans_breaks("log10", function(x)
      10 ^ x),
    labels = trans_format("log10", math_format(10 ^ .x))
  ) +
  theme_publication() +
  labs(
    x = "Rule of Law Index",
    y = "GDP per Capita",
    title = "Rule of Law and GDP",
    shape = "i",
    #subtitle = "Based on Quality of Open Government, Regulatory Enforcement, Civil Justice and Criminal Justice",
    caption = "Data: Worldbank"
  )


#patents and social spending

#getting a list of eurostat datasets

dataset_list_eurostat <- get_eurostat_toc()

#get patent data

patents_eurostat <- get_eurostat("pat_ep_nipc", time_format = "num", type = "label")

#basic transform

unique(patents$ipc)

patents <-  patents_eurostat %>%
  filter(unit == "Per million inhabitants") %>%
  filter(time %in% c(1980:2010)) %>%
  mutate(geo = as.character(geo)) %>%
  mutate(geo = replace(
    geo,
    geo == "Germany (until 1990 former territory of the FRG)",
    "Germany"
  ))%>%
  group_by(geo, time)%>%#create variable for all patents in a year/country
  summarise(all_patents = sum(values))%>%
  mutate(decade = ifelse(
    time %in% c(1980:1989),
    "1980s",
    ifelse(time %in% c(1990:1999), "1990s", ifelse(time %in% c(2000:2010), "2000s", NA))
  ))


#get social spending data per inhabitant

#first eurostat

soc_spending <- get_eurostat("gov_10a_exp", time_format = "num", type = "label")

soc_spending1 <- soc_spending%>%
  filter(na_item == "Total general government expenditure") %>% # to remove all items that make up this composite
  filter(sector == "General government")%>%
  filter(unit == "Percentage of gross domestic product (GDP)")%>%
  filter(cofog99 %in% c("Social protection"))%>%
  filter(time %in% c(1980:2010))%>%
  mutate(geo = as.character(geo)) %>%
  mutate(geo = replace(
    geo,
    geo == "Germany (until 1990 former territory of the FRG)",
    "Germany"
  )) %>%
  group_by(geo, time)%>%
  summarise(spend_edu_plus_protection = sum(values))%>%
  mutate(decade = ifelse(
    time %in% c(1980:1989),
    "1980s",
    ifelse(time %in% c(1990:1999), "1990s", ifelse(time %in% c(2000:2010), "2000s", NA))
  ))

#now oecd

spending_oecd <-
  get_dataset(dataset = "SNA_TABLE11",
              filter = "AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LVA+LTU+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+GBR+USA.TLYCG.T+010+0101+0102+0103+0104+0105+0106+0107+0108+020+0201+0202+0203+0204+0205+030+0301+0302+0303+0304+0305+0306+040+0401+0402+0403+0404+0405+0406+0407+0408+0409+050+0501+0502+0503+0504+0505+0506+060+0601+0602+0603+0604+0605+0606+070+0701+0702+0703+0704+0705+0706+080+0801+0802+0803+0804+0805+0806+090+0901+0902+0903+0904+0905+0906+0907+0908+100+1001+1002+1003+1004+1005+1006+1007+1008+1009.GS13.C",
              pre_formatted = T)

dstr <-
  get_data_structure("SNA_TABLE11")

unique(spending_oecd$TRANSACT)

spending_oecd1 <- spending_oecd%>%
  filter(ACTIVITY == "100")%>%
  filter(TRANSACT == "TLYCG")%>%
  filter(SECTOR == "GS13")

unique(spending_oecd1$TRANSACT)

%>%
  mutate(country = countrycode(LOCATION, origin = 'iso3c', destination = 'country.name')) %>%
  rename(time = )
  
  
  
soc_spending_patents <- inner_join(soc_spending1, patents)%>%
  group_by(geo, decade)%>%
  summarise(
    all_patents = mean(all_patents),
    spend_edu_plus_protection = mean(spend_edu_plus_protection)
  )

#plot

soc_spending_patents%>%
  filter(decade == "2000s")%>%
  ggplot(aes(spend_edu_plus_protection, all_patents))+
  geom_point()+
  scale_y_log10()+
  geom_text(aes(label = geo))+
  geom_smooth(color = "black")+
  theme_publication()


#now plot by category

patents_eurostat_category <- patents_eurostat %>%
  filter(unit == "Per million inhabitants") %>%
  filter(time %in% c(1980:2010)) %>%
 # filter(str_detect(ipc, "Section")) %>%
  mutate(decade = ifelse(
    time %in% c(1980:1989),
    "1980s",
    ifelse(time %in% c(1990:1999), "1990s", ifelse(time %in% c(2000:2010), "2000s", NA))
  ))%>%
  mutate(geo = as.character(geo)) %>%
  mutate(geo = replace(
    geo,
    geo == "Germany (until 1990 former territory of the FRG)",
    "Germany"
  )) %>%
  mutate(geo = factor(geo)) %>%
  mutate(decade = factor(decade))%>%
  group_by(ipc, geo, decade)%>%
  summarise(values = mean(values))%>%
  group_by(geo, decade) %>% #calculate overall amount of patents per country per decade
  mutate(total_patents_country = sum(values))%>%
  ungroup() %>%
  group_by(ipc, decade) %>% #calculate overall amount of patents in certain category
  mutate(total_patents_category = sum(values)) %>%
  ungroup() %>%
  group_by(decade) %>% #now overall amount of patents in decade
  mutate(total_patents_decade = sum(values)) %>%
  ungroup()%>%#now calculate innovation specialization (see also Hall/Soskice 2001, fn 29)
  group_by(decade, geo, ipc) %>%
  mutate(inno_spec = (values / total_patents_country) - (total_patents_category/total_patents_decade))%>%
  ungroup()%>%
  group_by(decade, geo)%>%
  mutate(inno_spec_norm = scale(inno_spec))



#plotting
  
#define relevant categories

ipc_cat <-
  c("Sports; games; amusements",
    "Vehicles in general",
    "Ammunition; blasting",
    "Machine tools; metal-working not otherwise provided for",
    "Computing; calculating; counting",
    "Electric communication technique")



patents_eurostat_category%>%
  filter(geo %in% c("United States", "Germany", "Sweden", "United Kingdom"))%>%
  filter(decade == "2000s")%>%
  filter(ipc %in% ipc_cat)%>%
  ggplot(aes(ipc, inno_spec_norm, group = geo))+
  geom_bar(aes(fill=geo), stat="identity", 
           position="dodge")+

  coord_flip()+
  scale_fill_brewer(palette = "Paired")+
  theme_publication()+
  labs(x = "IPC Patent Category",
       y = "Patent Specialization Index",
       caption = "Data: Eurostat/EPO",
       title = "Patent Specialization for Selected Patent Categories",
       fill = "Country")






#################################################################
##              Fifth Session - Worlds of Welfare              ##
#################################################################

#get aggregate social spending data structure

soc_spending_agg <- get_data_structure("SOCX_AGG")

#check variable descriptions

soc_spending_agg$VAR_DESC

#get variables

soc_spending_agg$UNIT

#get actual dataset

agg_spending <- get_dataset(dataset = "SOCX_AGG")

#filtering and selecting only relevant variables

#10 = select "public" (SOURCE)
#90 = total spending across categories (BRANCH)
#0 = total spending across type of expentiture (e.g. cash, in-kind) (TYPEEX)
#"PCT_GDP" percent of GDP

agg_spending <- soc_spending_agg_df%>%
  filter(SOURCE == 10 & BRANCH %in% c(1:90) & TYPEXP == 0 & UNIT == "PCT_GDP")%>%
  select(c(UNIT, COUNTRY, BRANCH, obsTime, obsValue))

#create average for countries

agg_spending <- agg_spending %>%
  mutate(regime = ifelse(
    COUNTRY %in% c("AUS", "CAN", "IRL", "NZL", "GBR", "USA"),
    "liberal",
    ifelse(
      COUNTRY %in% c("AUT", "BEL", "DEU", "LUX", "NLD"),
      "conservative",
      ifelse(
        COUNTRY %in% c("DNK", "FIN", "ISL", "NOR", "SWE"),
        "social-democratic",
        ifelse(
          COUNTRY %in% c("GRC", "ITA", "ESP", "PRT"),
          "mediterranean",
          ifelse(
            COUNTRY %in% c("CZE", "HUN", "POL", "SVK", "EST", "SVN"),
                           "eastern-European", "other")
            
          )
        )
      )
    )
  )%>%
  group_by(obsTime,  regime, BRANCH)%>%
  mutate(average_regime = mean(obsValue, na.rm = T))%>%
  ungroup()%>%
  mutate(year = as.numeric(obsTime)) %>%
  mutate(obsValue = obsValue/100)%>%
  group_by(regime, year)%>%
  mutate(perc_of_overall_spending = average_regime/max(average_regime))

#plot aggregate spending by country

agg_spending %>%
  filter(BRANCH == 90)%>%
  filter(COUNTRY %in% c("DEU", "FRA", "ITA", "JPN", "SWE", "GBR", "USA")) %>%
  ggplot(aes(
    x = year,
    y = obsValue,
    color = COUNTRY,
    group = COUNTRY
  )) +
  geom_line(
    aes(color = COUNTRY),
    size = 1.5,
    alpha = 0.8,
    show.legend = F
  ) +
  directlabels::geom_dl(aes(label = COUNTRY),
                        method = list(directlabels::dl.trans(x = x + .2), "last.points")) +
  geom_point(size = 2, show.legend = F)+
  labs(x = "",
       y = "",
       title = "Aggregate Social Spending in Selected OECD Countries",
       subtitle = "Percentage of GDP",
       caption = "Data: OECD") +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()+
  theme(text = element_text(size = 15))



#plot spending by regime

agg_spending%>% 
  filter(BRANCH == 90)%>%
  filter(regime!= "other") %>%
  filter(regime!= "eastern-European")%>%
  filter(regime!= "mediterranean")%>%
  ggplot(aes(
    x = year,
    y = average_regime,
    color = regime,
    group = regime
  )) +
  geom_line(
    aes(color = regime),
    size = 1.5,
    alpha = 0.8,
    show.legend = F
  ) +
  directlabels::geom_dl(aes(label = regime),
                        method = list(directlabels::dl.trans(x = x + 2, y = y -0.4), "first.points")) +
  geom_point(size = 2, show.legend = F)+
  labs(x = "",
       y = "",
       title = "Aggregate Social Spending by Regime Type",
       subtitle = "Percentage of GDP",
       caption = "Data: OECD") +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()+
  theme(text = element_text(size = 15))


#plot by category

agg_spending%>% 
  filter(BRANCH == 6)%>%
  filter(regime!= "other") %>%
  filter(regime!= "eastern-European")%>%
  filter(regime!= "mediterranean")%>%
  ggplot(aes(
    x = year,
    y = perc_of_overall_spending,
    color = regime,
    group = regime
  )) +
  geom_line(
    aes(color = regime),
    size = 1.5,
    alpha = 0.8,
    show.legend = F
  ) +
  directlabels::geom_dl(aes(label = regime),
                        method = list(directlabels::dl.trans(x = x + 2, y = y -0.4), "first.points")) +
  geom_point(size = 2, show.legend = F)+
  labs(x = "",
       y = "",
       title = "Aggregate Social Spending by Regime Type",
       subtitle = "Percentage of GDP",
       caption = "Data: OECD") +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal()+
  theme(text = element_text(size = 15))


##################################################################
##        Sixth Session - A Common Neoliberal Trajectory        ##
##################################################################


#get trade union data structure

trade_union <- get_data_structure("TUD")

#check variable descriptions

trade_union$VAR_DESC

#get variable details

trade_union$TIME_FORMAT

#get actual dataset

trade_union_df <- get_dataset(dataset = "TUD")

# filter
#SERIES = TUD for density#
#using mean when administrative and survey data are both available in a year

trade_union_df <- trade_union_df%>%
  filter(SERIES == "TUD")%>%
  mutate(COUNTRY = COU)%>%
  select(SOURCE, COUNTRY, obsTime, obsValue)%>%
  group_by(COUNTRY, obsTime)%>%
  mutate(obsValue = mean(obsValue))

#plot

trade_union_df%>%
  mutate(year = as.numeric(obsTime)) %>%
  mutate(obsValue = obsValue/100)%>%
  filter(COUNTRY %in% c("DEU", "FRA", "ITA", "JPN", "GBR", "USA")) %>%
  ggplot(aes(
    x = year,
    y = obsValue,
    color = COUNTRY,
    group = COUNTRY
  )) +
  geom_line(
    aes(color = COUNTRY),
    size = 1.5,
    alpha = 0.8,
    show.legend = F
  ) +
  directlabels::geom_dl(aes(label = COUNTRY),
                        method = list(directlabels::dl.trans(x = x + .2), "last.points")) +
  geom_point(size = 2, show.legend = F)+
  labs(x = "",
       y = "",
       title = "Union Density in Selected OECD Countries",
       subtitle = "Administrative and Survey Data",
       caption = "Data: OECD") +
  scale_y_continuous(labels = scales::percent) +
  theme_publication()
  
