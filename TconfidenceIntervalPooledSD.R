quantile = 0.95 # is 90% with 5% on both sides of the range

n_y <- 9 # subjects treated
n_x <- 9 # subjects placebo
σ_y <- 1.5 # kg/m2 std.dev. treated 
σ_x <- 1.8 # kg/m2 std.dev. placebo 
μ_y <- -3 #  kg/m2 average difference treated
μ_x <- 1 #  kg/m2 average difference placebo

# calculate pooled standard deviation
σ_p <- sqrt(((n_x - 1) * σ_x^2 + (n_y - 1) * σ_y^2)/(n_x + n_y - 2))

confidenceInterval <-  μ_y - μ_x + c(-1, 1) * qt(quantile, df=n_y+n_x-2) * σ_p * (1 / n_x + 1 / n_y)^.5
round(confidenceInterval,3)
