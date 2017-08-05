myText <- readLines("/Users/zyh/Documents/2016Fall/Data science/hw7/stateoftheunion1790-2012.txt")
stars= unlist(regmatches(myText, gregexpr("\\*\\*\\*", myText)))
locations = grep("^\\*\\*\\*$", myText)
dates = myText[locations[]+4]

years = regexpr("\\<\\d\\d\\d\\d\\>",dates)
years_list = unlist(regmatches(dates, gregexpr("\\<\\d\\d\\d\\d\\>", dates)))

months = regexpr("^[[:upper:]][[:lower:]]*\\>",dates)
months_list = unlist(regmatches(dates, gregexpr("^[[:upper:]][[:lower:]]*\\>", dates)))

presidents = myText[locations[]+3]

num_speech = length(presidents)
print("number of speeches")
num_speech

president_list = as.data.frame(table(presidents))
president_list = unlist(c(president_list["presidents"]))
num_president = length(president_list)
print("number of presidents")
num_president


speeches = c()
for (i in 1:(length(locations)-1)){
  a = c(unlist(myText[(locations[i]+1):(locations[i+1]-1)], recursive = TRUE))
  a = paste(a, collapse = " ")
  speeches[i] =a
}
a = c(unlist(myText[(locations[length(locations)])+1:(length(myText)-1)], recursive = TRUE))
a = paste(a, collapse = " ")
speeches[length(locations)] =a
length(speeches)
print("Yes, there's 222 elements.")


newspeeches = speeches
for (i in 1:length(newspeeches)){
  newspeeches[i] = gsub("\\<\\S+'\\S+\\>", "", newspeeches[i])
}

for (i in 1:length(newspeeches)){
  newspeeches[i] = gsub("[[:digit:]]", "", newspeeches[i])
}


for (i in 1:length(newspeeches)){
  newspeeches[i] = gsub("\\<.*Applause.*\\>", "", newspeeches[i])
}



newspeeches <- lapply(newspeeches, FUN = tolower)


words = c()
for (i in 1:length(newspeeches)){
  words = c(words,unlist(strsplit(as.character(newspeeches[i]), "[[:blank:]]|[[:punct:]]",perl = TRUE,useBytes = TRUE)))
}
print(length(words))

words = words[words != ""]
print(length(words))

words_vec = list()
for (i in 1:length(newspeeches)){
  a =unlist(strsplit(as.character(newspeeches[i]), "[[:blank:]]|[[:punct:]]",perl = TRUE,useBytes = TRUE))
  a = a[a!=""]
  a = a[a!= "na"]
  a = as.vector(a)
  words_vec[[i]] = a
}


frequencies = words_vec
for (i in 1:length(frequencies)){
  a = as.vector(frequencies[[i]])
  l = length(a)
  b = table(a)
  for (j in 1:length(frequencies[[i]])){
    frequencies[[i]][j] = as.numeric(b[a[j]])/l
  }
}


a = table(words_vec[[216]])
mean(a)
sd(a)
c = names(a)
d = as.numeric(sapply(c,nchar))
b = a[which(d>mean(d))]
b = b[b>mean(a)+0.2*sd(a)]
plot(b)
text(b, lab=row.names(b))

a = table(words_vec[[217]])
mean(a)
sd(a)
c = names(a)
d = as.numeric(sapply(c,nchar))
b = a[which(d>mean(d))]
b = b[b>mean(a)+0.2*sd(a)]
plot(b)
text(b, lab=row.names(b))

a = table(words_vec[[221]])
mean(a)
sd(a)
c = names(a)
d = as.numeric(sapply(c,nchar))
b = a[which(d>mean(d))]
b = b[b>mean(a)+0.2*sd(a)]
plot(b)
text(b, lab=row.names(b))

a = table(words_vec[[222]])
mean(a)
sd(a)
c = names(a)
d = as.numeric(sapply(c,nchar))
b = a[which(d>mean(d))]
b = b[b>mean(a)+0.2*sd(a)]
plot(b)
text(b, lab=row.names(b))

print("Above was 4 graphs on frequent words in the speech by J.W Bush and Obama. I filtered only long words and the frequency has to be large. The first two are by Bush; the latter 2 are by Obama. Despite from America and American, we can easily tell that there's a difference in their focus. J.W Bush has been using military, security and terrorists frequently. Obama has been using education, business, innovation, technology and companies more frequently.
      The reason could be Bush has a main focus on anti-terrorists. History also proved that this stat is correct, Bush vote for the war and Obama against it. When Bush was in duty, 9/11 happened. When Obama was in duty, he had to deal with the consequences of financial crisis, so his main focus will be on business, thus the word business appears more.")


