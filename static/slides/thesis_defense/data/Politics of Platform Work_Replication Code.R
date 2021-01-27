############################################################################
############################################################################
###                                                                      ###
###        THE POLITICS OF PLATFORM CAPITALISM - REPLICATION CODE        ###
###                                                                      ###
############################################################################
############################################################################

#The following code replicates the network and bar plots from the paper:
#"The politics of platform capitalism. A case study on the regulation of Uber in New York"
#The neccessary data can be obtained from the supplementary materials.


##################################################################
##                Installing & Loading Libraries                ##
##################################################################

#if you have difficulties loading the rJava or rDNA package, 
#please consult the most recent version of Leifeld, Philipp; Gruber, Johannes; Bosner, Felix Rolf: Discourse Network Analyzer Manual.

packages <-
  c("devtools",
    "rDNA",
    "rJava",
    "igraph",
    "tidyverse",
    "RColorBrewer",
    "udpipe",
    "syuzhet",
    "patchwork",
    "effsize",
    "assertive.base",
    "lexicon")

missing.packages <- which(!packages %in% installed.packages()[, "Package"])
if (length(missing.packages)) install.packages(packages[missing.packages])
lapply(packages, require, character.only = T)



########################################################################################################
##  Getting Started with rDNA and Retrieving Networks and Attributes from Discourse Network Analyser  ##
########################################################################################################


dna_downloadJar() #download the current betaversion of DNA into working directory


dna_init()  #initializing DNA (using the current version downloaded into the working directory)


dna_gui("Uber_NY.dna") #opening DNA file in the working directory for inspection in Discourse Network Analyser (optional)


conn <- dna_connection("Uber_NY.dna") #establish a connection with the Discourse Network Analyser Database (files need to be in working directory)



#################################################################
##                  Actor Congurence Networks                  ##
#################################################################


congruence <- dna_network(conn,
                          networkType = "onemode",
                          statementType = "DNA Statement",
                          variable1 = "organization",
                          variable2 = "concept",
                          qualifier = "agreement",
                          qualifierAggregation = "congruence",
                          normalization = "average",
                          duplicates = "week",
                          start.date = "10.09.2013",
                          stop.date = "01.08.2015",
                          excludeValues = list("Category" = "TLC Regulation", "Category" = "State Level Regulation"))# excluding codes on TLC and State-Level Regulation


#degree centrality

de_cen <- degree(graph.adjacency(congruence, mode="undirected", weighted=T))

#ploting the network, manually assigning colors that make intuitive sense (e.g. yellow and orange for taxi drivers and taxi industry)

custom_color <- c("#6A3D9A", "#A6CEE3", "#E31A1C", "#FF7F00", "#CAB2D6","#B2DF8A","#FB9A99", "#33A02C", "#FDBF6F", "#1F78B4")

dna_plotNetwork(
  congruence,
  layout = "stress",
  node_size = sqrt(de_cen),
  edge_alpha = 1,
  node_attribute = "type",
  label_repel = 0.1,
  font_size = 7,
  node_colors = "manual",
  custom_colors = custom_color,
  show_legend = F
)+
  theme(legend.position = "bottom")


#second period


congruence2 <- dna_network(conn,
                          networkType = "onemode",
                          statementType = "DNA Statement",
                          variable1 = "organization",
                          variable2 = "concept",
                          qualifier = "agreement",
                          qualifierAggregation = "congruence",
                          normalization = "average",
                          duplicates = "week",
                          start.date = "02.08.2015",
                          stop.date = "31.12.2018",
                          excludeValues = list("Category" = "TLC Regulation", "Category" = "State Level Regulation"))



de_cen2 <- degree(graph.adjacency(congruence2, mode="undirected", weighted=T))

#ploting the network, manually assigning colors that make intuitive sense (e.g. yellow and orange for taxi drivers and taxi industry)

dna_plotNetwork(
  congruence2,
  layout = "stress",
  node_size = sqrt(de_cen2),
  edge_alpha = 1,
  node_attribute = "type",
  label_repel = 0.1,
  font_size = 7,
  node_colors = "manual",
  custom_colors = custom_color,
  show_legend = F
)+
  theme(legend.position = "bottom")



