library(ElemStatLearn)

data(vowel.train)
data(vowel.test)

levels(as.factor(vowel.train$y))
## [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11"

vowel.train$y <- as.factor(vowel.train$y)
str(vowel.train)

set.seed(33833)
