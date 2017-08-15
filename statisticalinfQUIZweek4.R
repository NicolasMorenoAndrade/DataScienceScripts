# 1. A pharmaceutical company is interested in testing a potential
# blood pressure lowering medication. Their first examination
# considers only subjects that received the medication at baseline
# then two weeks later. The data are as follows (SBP in mmHg):

SBP <- data.frame(subject=1:5, 
           Baseline=c(140,138,150,148,135),
           Week2=c(132,135,151,146,130))

# Consider testing the hypothesis that there was a mean reduction in 
# blood pressure? Give the P-value for the associated two sided T test.
# (Hint, consider that the observations are paired.)

test <- t.test(SBP$Baseline,SBP$Week2, paired = TRUE, alt="two.sided")
test$p.value


# 3. Researchers conducted a blind taste test of Coke versus Pepsi. 
# Each of four people was asked which of two blinded drinks given in
# random order that they preferred. The data was such that 3 of the 4
# people chose Coke. Assuming that this sample is representative, 
# report a P-value for a test of the hypothesis that Coke is preferred
# to Pepsi using a one sided exact test.

pbinom(2, size=4, prob=0.5, lower.tail = FALSE)
# [1] 0.3125


# 4. Infection rates at a hospital above 1 infection per 100 person
# days at risk are believed to be too high and are used as a benchmark.
# A hospital that had previously been above the benchmark recently had
# 10 infections over the last 1,787 person days at risk. About what is
# the one sided P-value for the relevant test of whether the hospital
# is *below* the standard? 

ppois(10, 17.87, lower.tail = TRUE)
# [1] 0.03237153

rate <- 0.01
errors <- 10
days <- 1787
test <- poisson.test(x=errors,T=days,r=rate,alt="less")
test$p.value
# [1] 0.03237153


# 5. Suppose that 18 obese subjects were randomized, 9 each, to a new 
# diet pill and a placebo. Subjects’ body mass indices (BMIs) were
# measured at a baseline and again after having received the treatment
# or placebo for four weeks. The average difference from follow-up to
# the baseline (followup - baseline) was −3 kg/m2 for the treated group
# and 1 kg/m2 for the placebo group. The corresponding standard
# deviations of the differences was 1.5 kg/m2 for the treatment group
# and 1.8 kg/m2 for the placebo group. Does the change in BMI appear
# to differ between the treated and placebo groups? Assuming normality
# of the underlying data and a common population variance, give a
# pvalue for a two sided t test.

n_y <- 9 # subjects treated
n_x <- 9 # subjects placebo
σ_y <- 1.5# kg/m2 std.dev. treated 
σ_x <- 1.8# kg/m2 std.dev. placebo 
μ_y <- -3#  kg/m2 average difference treated
μ_x <- 1#  kg/m2 average difference placebo

# calculate pooled standard deviation
s_p <- (((n_x - 1) * σ_x^2 + (n_y - 1) * σ_y^2)/(n_x + n_y - 2))
# calculate the t statistic
tstat <- (μ_y - μ_x) / (s_p * (1 / n_x + 1 / n_y)^.5)
pval <- pt(tstat , df=n_y + n_x -2)
pval


# 7. Researchers would like to conduct a study of 100 healthy adults
# to detect a four year mean brain volume loss of .01 mm3. Assume that 
# the standard deviation of four year volume loss in this population is
# .04 mm3. About what would be the power of the study for a 5% one
# sided test versus a null hypothesis of no volume loss?

μ_0 <- 0#  null hypothesis
effect <- 0.01 #  effect
sd <- 0.04
n <- 100
p <- 0.05 #significance level

power <- power.t.test(n=n, delta = effect, sd=sd, sig.level = p,
                      type = "one.sample", 
                      alternative = "one.sided")$power
power

# 8. Researchers would like to conduct a study of n healthy adults to
# detect a four year mean brain volume loss of .01 mm3. Assume that the
# standard deviation of four year volume loss in this population is
# .04 mm3. About what would be the value of n needed for 90% power of
# type one error rate of 5% one sided test versus a null hypothesis of
# no volume loss?

power <- power.t.test(power=0.9, delta = effect, sd=sd, sig.level = p,
                      type = "one.sample", 
                      alternative = "one.sided")$n
power