#################################################################
##                       Barplots Frames                       ##
#################################################################


#first period

frames_one <- frames %>%
  filter(period == "first") %>%
  select(-period) %>%
  filter(
    Frame %in% c(
      "Exclusion/Discrimination",
      "Collusion/Corruption",
      "Working Conditions/Drivers’ Interests",
      "Consumer Interests",
      "Congestion",
      "Economy/Jobs/Innovation",
      "Public Interest",
      "Disability Rights",
      "Environment",
      "Safety"
    )
  )%>%
  mutate(Pro_de_Blasio = Pro_de_Blasio - Statements_de_Blasio) %>% #here just subtract deBlasio's statements from the statments by the de Blasio camp
  mutate(Pro_Uber = Pro_Uber - Statements_Uber) %>% #same for Uber (allows for easier visualization as one can just take for groups)
  mutate(Pro_de_Blasio = Pro_de_Blasio * -1) %>% #so that they are negative, again for plotting
  mutate(Statements_de_Blasio = Statements_de_Blasio * -1) %>%
  gather(pro, value, Pro_Uber:Statements_de_Blasio, factor_key = TRUE)%>%#make wide too long
  mutate(pro = ordered(pro, c(
    "Pro_de_Blasio",  
    "Statements_de_Blasio",
    "Pro_Uber",
      "Statements_Uber"
    )
  ))


#plotting

#extract colors red and blue from the "paired" palette

custom_color <- c("#A6CEE3", "#1F78B4", "#FB9A99", "#E31A1C")



ggplot(frames_one, aes(x = reorder(Frame, value), value, fill = pro)) +
  geom_col(show.legend = T, width = 0.7) +
  coord_flip() +
  labs(x = "",
       y = "Number of Statements") +
  scale_y_continuous(labels = abs, limits = c(-35, 35))+ #absolute values not minus
  geom_hline(yintercept = 0) +
  theme_bw() +
  theme(legend.position = "bottom") +
  scale_fill_manual(
    values = custom_color,
    name = "",
    labels = c(
      "Statements de Blasio Coalition",
      "Statments de Blasio",
      "Statements Uber Coalition",
      "Statements Uber"
    )
  ) +
  ggtitle("Statements pro de Blasio/pro cap                Statements pro Uber/against cap") +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold.italic" ))+
  theme(text = element_text(size = 20))+
  guides(fill=guide_legend(nrow=2,byrow=TRUE))




#second period

frames_two <- frames %>%
  filter(period == "second") %>%
  select(-period) %>%
  filter(
    Frame %in% c(
      "Exclusion/Discrimination",
      "Collusion/Corruption",
      "Working Conditions/Drivers’ Interests",
      "Consumer Interests",
      "Congestion",
      "Economy/Jobs/Innovation",
      "Public Interest",
      "Disability Rights",
      "Environment",
      "Safety",
      "Congestion Pricing"
    )
  )%>%
  mutate(Pro_de_Blasio = Pro_de_Blasio-Statements_de_Blasio)%>%#here just subtract deBlasio's statements from the statments by the de Blasio camp
  mutate(Pro_Uber = Pro_Uber-Statements_Uber)%>%#same for Uber (allows for easier visualization as one can just take for groups)
  mutate(Pro_de_Blasio = Pro_de_Blasio*-1)%>%#so that they are negative, again for plotting
  mutate(Statements_de_Blasio = Statements_de_Blasio*-1)%>%
  gather(pro, value, Pro_Uber:Statements_de_Blasio, factor_key=TRUE)%>%#make wide too long
  mutate(pro = ordered(pro, c(
    "Pro_de_Blasio",  
    "Statements_de_Blasio",
    "Pro_Uber",
    "Statements_Uber"
  )
  ))


#plotting

#extract colors red and blue from the "paired" palette

custom_color <- c("#A6CEE3", "#1F78B4", "#FB9A99", "#E31A1C")


