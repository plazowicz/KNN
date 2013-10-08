# Load packages
library(class)

# Conf
train.percentage <- 0.8

# Load wine data
wine.data <- read.table('Data/winequality-white.csv',sep=';',header=TRUE)
wine.data <- data.matrix(wine.data)

# Load breast cancer data
cancer.data <- read.table('Data/breast-cancer-wisconsin.data',sep=',')
cancer.data <- data.matrix(cancer.data[,2:dim(cancer.data)[2]])

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

DoKNNWithNumericalData <- function(data, plotFile, kSupremum=200) {
  normalized.data <- Normalize(data[,1:dim(data)[2]-1])
  m <- dim(data)[1]
  
  # Prepare training data, test data and labels 
  
  train.count <- as.integer(m*train.percentage)
  
  train.data <- normalized.data[1:train.count,]
  test.data <- normalized.data[(train.count+1):m,]
  
  labels <- data[,dim(data)[2]]
  cl <- labels[1:train.count]
  correctTestLabels <- labels[(train.count+1):m]
  
  test.count <- length(correctTestLabels)
  
  errors <- 1:kSupremum
  
  for(n in 1:kSupremum) {
    result <- knn(train.data, test.data, cl, k=n)
    
    errors.count <- 0
    
    for(i in 1:test.count) {
      
      if( result[i] != correctTestLabels[i] ) {
        errors.count <- errors.count + 1
      }
    }
    
    error.rate <- errors.count/test.count
    errors[n] <- error.rate
  }
  
  plot(1:kSupremum, errors, main="Performance of KNN with regard to K on sample data set", xlab="K", ylab="Error rate")
  savePlot(filename=paste("Plots",plotFile,sep="/"), type="jpeg")
}

DoKNNWithNumericalData(cancer.data, "cancer200.ext")