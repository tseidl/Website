---
date: "2020-01-01"
image:
  caption: 
  focal_point: Smart
summary: How can measure text in meaningful ways?
tags:
- Methodological
title: Text as Data
weight: 20
url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""
---

The flipside of my theoretical interest in the economic, social, and political role of ideas is my methodological interest in text as data approaches. Machine-readable texts have become widely available in recent years, and with them an impressive array of tools to make sense of them.

## The uses and misuses of semantic violence

Text as data approaches are characterized by a peculiar but instructive irony. As Kenneth Benoit observes, 

> "generating insight from text as data is only possible once we have destroyed our ability to make sense of the texts directly. To make it useful as data, we had to obliterate the structure of the original text and turn its stylised and oversimplified features into a glorified spreadsheet that no reader can interpret directly, no matter how expert in linear algebra.[^1]"

The idea that to do certain useful things with texts, we need to subject them to a certain amount of 'semantic violence' goes to the heart of current debates on treating text as data. Text as data approaches are highly and often surprisingly useful tools: tools for 'reading' or summarizing large amounts of text; tools for augmenting human abilities or reproducing human efforts; tools for discovering and measuring latent traits. But they also come at a cost - a cost that is usually worth paying for but that also needs to be taken account of. 

Interestingly, the cost that has to be paid - but also the potential price - seems roughly proportional to the amount of semantic violence being done to the texts. On one hand of the spectrum, word counts or perhaps simple keyword extraction techniques are quite intuitive, and can be interpreted relatively straightforwardly. They are, however, also more limited when it comes to scaling complex analyses or discovering sophisticated concepts. Topic models or machine learning methods, on the other hand, are much less intuitive and require much more careful validation. They can, however, also produce more interesting results.

For me, awareness of such tradeoffs is a good starting point when thinking about how to do quantitative text analysis. Text as data approaches allows us to skip labor-intensive and often painful stages of the analysis, but they pose equally labor-intensive (and painful) challenges at other stages. While none of this is news, I periodically have to remind myself that treating text as data cannot and should not make my life as a researcher any easier - but, if done correctly, it can improve my research. 

## Future Avenues

The field of text as data has seen such rapid progress in recent years that it becomes harder and harder to keep up. While I consider myself an informed consumer of the many methods and packages developed by this amazing community, I do have some thoughts on how to move things forward in the years to come. 

* One promising avenue that is increasingly taken is integrate various text as data methods. This can mean using natural language processing for pre-processing (e.g. selecting parts of speech based on theoretical considerations); mutually validating different approaches by using them in combinations (e.g. dictionary-based approaches to validate topic models or topic models to 'inspire' dictionaries); or using different approaches to answer nested questions (e.g. text networks to identify coalitions and scaling approaches to map them onto a latent dimension). 

* Another angle, also increasingly used, is to combine text as data approaches with traditional methods, both quantitative and qualitative. This can mean using topic prevalence as a dependent or independent variable in regression models[^2]; to use survey experiments to establish causal links between topics identified in newspapers and public opinion[^3][^4]; or to combine text as data methods with more interpretative approaches[^5], to give just a few examples.

* A third approach is to think more systematically about the relationship between text as data approaches and social and political theory. This can mean methodologically reimagining important paradigms in the history of political thought[^6]; exploring affinities between text as data approaches and theories of culture[^7][^8]; or using word embeddings to trace to test sociological theories about the cultural dimension of class.[^9]

* A last approach that I would like to mention is to use text as data methods in a comparative setting. This has become much easier with the availability of relatively cheap but very reliable translation tools, which - in a text as data context - have been shown to yield results comparable to gold-standard human translations.[^10][^11]



[^1]: Benoit, K. (2020) ‘Text as data: An Overview’, in Curini, L. and Franzese, R.J. (eds.) The SAGE handbook of research methods in political science and international relations.

[^2]: Barberá, P. et al. (2019) ‘Who Leads? Who Follows? Measuring Issue Attention and Agenda Setting by Legislators and the Mass Public Using Social Media Data’, American Political Science Review, 61, pp. 1–19.

[^3]: Barnes, L. and Hicks, T. (2018) ‘Making Austerity Popular: The Media and Mass Attitudes toward Fiscal Policy’, American Journal of Political Science, 62(2), pp. 340–354.

[^4]: Ferrara, F.M. et al. (2018) ‘Exports vs. Investment: How Public Discourse Shapes Support for External Imbalances’.

[^5]: Nelson, L.K. (2017) ‘Computational Grounded Theory’, Sociological Methods & Research, 19, pp. 1-40.

[^6]: London, J.A. (2016) ‘Re-imagining the Cambridge School in the Age of Digital Humanities’, Annual Review of Political Science, 19(1), pp. 351–373.

[^7]: Bail, C.A. (2014) ‘The cultural environment: measuring culture with big data’, Theory and Society, 43(3-4), pp. 465–482.

[^8]: DiMaggio, P., Nag, M. and Blei, D. (2013) ‘Exploiting affinities between topic modeling and the sociological perspective on culture: Application to newspaper coverage of U.S. government arts funding’, Poetics, 41(6), pp. 570–606. 

[^9]: Kozlowski, A.C., Taddy, M. and Evans, J.A. (2019) ‘The Geometry of Culture: Analyzing the Meanings of Class through Word Embeddings’, American Sociological Review, 84(5), pp. 905–949.

[^10]: Vries, E. de, Schoonvelde, M. and Schumacher, G. (2018) ‘No Longer Lost in Translation: Evidence that Google Translate Works for Comparative Bag-of-Words Text Applications’, Political Analysis, 5, pp. 1–14.

[^11]: Proksch, S.-O., Wratil, C. and Wäckerle, J. (2019) ‘Testing the Validity of Automatic Speech Recognition for Political Text Analysis’, Political Analysis, 10, pp. 1–21.
