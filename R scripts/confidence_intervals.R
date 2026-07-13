# ==========================================================
# confidence_intervals.R
# Airbnb Boston - Confidence Intervals & Effect Sizes
# ==========================================================

library(tidyverse)
library(effectsize)

# ==========================================================
# Load Dataset
# ==========================================================

cat("Loading master dataset...\n\n")

airbnb <- read.csv(
  "D:/Talent assessment/Data/cleaned/master_dataset.csv",
  stringsAsFactors = FALSE
)

cat("Dataset Loaded Successfully\n")
cat("Rows :", nrow(airbnb), "\n")
cat("Columns :", ncol(airbnb), "\n\n")

# ==========================================================
# Clean Data
# ==========================================================

airbnb$room_type <- trimws(airbnb$room_type)

airbnb$host_is_superhost[airbnb$host_is_superhost == ""] <- NA

airbnb$host_is_superhost <- factor(
  airbnb$host_is_superhost,
  levels = c("f","t"),
  labels = c("No","Yes")
)

# ==========================================================
# 95% Confidence Interval by Room Type
# ==========================================================

cat("\n===========================================\n")
cat("95% Confidence Interval - Room Type\n")
cat("===========================================\n")

room_summary <- airbnb %>%
  filter(!is.na(price)) %>%
  group_by(room_type) %>%
  summarise(
    Count = n(),
    Mean = mean(price),
    SD = sd(price),
    SE = SD/sqrt(Count),
    Lower95 = Mean - qt(0.975, Count-1)*SE,
    Upper95 = Mean + qt(0.975, Count-1)*SE
  )

print(room_summary)

# ==========================================================
# 95% Confidence Interval by Neighbourhood
# ==========================================================

cat("\n===========================================\n")
cat("95% Confidence Interval - Neighbourhood\n")
cat("===========================================\n")

neighbourhood_summary <- airbnb %>%
  filter(!is.na(price)) %>%
  group_by(neighbourhood) %>%
  summarise(
    Count = n(),
    Mean = mean(price),
    SD = sd(price),
    SE = SD/sqrt(Count),
    Lower95 = Mean - qt(0.975, Count-1)*SE,
    Upper95 = Mean + qt(0.975, Count-1)*SE
  ) %>%
  arrange(desc(Mean))

print(neighbourhood_summary)

# ==========================================================
# Cohen's d
# Entire Home vs Private Room
# ==========================================================

cat("\n===========================================\n")
cat("Effect Size (Cohen's d)\n")
cat("===========================================\n")

room_data <- airbnb %>%
  filter(room_type %in%
           c("Entire home/apt",
             "Private room"))

if(length(unique(room_data$room_type)) == 2){
  
  d <- cohens_d(
    price ~ room_type,
    data = room_data
  )
  
  print(d)
  
}else{
  
  cat("Room type names do not match.\n")
  print(table(room_data$room_type))
  
}

# ==========================================================
# Eta Squared
# ==========================================================

cat("\n===========================================\n")
cat("Eta Squared (Neighbourhood Price)\n")
cat("===========================================\n")

anova_model <- aov(
  price ~ neighbourhood,
  data = airbnb
)

eta <- eta_squared(anova_model)

print(eta)

# ==========================================================
# Save Results
# ==========================================================

write.csv(
  room_summary,
  "D:/Talent assessment/Data/cleaned/confidence_interval_roomtype.csv",
  row.names = FALSE
)

write.csv(
  neighbourhood_summary,
  "D:/Talent assessment/Data/cleaned/confidence_interval_neighbourhood.csv",
  row.names = FALSE
)

cat("\nConfidence interval tables saved successfully.\n")

cat("\nStatistical analysis completed.\n")