ggplot(frames_two, aes(x = reorder(Frame, value), value, fill = pro)) +
  geom_col(show.legend = T, width = 0.7) +
  coord_flip() +
  labs(x = "",
       y = "Number of Statements") +
  scale_y_continuous(labels = abs, limits = c(-70, 70), breaks = c(-60, -40, -20, 0, 20, 40, 60)) + #absolute values not minus
  geom_hline(yintercept = 0) +
  theme_bw() +
  theme(legend.position = "bottom") +
  scale_fill_manual(
    values = custom_color,
    name = "",
    labels = c(
      "Statements de Blasio Coalition",
      "Statments de Blasio",
      "Statements Uber Coalition",
      "Statements Uber"
    )
  ) +
  ggtitle("Statements pro de Blasio/pro cap        Statements pro Uber/against cap") +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold.italic" ))+
  theme(text = element_text(size = 20))+
  guides(fill=guide_legend(nrow=2,byrow=TRUE))




##################################################################
##                       Cluster Analysis                       ##
##################################################################



mc <- dna_multiclust(conn,
                     statementType = "DNA Statement",
                     variable1 = "organization",
                     variable2 = "concept",
                     qualifier = "agreement",
                     duplicates = "week",
                     start.date = "10.09.2013",
                     stop.date = "01.08.2015",
                     excludeValues = list("Category" = "TLC Regulation", "Category" = "State Level Regulation"),
                     k.max = 5,
                     single = F,
                     average = F,
                     complete = F,
                     ward = FALSE,
                     kmeans = T,
                     pam = FALSE,
                     equivalence = T,
                     concor_one = FALSE,
                     concor_two = FALSE,
                     louvain = T,
                     fastgreedy = T,
                     walktrap = T,
                     leading_eigen = T,
                     edge_betweenness = T,
                     infomap = T,
                     label_prop = FALSE,
                     spinglass = FALSE
)

mc2 <- dna_multiclust(conn,
                     statementType = "DNA Statement",
                     variable1 = "organization",
                     variable2 = "concept",
                     qualifier = "agreement",
                     duplicates = "week",
                     start.date = "02.08.2015",
                     stop.date = "31.12.2018",
                     excludeValues = list("Category" = "TLC Regulation", "Category" = "State Level Regulation"),
                     k.max = 5,
                     single = F,
                     average = F,
                     complete = F,
                     ward = FALSE,
                     kmeans = T,
                     pam = FALSE,
                     equivalence = T,
                     concor_one = FALSE,
                     concor_two = FALSE,
                     louvain = T,
                     fastgreedy = T,
                     walktrap = T,
                     leading_eigen = T,
                     edge_betweenness = T,
                     infomap = T,
                     label_prop = FALSE,
                     spinglass = FALSE
)



#creating dataframe for first period

memberships <- mc1$memberships

#or for second period

memberships <- mc2$memberships

#selecting cluster algorhitms separately

#louvain

sel_mem <- memberships%>%
  filter(method=="Louvain")

#creating named vector

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

#ploting 

louvain <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Louvain",
          subtitle = "Colors indicate cluster membership")

#k-means

sel_mem <- memberships%>%
  filter(method=="k-Means")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

kmeans <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("K-Means",
          subtitle = "Colors indicate cluster membership")

#fast&greedy

sel_mem <- memberships%>%
  filter(method=="Fast & Greedy")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

fastngreedy <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Fast & Greedy",
          subtitle = "Colors indicate cluster membership")

#leading eigenvector

sel_mem <- memberships%>%
  filter(method=="Leading Eigenvector")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

leadeigen <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Leading Eigenvector",
          subtitle = "Colors indicate cluster membership")


#edge betweenness

sel_mem <- memberships%>%
  filter(method=="Edge Betweenness")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

edge_bet <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Edge Betweenness",
          subtitle = "Colors indicate cluster membership")

#walktrap

sel_mem <- memberships%>%
  filter(method=="Walktrap")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

walktrap <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Walktrap",
          subtitle = "Colors indicate cluster membership")

