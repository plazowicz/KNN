# Load packages
library(kknn)

iris.data <- read.table('Data/iris.data', sep=",")
iris.data <- iris.data[sample.int(nrow(iris.data)),]

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

PrepareData <- function(data, normalization=TRUE) {
  if( normalization ) {
    n <- dim(data)[2]-1
    data <- cbind(Normalize(data[,1:n]),data[,n+1])   
  }
  colnames(data)[n+1] <- "Labels"
  data
}

DoKNN <- function(data, dist=2, kSupremum=50, folds.count=5) {
  m <- dim(data)[1]
  n <- dim(data)[2]-1
  
  step <- as.integer(m/folds.count)
  
  errorRates <- matrix(0, nrow=kSupremum, ncol=folds.count)
  
  for(j in seq(1,m,by=step)) {
    
    fold.index <- as.integer(j/step)+1
    
    if( j+step >= m ) {
      test.data <- data[j:m,]
      train.data <- data[1:(j-1),]
    }
    else if( j == 1 ) {
      test.data <- data[1:(j+step-1),]
      train.data <- data[(j+step):m,]
    }
    else {
      test.data <- data[j:(j+step-1),]
      train.data <- rbind(data[1:(j-1),],data[(j+step):m,])
    }

    for(i in 1:kSupremum) {
      kknn.result <- kknn(Labels~., train.data, test.data, distance=dist, k=i)
      fit <- fitted(kknn.result)
      errorRate <- sum(as.integer(fit != test.data$Labels))/nrow(test.data)
      errorRates[i,fold.index] <- errorRate
    } 
  }
  apply(errorRates, 1, mean)
}

iris.data <- PrepareData(iris.data)
manhatan <- DoKNN(iris.data, dist=1)
euclid <- DoKNN(iris.data)
chebyshev <- DoKNN(iris.data, dist=100)

kSupremum <- 50

plot(1:kSupremum, manhatan, pch=15, col="red", lty=1, type="b", ylim=c(0,0.2))
lines(1:kSupremum, euclid, type="b", pch=17, lty=2, col="blue")
lines(1:kSupremum, chebyshev, col="green", pch=19, lty=3, type="b")
legend("topleft", inset=.05, title="Performace of KNN with regard to K and various Minkovsky's distance", c("manhattan", "euclid", "chebyshev"), 
       lty=c(1,2,3), pch=c(15,17,19), col=c("red","blue","green"))
