install.packages("tidyverse")
install.packages("ggplot2")
install.packages("car")
install.packages("effectsize")
install.packages("lmtest")
install.packages("broom")
install.packages("emmeans")

library(tidyverse)
library(effectsize)
library(car)


# ==========================================
# Load Dataset
# ==========================================

airbnb <- read.csv(
  "D:/Talent assessment/Data/cleaned/master_dataset.csv"
)


cat("Dataset Loaded\n")

str(airbnb)

# ==========================================
# H1:
# Entire Home/Apt listings have higher prices
# than Private Rooms
# ==========================================

h1_data <- airbnb %>%
  filter(room_type %in%
           c("Entire Home/Apt",
             "Private Room"))


# Check groups

table(h1_data$room_type)


# Hypothesis test

h1_test <- t.test(
  price ~ room_type,
  data = h1_data,
  alternative = "greater"
)

print(h1_test)


# Effect size

h1_effect <- cohens_d(
  price ~ room_type,
  data = h1_data
)

print(h1_effect)



#=============================================

unique(airbnb$host_is_superhost)
table(airbnb$host_is_superhost, useNA = "ifany")

library(dplyr)

airbnb$host_is_superhost[airbnb$host_is_superhost == ""] <- NA

airbnb$host_is_superhost <- factor(
  airbnb$host_is_superhost,
  levels = c("f", "t"),
  labels = c("No", "Yes")
)

table(airbnb$host_is_superhost, useNA = "ifany")

# ==========================================
# H2:
# Superhost ratings vs Non-superhost
# ==========================================


cat("\nH2: Superhost Rating Difference\n")


h2_data <- airbnb %>%
  filter(!is.na(host_is_superhost))


h2_test <- t.test(
  review_scores_rating ~ host_is_superhost,
  data = h2_data
)


print(h2_test)


print(
  cohens_d(
    review_scores_rating ~ host_is_superhost,
    data=h2_data
  )
)



# ==========================================
# H3:
# Reviews >10 vs <=10 Price Difference
# ==========================================


cat("\nH3: Review Count and Price\n")


h3_data <- airbnb %>%
  mutate(
    review_group =
      ifelse(total_reviews > 10,
             "More than 10 reviews",
             "10 or fewer reviews")
  )


h3_test <- t.test(
  price ~ review_group,
  data=h3_data
)


print(h3_test)


print(
  cohens_d(
    price ~ review_group,
    data=h3_data
  )
)



# ==========================================
# H4:
# ANOVA Neighbourhood Price Difference
# ==========================================


cat("\nH4: ANOVA Neighbourhood Prices\n")


h4_data <- airbnb %>%
  filter(!is.na(neighbourhood))


anova_model <- aov(
  price ~ neighbourhood,
  data=h4_data
)


summary(anova_model)



# Eta squared

eta_squared(anova_model)

