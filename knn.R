# Load packages
library(class)

# Conf
train.percentage <- 0.8

# Load wine data
wine.data <- read.table('Data/winequality-white.csv',sep=';',header=TRUE)
wine.data <- wine.data[sample.int(nrow(wine.data)),]
wine.data <- data.matrix(wine.data)

# Load breast cancer data
cancer.data <- read.table('Data/breast-cancer-wisconsin.data',sep=',')
# cancer.data <- cancer.data[sample.int(nrow(cancer.data)),]
cancer.data <- data.matrix(cancer.data[,2:dim(cancer.data)[2]])

# Load digits data
digits.data <- read.table('Data/semeion.data')
labels <- digits.data[,257:dim(digits.data)[2]]
labels <- apply(labels==1, 1, which)
digits.data <- cbind(digits.data[,1:256], labels)
digits.data <- digits.data[sample.int(nrow(digits.data)),]

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

DoKNNWithNumericalData <- function(data, plotFile, kSupremum=200, normalization=TRUE) {
  if( normalization ) {
    normalized.data <- Normalize(data[,1:dim(data)[2]-1])
  }
  else {
    normalized.data <- data[,1:dim(data)[2]-1]
  }
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

DoKNNWithNumericalData(digits.data, "digits20Shuffeled.ext", k=20, normalization=FALSE)