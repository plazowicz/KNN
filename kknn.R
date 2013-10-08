# Load packages
library(kknn)

# Conf
train.percentage <- 0.8

# Load digits data
# digits.data <- read.table('Data/semeion.data')
# labels <- digits.data[,257:dim(digits.data)[2]]
# labels <- apply(labels==1, 1, which)
# digits.data <- cbind(digits.data[,1:256], labels)
# digits.data <- digits.data[sample.int(nrow(digits.data)),]

# Load iris data

iris.data <- read.table('Data/iris.data', sep=",")
iris.data <- iris.data[sample.int(nrow(iris.data)),]
# iris.data <- digits.data
m <- dim(iris.data)[1]

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

iris.data <- cbind(Normalize(iris.data[,1:(dim(iris.data)[2]-1)]),iris.data[,dim(iris.data)[2]])
colnames(iris.data)[dim(iris.data)[2]] <- "Species" 

train.count <- as.integer(train.percentage*m)
train.data <- iris.data[1:train.count,]
test.data <- iris.data[(train.count+1):m,]

# metrics <- c(1,2,1000000000)

errorRates <- 1:3
kSupremum <- 20
for(i in 1:kSupremum) {
  iris.kknn <- kknn(Species~., train.data, test.data, distance=100000000, k=i)
#   summary(iris.kknn)
  fit <- fitted(iris.kknn)
  errorRate <- sum(as.integer(fit != test.data$Species))/nrow(test.data) 
  errorRates[i] <- errorRate
}

plot(1:kSupremum, errorRates, main="Performance of KNN with regard to K on sample data set", xlab="K", ylab="Error rate")
