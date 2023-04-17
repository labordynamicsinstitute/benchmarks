# https://www.alexejgossmann.com/benchmarking_r/
library(rbenchmark)
size = 1000000

benchmark("lm" = {
            X <- matrix(rnorm(size), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- lm(y ~ X + 0)$coef
          },
          "pseudoinverse" = {
            X <- matrix(rnorm(size), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X) %*% t(X) %*% y
          },
          "linear system" = {
            X <- matrix(rnorm(size), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X, t(X) %*% y)
          },
          replications = 1000,
          columns = c("test", "replications", "elapsed",
                      "relative", "user.self", "sys.self"))

#            test replications elapsed relative user.self sys.self
# 3 linear system         1000   0.167    1.000     0.208    0.240
# 1            lm         1000   0.930    5.569     0.952    0.212
# 2 pseudoinverse         1000   0.240    1.437     0.332    0.612