#infomap

sel_mem <- memberships%>%
  filter(method=="Infomap")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

infomap <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Infomap",
          subtitle = "Colors indicate cluster membership")


#equivalence


sel_mem <- memberships%>%
  filter(method=="Equivalence")

groups <- structure(as.character(sel_mem$cluster), names = as.character(sel_mem$node))

equivalence <- dna_plotNetwork(
  congruence,
  layout = "nicely",
  node_attribute = "group",
  groups = groups,
  node_size = 2,
  show_legend = F, 
  seed = 1234
)+
  ggtitle("Equivalance",
          subtitle = "Colors indicate cluster membership")

#grid arrange

gridExtra::grid.arrange(equivalence, leadeigen, edge_bet, walktrap)

gridExtra::grid.arrange(infomap, fastngreedy, louvain, kmeans)




##################################################################
##                      Sentiment Analysis                      ##
##################################################################

#natural language processing

model <- udpipe_download_model(language = "english")

full_corpus <- corpus_tidy


nlp_input <- corpus_tidy%>%
  select(doc_id, text)

udpipe_annotated <-
  udpipe(
    corpus_tidy,
    model$file_model,
    parallel.cores = 4,
    parallel.chunksize = 100
  )


#get dictionaries and simplify values to binary: +1 positive, -1 negative

sentiment_dictionary_bing <- get_sentiment_dictionary("bing")%>%
  dplyr::rename(term = word, 
                polarity = value)

sentiment_dictionary_afinn <- get_sentiment_dictionary("afinn")%>%
  dplyr::rename(term = word, 
                polarity = value)%>%
  dplyr::mutate(polarity = ifelse(polarity>0, 1, ifelse(polarity<0, -1, NA)))%>%
  filter(term != "some kind")#has polarity score 0

sentiment_dictionary_nrc <- get_sentiment_dictionary("nrc") %>%
  dplyr::rename(term = word,
                polarity = sentiment) %>%
  dplyr::mutate(polarity = ifelse(polarity == "positive", 1, ifelse(polarity == "negative",-1, NA))) %>%
  select(c(term, polarity))%>%
  filter(!is.na(polarity))

sentiment_dictionary_syuzhet <- get_sentiment_dictionary("syuzhet")%>%
  dplyr::rename(term = word, 
                polarity = value)%>%
  dplyr::mutate(polarity = ifelse(polarity>0, 1, ifelse(polarity<0, -1, NA)))


#get negator, amplifier and deamplifer terms and, together with the annoated 
#corpus and the dictionaries, use them as input for the txt_sentiment function

negators <- lexicon::hash_valence_shifters[y == 1]$x
amplifiers <- lexicon::hash_valence_shifters[y == 2]$x
deamplifiers <- lexicon::hash_valence_shifters[y == 3]$x

sentiment_afinn <- txt_sentiment(x = udpipe_annotated, 
                                 term = "lemma",
                                 polarity_terms = sentiment_dictionary_afinn, 
                                 polarity_negators = negators,
                                 polarity_amplifiers = amplifiers, 
                                 polarity_deamplifiers = deamplifiers)

sentiment_bing <- txt_sentiment(x = udpipe_annotated, 
                                term = "lemma",
                                polarity_terms = sentiment_dictionary_bing, 
                                polarity_negators = negators,
                                polarity_amplifiers = amplifiers, 
                                polarity_deamplifiers = deamplifiers)

sentiment_nrc <- txt_sentiment(x = udpipe_annotated, 
                               term = "lemma",
                               polarity_terms = sentiment_dictionary_nrc, 
                               polarity_negators = negators,
                               polarity_amplifiers = amplifiers, 
                               polarity_deamplifiers = deamplifiers)

sentiment_syuzhet <- txt_sentiment(x = udpipe_annotated, 
                                   term = "lemma",
                                   polarity_terms = sentiment_dictionary_syuzhet, 
                                   polarity_negators = negators,
                                   polarity_amplifiers = amplifiers, 
                                   polarity_deamplifiers = deamplifiers)


