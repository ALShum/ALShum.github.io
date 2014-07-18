library(wordcloud)
text = readLines("classes.md")
text = text[nchar(text) > 4]
text = text[grep("^[^\\*\\*]", text)]
text = text[grep("^[^\\#\\#]", text)]
text = text[grep("^[^--]", text)]
text = text[-c(1:5, 19)]
text = as.vector(do.call(cbind, strsplit(text, " ")))
text = text[nchar(text) > 0]

