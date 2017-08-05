# HW 8 - Due Tuesday Nov 8, 2016 in moodle and hardcopy in class. 
# Upload R file to Moodle with filename: HW8_490IDS_YOURID.R
# Do not remove any of the comments. These are marked by #

### This assignment will use Google Earth for data display. 
### The .rda file is uploaded to Moodle.

### Load HW8.rda and attach the XML library


### Part 1.  Create the data frame
### Look at the instructions in HW8.pdf.
### Functions you'll want to use: xmlParse(), xmlRoot(), xpathSApply(), xmlGetAttr().
### It also might make it easier to use: xmlToList(), merge().

### Load the data frame called LatLon from HW8.rda.  
load("/Users/zyh/Documents/2016Fall/Data science/hw8/hw8.rda")
library(XML)

### Download the gzipped XML factbook document from
### http://jmatchparser.sourceforge.net/factbook/
### and create an XML "tree" in R 
tree = xmlTreeParse("/Users/zyh/Documents/2016Fall/Data science/hw8/factbook.xml")
doc = xmlParse("/Users/zyh/Documents/2016Fall/Data science/hw8/factbook.xml")
### Use XPath to extract the infant mortality and the CIA country codes from the XML tree
###   
infant = xpathSApply(doc, "//field[@name='Infant mortality rate']/rank", xmlGetAttr, "number")
country = xpathSApply(doc, "//field[@name='Infant mortality rate']/rank", xmlGetAttr, "country")
country = toupper(country)
infant
country

### Create a data frame called IM using this XML file.
### The data frame should have 2 columns: for Infant Mortality and CIA.Codes.
IM = data.frame("Infant Mortality" = infant, "CIA.Codes" = country)
typeof(IM)
### Extract the country populations from the same XML document
population = xpathSApply(doc,"//field[@name = 'Population']/rank",xmlGetAttr, 'number')
country2 = xpathSApply(doc,"//field[@name = 'Population']/rank",xmlGetAttr, 'country')
country2 = toupper(country2)
### Create a data frame called Pop using these data.
### This data frame should also have 2 columns, for Population and CIA.Codes.
Pop = data.frame("Population" = population ,"CIA.Codes" = country2)


### Merge the two data frames to create a data frame called IMPop with 3 columns:
### IM, Pop, and CIA.Codes
IMPop = merge(IM, Pop, ID="CIA.Codes")

### Now merge IMPop with LatLon (from newLatLon.rda) to create a data frame called AllData that has 6 columns
### for Latitude, Longitude, CIA.Codes, Country Name, Population, and Infant Mortality
### (please check lat,long are not reversed in the file)
AllData = merge(x=IMPop, y=LatLon, by=intersect(names(IMPop), names(LatLon)))
names(AllData)


### Part 2.  Create a KML document
### Make the KML document described in HW8.pdf.  It should have the basic
### structure shown in that document.  You can use the addPlacemark function below to make
### the Placemark nodes, you just need to complete the line for the Point node and
### figure out how to use the function.

makeBaseDocument = function(){
### This code creates the template KML document 
  doc_temp = newXMLDoc()
  r = newXMLNode("kml", doc = doc_temp )
  document_node = newXMLNode("Document", parent = r)
  LookAt_Node = newXMLNode("LookAt", parent = r)
  newXMLNode(name="name", "CIA Fact Book", parent = document_node)
  newXMLNode(name="Description", "Infant mortality", parent = document_node)
  return(doc_temp )
}