# rejoin the output of the nlp with the corpus

sentiment_score_afinn <- sentiment_afinn$overall%>%
  right_join(corpus_tidy, by = "doc_id")%>%
  dplyr::mutate(method = "afinn")

sentiment_score_bing <- sentiment_bing$overall%>%
  right_join(corpus_tidy, by = "doc_id")%>%
  dplyr::mutate(method = "bing")

sentiment_score_nrc <- sentiment_nrc$overall%>%
  right_join(full_corpus, by = "doc_id")%>%
  dplyr::mutate(method = "nrc")

sentiment_score_syuzhet <- sentiment_syuzhet$overall%>%
  right_join(full_corpus, by = "doc_id")%>%
  dplyr::mutate(method = "syuzhet")


#merge

sentiment_score <- rbind(sentiment_score_afinn,
                         sentiment_score_bing,
                         sentiment_score_nrc,
                         sentiment_score_syuzhet)

#get efffect size before and after first regulation

sentiment_score <- sentiment_score%>%
  mutate(period = ifelse(
    Date <= as.Date("2015-07-22"),
    "1st Period",
    "2nd Period"
  ))

#calculating effect size and select output plus for each method

fun_cohen_d <- function(x) {
  effsize::cohen.d(x$sentiment_polarity,
                   as.factor(x$period),
                   hedges.correction = T)[c(4, 6, 9)]%>%
    as.data.frame()%>%
    rownames_to_column()%>%
    pivot_wider(names_from = rowname, values_from = conf.int)
}

sentiment_cohen <- split(sentiment_score, sentiment_score$method)%>%
  lapply(fun_cohen_d)%>%
  bind_rows(.id = "method")



#plot 
library(assertive.base)
p1 <- sentiment_cohen %>%
  mutate(cohen_des = paste(format(round(estimate, 2), nsmall = 2), parenthesize(magnitude))) %>%
  ggplot(aes(method, estimate, fill = method, label = cohen_des)) +
  geom_col(alpha = 0.8) +
  geom_text(size = 3.5, position = position_stack(vjust = .25)) +
  geom_errorbar(aes(ymin = lower, ymax = upper)) +
  theme_minimal(base_size = 16) +
  labs(x = "",
       y = "") +
  scale_fill_brewer(palette = "Set1") +
  theme(legend.position = "none")



p2 <- ggplot(sentiment_score, aes(Date, sentiment_polarity, fill = method)) +
  geom_col(show.legend = FALSE) +
  scale_x_date(breaks = "1 year", date_labels = "%Y") +
  facet_wrap(~ method, ncol = 1) +
  labs(
    x = "",
    y = "Sentiment"
  )+
  geom_vline(xintercept = as.numeric(as.Date("2015-07-22")),
             linetype = 4) +
  geom_vline(xintercept = as.numeric(as.Date("2018-08-08")),
             linetype = 4) +
  scale_fill_brewer(palette = "Set1")+
  theme_minimal(base_size = 16)

#mean with bootstrapped confidence intervals

sentiment_score_boot <- rcompanion::groupwiseMean(
  sentiment_polarity ~ period + method,
  data = sentiment_score,
  R = 10000,
  boot = T,
  bca = T,
  traditional = F
)

#plot

p3 <- sentiment_score_boot %>%
  mutate(sentiment = Mean,
         upper = Bca.upper,
         lower = Bca.lower)%>%
  ggplot(aes(factor(period, levels = c("2nd Period", "1st Period")), sentiment, fill = method)) +
  geom_col(alpha = 0.8) +
  coord_flip()+
  facet_wrap(~method)+
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  theme_minimal(base_size = 16) +
  labs(x = "",
       y = "") +
  scale_fill_brewer(palette = "Set1")+
  theme(legend.position = "none")


#patch together

(p2 | (p3 / p1)) + 
  plot_annotation(tag_levels = 'A') +
  plot_layout(widths = c(3, 2))


save(sentiment_cohen, sentiment_score, sentiment_score_boot, file = "data/sentiment_uber.RData")
