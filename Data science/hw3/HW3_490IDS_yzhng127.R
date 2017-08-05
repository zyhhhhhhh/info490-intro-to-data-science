# HW 3 - Due Tuesday Sept 20, 2016. Upload R file to Moodle with name: HW3_490IDS_YOURNETID.R
# Do Not remove any of the comments. These are marked by #
# The .R file will contain your code and answers to questions.

#Name:

# Main topic: Using the "apply" family function

#Q1 (5 pts)
# Given a function below,
myfunc <- function(z) return(c(z,z^2, z^3%/%2))
#(1) Examine the following code, and briefly explain what it is doing.
y = 2:8
myfunc(y)
matrix(myfunc(y),ncol=3)
### Your explanation
print("This is generating a matrix with 3 columns. First column will be y. Second column will be y^2. Third column will be (y^3)/2.")
#(2) Simplify the code in (1) using one of the "apply" functions and save the result as m.
###code & result
m = matrix(c(y,apply(matrix(c(y)), 2, function(x) x^2),apply(matrix(c(y)), 2, function(x) x^3%/%2)), ncol=3)
#(3) Find the row product of m.
###code & result
apply(m, 1, prod)
#(4) Find the column sum of m in two ways.
###code & result
print("First,use apply")
apply(m,2,sum)
print("Second, use matrix multiply")
temp <- matrix(rep(1, times = 8-2+1),nrow=1,ncol=8-2+1)
temp%*%m

#(5) Could you divide all the values by 2 in two ways?
### code & result
print("First,use apply")
apply(m,1:2,function(x) x/2)
print("Second, use matrix multiply")
temp = diag(8-2+1)/2
temp%*%m

#Q2 (8 pts)
#Create a list with 2 elements as follows:
l <- list(a = 1:10, b = 11:20)
#(1) What is the product of the values in each element?
lapply(l, prod)
#(2) What is the (sample) variance of the values in each element?
lapply(l,var)
#(3) What type of object is returned if you use lapply? sapply? Show your R code that finds these answers.
typeof(lapply(l,var))
typeof(sapply(l,var))
print("Using lapply the return type is list, using sapply the return type is double")
# Now create the following list:
l.2 <- list(c = c(21:30), d = c(31:40))
#(4) What is the sum of the corresponding elements of l and l.2, using one function call?
mapply(function(x,y) x+y,x=l,y=l.2)
#(5) Take the log of each element in the list l:
lapply(l,function(x) log(x))
#(6) First change l and l.2 into matrixes, make each element in the list as column,
### your code here
l = matrix(unlist(l), ncol = 2)
l.2 = matrix(unlist(l.2), ncol = 2)
#Then, form a list named mylist using l,l.2 and m (from Q1) (in this order).
### your code here
mylist = list(l,l.2,m)
#Then, select the first column of each elements in mylist in one function call (hint '[' is the select operator).
### your code here
lapply(mylist,'[',,1)


#Q3 (3 pts)
# Let's load our friend family data again.
load(url("http://courseweb.lis.illinois.edu/~jguo24/family.rda"))
#(1) Find the mean bmi by gender in one function call.
apply(matrix(c(family$bmi)),2,mean)
#(2) Could you get a vector of what the type of variables the dataset is made of？
sapply(family,class)
#(3) Could you sort the firstName in height descending order?
lapply(list(family[order(family$height,decreasing = TRUE),1]),'[',1:length(family$firstName))

#Q4 (2 pts)
# There is a famous dataset in R called "iris." It should already be loaded
# in R for you. If you type in ?iris you can see some documentation. Familiarize 
# yourself with this dataset.
#(1) Find the mean petal length by species.
### code & result
by(iris$Petal.Length, iris$Species, mean)
#(2) Now obtain the sum of the first 4 variables, by species, but using only one function call.
### code & result
by(iris[,1:4],iris$Species,sum)
#Q5 (2 pts)
#Below are two statements, their results have different structure, 
lapply(1:4, function(x) x^3)
sapply(1:4, function(x) x^3)
# Could you change one of them to make the two statements return the same results (type of object)?
as.numeric(lapply(1:4, function(x) x^3),nrow=1)
#Q6. (5 pts) Using the family data, fit a linear regression model to predict 
# weight from height. Place your code and output (the model) below. 
line = lm(family$weight ~ family$height)
print("output is Coefficients:
  (Intercept)  family$height  
      -455.666          9.154 ")
# How do you interpret this model?
print("The coefficient is positive, it means that height and weight has positive relationship,which means when height increases, weight tends to increse as well.")
# Create a scatterplot of height vs weight. Add the linear regression line you found above.
plot(family$height,family$weight,type = "p")
abline(line)
# Provide an interpretation for your plot.
print("This is the linear regression lien generated from weight and height. As we can see the weight tends to increase when height increases")