addPlacemark = function(lat, lon, ctryCode, ctryName, pop, infM, parent, 
                        inf1, pop1, style = FALSE)
{
  pm = newXMLNode("Placemark",  newXMLNode("name", ctryName), attrs = c(id = ctryCode),  parent = parent)
  newXMLNode("Description", paste(ctryName, "\n Population: ", pop, "\n Infant Mortality: ", infM, sep =""), parent = pm)
  newXMLNode("Point", newXMLNode("coordinates",  paste(lat,", ",lon,", ",0, sep="")),  parent=pm)
             
### You need to fill in the code for making the Point node above, including coordinates.
### The line below won't work until you've run the code for the next section to set up
### the styles.

  if(style) newXMLNode("styleUrl", paste("#YOR", inf1, "-", pop1, sep = ''), parent = pm)
}
doc1 = makeBaseDocument()
r1 = xmlRoot(doc1)
child_list = xmlChildren(doc1)
document = child_list[[1]][[1]]
lookat = child_list[[1]][[2]]
for(i in 1:(dim(AllData)[1])) {
  addPlacemark(lat = AllData$Latitude[[i]], lon = AllData$Longitude[[i]], 
               ctryCode = AllData$CIA.Codes[[i]], ctryName = AllData$Country.Name[[i]], 
               pop = AllData$Population[[i]], infM = AllData$Infant.Mortality[[i]], parent = document,style=FALSE)
}
setwd("/Users/zyh/Documents/2016Fall/Data science/hw8")
saveXML(doc=doc1, file="Part2.kml")

### Save your KML document here, call it Part2.kml, and open it in Google Earth.
### (You will need to install Google Earth.)  
### It should have pushpins for all the countries.

### Part 3.  Add Style to your KML
### Now you are going to make the visualizatiion a bit fancier.  Pretty much all the code is given to you
### below to create style elements that are to be placed near the top of the document.
### These , you just need to figure out what it all does.

### Start fresh with a new KML document, by calling makeBaseDocument()

doc2 = makeBaseDocument()
r12 = xmlRoot(doc2)
child_list2 = xmlChildren(doc2)
document2 = child_list2[[1]][[1]]
lookat2 = child_list2[[1]][[2]]
### The following code is an example of how to create cut points for 
### different categories of infant mortality and population size.
### Figure out what cut points you want to use and modify the code to create these 
### categories.
infCut = cut(as.numeric(AllData$Infant.Mortality), breaks = quantile(as.numeric(AllData$Infant.Mortality), seq(0,1,length=6)), include.lowest = TRUE)
infCut = as.numeric(infCut)

popCut = cut(log(as.numeric(AllData$Population)), breaks=quantile(log(as.numeric(AllData$Population)), seq(0,1,length=6)), include.lowest = TRUE)
popCut = as.numeric(popCut)

### Now figure out how to add styles and placemarks to doc2
### You'll want to use the addPlacemark function with style = TRUE

### Below is code to make style nodes. 
### You should not need to do much to it.

### You do want to figure out what scales to you for the sizes of your circles
sca= c(0.5, 1, 3, 5, 10)
color_list = c("blue", "green", "yellow", "orange", "red")
addStyle = function(col1, pop1, parent, urlBase, scales = sca)
{
  st = newXMLNode("Style", attrs = c("id" = paste("YOR", col1, "-", pop1, sep="")), parent = parent)
  newXMLNode("IconStyle", 
  newXMLNode("scale", scales[pop1]), 
	newXMLNode("Icon",paste(urlBase,"color_label_circle_",color_list[col1],".png", sep ="")), parent = st)
}

for (k in 1:5)
{
  for (j in 1:5)
  {
    addStyle(j, k,document2, 'http://www.stanford.edu/~vcs/StatData/circles/')
  }
}

### You will need to figure out what order to call addStyle() and addPlacemark()
### so that the tree is built properly. You may need to adjust the code to call the png files

### Finally, save your KML document, call it Part3.kml and open it in Google Earth to 
### verify that it works.  For this assignment, you only need to submit your code, 
### nothing else.  You can assume that the grader has already loaded HW8.rda.

for(i in 1:(dim(AllData)[1])) {
  addPlacemark(lat = AllData$Latitude[[i]], lon = AllData$Longitude[[i]], 
               ctryCode = AllData$CIA.Codes[[i]], ctryName = AllData$Country.Name[[i]], 
               pop = AllData$Population[[i]], infM = AllData$Infant.Mortality[[i]], 
               parent = document2, inf1=infCut[[i]], pop1=popCut[[i]], 
               style=TRUE)
}
saveXML(doc=doc2, file="Part3.kml")
