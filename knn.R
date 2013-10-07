# Load packages
library(class)

# Conf
train.percentage <- 0.8

# Load data
wine.data <- read.table('Data/winequality-white.csv',sep=';',header=TRUE)

wine.data <- data.matrix(wine.data)

Normalize <- function(data) {
  means = apply(data, 2, mean)
  maxs = apply(data, 2, max)
  mins = apply(data, 2, min)
  for(i in 1:dim(data)[1]) {
    for(j in 1:dim(data)[2]) {
      data[i,j] <- (data[i,j]-means[j])/(maxs[j]-mins[j])
    }
  }
  data
}

normalized.data <- Normalize(wine.data[,1:dim(wine.data)[2]-1])

m <- dim(normalized.data)[1]

# Prepare training data, test data and labels 

train.count <- as.integer(m*train.percentage)

train.data <- normalized.data[1:train.count,]
test.data <- normalized.data[(train.count+1):m,]

labels <- wine.data[,dim(wine.data)[2]]
cl <- labels[1:train.count]

result <- knn(train.data, test.data, cl, k=3)