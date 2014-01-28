# $Id$ 
# $URL$
# from http://www.revolutionanalytics.com/revolution-revor-enterprise-benchmark-details
# accessed 2014-01-27
set.seed (1)
m <- 10000
n <-  5000
A <- matrix (runif (m*n),m,n)
system.time (B <- crossprod(A))
# Cholesky Factorization
# The Cholesky matrix factorization may be used to compute the solution of linear systems of equations with a symmetric positive definite coefficient matrix, to compute correlated sets of pseudo-random numbers, and other tasks. We re-use the matrix B computed in the example above:

system.time (C <- chol(B))
# Singular Value Deomposition
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)
system.time (S <- svd (A,nu=0,nv=0)) 

# Principal Components Analysis
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)
system.time (P <- prcomp(A)) 

# Linear Discriminant Analysis
require ('MASS')
g <- 5
k <- round (m/2)
A <- data.frame (A, fac=sample (LETTERS[1:g],m,replace=TRUE))
train <- sample(1:m, k)
system.time (L <- lda(fac ~., data=A, prior=rep(1,g)/g, subset=train))
