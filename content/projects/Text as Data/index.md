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

> "generating insight from text as data is only possible once we have destroyed our ability to make sense of the texts directly. To make it useful as data, we had to obliterate the structure of the original text and turn its stylised and oversimplified features into a glorified spreadsheet that no reader can interpret directly, no matter how expert in linear algebra."

The idea that to do certain useful things with texts, we need to subject them to a certain amount of 'semantic violence' goes to the heart of current debates on treating text as data. Text as data approaches are highly and often surprisingly useful tools: tools for 'reading' or summarizing large amounts of text; tools for augmenting human abilities or reproducing human efforts; tools for discovering and measuring latent traits. But they also come at a cost - a cost that is usually worth paying for but that also needs to be taken account of. 

Interestingly, the cost that has to be paid seems to be roughly proportional to the amount of semantic violence being done to the texts. On one hand of the spectrum, word counts or perhaps simple keyword extraction techniques such as RAKE are relatively intutive. On the other hand, topic models or word embeddings are much less intuitive and require careful validation. 

For me, awarness that there is no free lunch in text analysis either is a good starting point when thinking about which methods to choose. Count-based techniques, for example, are often underrated and can be highly instructive, not least because of their simplicity and transparency. Similarly, unsupervised techniques may seem more appealing than supervised techniques at first, as they allow researchers to skip the labor-intensive and often painful process of developing and testing a coding scheme, but they pose equally labor-intensive (and painful) challenges when it comes to interpretation and validation. 

While no of this is news, I have found it useful to periodically remind myself that treating text as data cannot and should not make your life as a researcher any easier - but, if done correctly, it can improve your research.

## What's next?

The field of text as data has seen such rapid progress in recent years that it becomes harder and harder to keep up. While I consider myself an informed consumer of the many methods and packages developed by this amazing community, I do have some thoughts on how to move things forward in the years to come. 

* On promising avenue that is increasingly taken is to combine various text as data techniques to tackle the same research question with full forces. This can mean using natural language processing for pre-processing (e.g. selecting parts of speech based on theoretical considerations); mutually validating different approaches by using them in combinations (e.g. dictionary-based approaches to validate topic models or topic models to 'inspire' dictionaries); or using different approaches to answer nested questions (e.g. text networks to identify coalitions and scaling approaches to map them onto a latent dimension). 

* Another angle, also increasingly used, is to combine text as data approaches with more traditional methods, both quantitative and qualitative. This can mean incorporating the results of topic models with quantitative data

* A third approach is to think more systematically about the relationship between text as data approaches and social and political theory. 








[^1]: Benoit, K. (2020) ‘Text as data: An Overview’, in Curini, L. and Franzese, R.J. (eds.) The SAGE handbook of research methods in political science and international relations.