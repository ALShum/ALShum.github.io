library(wordcloud)
text = readLines("../classes.md")
text = text[nchar(text) > 4]
text = text[grep("^[^\\*\\*]", text)]
text = text[grep("^[^\\#\\#]", text)]
text = text[grep("^[^--]", text)]
text = text[-c(1:5, 19)]
text = as.vector(do.call(cbind, strsplit(text, " ")))
text = text[nchar(text) > 0]

wordcloud(text, 
          max.words = 50, 
          random.order = FALSE, 
          rot.per = 0.35, 
          use.r.layout=FALSE, 
          colors = brewer.pal(8, "Dark2"))

wordcloud(text, 
          max.words = 75, 
          random.order = FALSE, 
          colors = brewer.pal(8, "Dark2"))