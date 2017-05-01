
library(dplyr)

setwd("/home/nicolas/Desktop/DataScience/Scripts")
load("./data/tidyrExamples.RData")

# Example 1: gather() usage -----------------------------------------------

students

#In this case the data has three variables: grade, sex and count. Tidy version could be obtained with:
melt(students, id="grade")

#or with tidyr. (-grade says we want to gather all columns but grade)
gather(students,key = sex, value = count, -grade)

# Example 2: separate() usage ---------------------------------------------

students2

#This df has column headers that are values (male_1, female_1, etc.) and not variable names (sex, class, and count).
#It also has two variables mixed in columns (class and sex)

res <- gather(students2, key = sex_class, value = count, -grade)
res

#now we have to split column sex_class int sex and class
# by default saparate splits on non-alphanumeric charachters
separate(data = res, col = sex_class, into = c("sex", "class"))



# swirl examples ----------------------------------------------------------

# same calls to gather() and separate(), but this time
# use the %>% operator to chain the commands together without
# storing an intermediate result.

students2 %>%
  gather(key = sex_class, value = count, -grade) %>%
  separate(col = sex_class , c("sex", "class")) %>%
  print


# Call gather() to gather the columns class1
# through class5 into a new variable called class.
# The 'key' should be class, and the 'value'
# should be grade.
#
# tidyr makes it easy to reference multiple adjacent
# columns with class1:class5, just like with sequences
# of numbers.

students3 %>%
  gather(key = class , value = grade ,class1:class5 , na.rm = TRUE) %>%
  print

# This script builds on the previous one by appending
# a call to spread(), which allows to turn the
# values of the test column, midterm and final, into
# column headers (i.e. variables).

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(key = test, value=grade) %>%
  print

# We want the values in the class columns to be
# 1, 2, ..., 5 and not class1, class2, ..., class5.

# Use the mutate() function from dplyr along with
# parse_number(). Hint: You can "overwrite" a column
# with mutate() by assigning a new value to the existing
# column instead of creating a new column.

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class=parse_number(class)) %>%
  print

# selecting the id, name, and sex column from students4
# and storing the result in student_info.

student_info <- students4 %>%
  select(id, name, sex) %>%
  print

# Add a call to unique() below, which will remove
# duplicate rows from student_info.

student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print

# select() the id, class, midterm, and final columns
# (in that order) and store the result in gradebook.

gradebook <- students4 %>%
  select(id,class,midterm,final) %>%
  print

# 1. select() all columns that do NOT contain the word "total",
# since if we have the male and female data, we can always
# recreate the total count in a separate column, if we want it.
# Use the contains() function.
# gather() all columns EXCEPT score_range, using
# key = part_sex and value = count.
# separate() part_sex into two separate variables (columns),
# called "part" and "sex", respectively.

sat %>%
  select(-contains("total")) %>%
  gather( key = part_sex, value = count, -score_range) %>%
  separate(col = part_sex , into = c("part","sex")) %>%
  print

# Use group_by() to group the data by part and
# sex, in that order.
# Use mutate to add two new columns, whose values will be
# automatically computed group-by-group:
#
#   * total = sum(count)
#   * prop = count / total

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part,sex) %>%
  mutate(total = sum(count), prop = count/total) %>%
  print
