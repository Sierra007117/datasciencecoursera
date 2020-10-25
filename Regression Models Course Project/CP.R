## Regression Models Course Project


## Analysis Setup

require(ggplot2)

my_data <- mtcars

head(my_data)

str(my_data)

# Transform variables to factors where appropriate

my_data$cyl <- factor(my_data$cyl)
my_data$vs <- factor(my_data$vs)
my_data$am <- factor(my_data$am, labels = c("auto", "man"))
my_data$gear <- factor(my_data$gear, labels = c("3", "4", "5"))
my_data$carb <- factor(my_data$carb)

str(my_data)

## 1. Is an automatic or manual transmission better for MPG?

g <- ggplot(my_data, aes(x = am, y = mpg))
g + geom_boxplot(aes(group = am), fill = "olivedrab1") +
        xlab("transmission type") + 
        ylab("miles/(US) gallon") + 
        ggtitle("Miles/(US) gallon by type of transmission")

# There seems to be a clear difference in the average mpg between automatic
# and manual transmission. Let's confirm it with a hypothesis test.

# H_0: There is no significant difference in mpg between auto and man trans.
# H_1: Automatic transmission is associated with lower values of mpg

t.test(mpg ~ am, data = my_data, paired = FALSE, alt = "less")

# The p-value is 0.0007 which means that we reject the null at any reasonable
# significance level, i.e. Manual transmission is better for MPG. 

## 2. Quantify the MPG difference between automatic and manual transmissions.

# Get a first idea about the difference in average MPG between automatic and manual transmissions

aggregate(my_data[, 1], list(my_data$am), mean)

# Let's try and fit some linear models with MPG as the dependent variable to quantify
# the difference between type of transmission while accounting for the effect of 
# other variables available in the dataset.

# First try a simple linear regression model with MPG as the dependent variable 
# and transmission type (am) as the independent

mdl1 <- lm(mpg ~ am, data = my_data)

summary(mdl1)

# From the summary we can see that am seems to have a significant effect on mpg
# (p-value < 0.05), and the difference in average MPG between the two levels of am
# (manual - auto) is 7.245, which matches what we have already shown. However,
# am alone does not appear to be enough to explain the variation in mpg, the R-squared
# is 0.3598, which means that this model can only explain 36% of the total variation
# in mpg. We will try to add some more independent variables to the model from the
# dataset to try and get a better fit.

# Let's have a look at the correlations between mpg and the other variables in the
# dataset. We'll try a model that includes variables that appear to be highly
# correlated with mpg. Let's pick arbitratily the variables that have an absolute
# correlation higher than 0.7 plus the am variable.

cor(mtcars, method = "pearson")[, "mpg"]

mdl2 <- lm(mpg ~ cyl + disp + hp + wt + am, data = my_data)

summary(mdl2)

# Model 2 explains 87% of the variance and the adjusted R-squared is 83%. It 
# is a much better fit than model 1, but includes independent variables that don't
# seem to have a significant effect (variables with p-value higher than 0.05).
# Transmission type doesn't seem to be significant in this model either. Let's try
# to remove variable "disp".

mdl3 <- lm(mpg ~ cyl + hp + wt + am, data = my_data)

summary(mdl3)

# R-squared went down as expected but the value of adj. R-squared went up slightly to 84%, so model 3 is better than
# model 2. We can continue this "backwards elimination" to find better models, 
# but we'll stop here as we want to keep am in the model. From the summary
# we can see that when accounting for all these variables, the difference between
# manual and automatic transmission in terms of average MPG, 
# while keeping everything else constant, is 1.8 miles/gallon (higher for manual).

# Diagnostic plots
par(mfrow = c(2,2))
plot(mdl3)

# 1. The residual vs fitted plot does not reveal any non-linear or other patterns
# 2. Testing the normality assumption - the qqplot is not a perfect straight line but does not appear to be concerning
# 3. There is no evidence of heteroscedasticity from the scale-location plot
# 4. All the residuals are within Cook's distance, so there's no reason to suspect
# influential data points in the dataset.