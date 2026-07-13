# ==========================================================
# regression_analysis.R
# Airbnb Boston - Regression & Driver Analysis
# ==========================================================

library(tidyverse)
library(car)
library(broom)
library(lmtest)

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
# Data Cleaning
# ==========================================================

airbnb$room_type <- trimws(airbnb$room_type)

airbnb$host_is_superhost[airbnb$host_is_superhost==""] <- NA

airbnb$host_is_superhost <- factor(
  airbnb$host_is_superhost,
  levels=c("f","t"),
  labels=c("No","Yes")
)

airbnb$room_type <- as.factor(airbnb$room_type)
airbnb$neighbourhood <- as.factor(airbnb$neighbourhood)

# ==========================================================
# Select Variables
# ==========================================================

regression_data <- airbnb %>%
  select(
    price,
    accommodates,
    bedrooms,
    beds,
    review_scores_rating,
    occupancy_rate,
    availability_rate,
    total_reviews,
    room_type
  ) %>%
  na.omit()

cat("Rows used for regression:", nrow(regression_data), "\n\n")

# ==========================================================
# Multiple Linear Regression
# ==========================================================

cat("==============================\n")
cat("OLS REGRESSION MODEL\n")
cat("==============================\n\n")

model <- lm(
  price ~
    accommodates +
    bedrooms +
    beds +
    review_scores_rating +
    occupancy_rate +
    total_reviews +
    room_type,
  data = regression_data
)

summary(model)



# ==========================================================
# Regression Coefficients
# ==========================================================

cat("\n==============================\n")
cat("Regression Coefficients\n")
cat("==============================\n\n")

coefficients <- tidy(model)

print(coefficients)

write.csv(
  coefficients,
  "D:/Talent assessment/Data/cleaned/regression_coefficients.csv",
  row.names = FALSE
)

# ==========================================================
# Driver Analysis
# ==========================================================

cat("\n==============================\n")
cat("Important Drivers of Price\n")
cat("==============================\n\n")

significant <- coefficients %>%
  filter(p.value < 0.05)

print(significant)

# ==========================================================
# Model Performance
# ==========================================================

cat("\n==============================\n")
cat("Model Performance\n")
cat("==============================\n\n")

model_summary <- summary(model)

cat("R-squared :", model_summary$r.squared,"\n")
cat("Adjusted R-squared :", model_summary$adj.r.squared,"\n")
cat("Residual Std Error :", model_summary$sigma,"\n")

# ==========================================================
# ANOVA
# ==========================================================

cat("\n==============================\n")
cat("Regression ANOVA\n")
cat("==============================\n\n")

print(anova(model))

# ==========================================================
# Multicollinearity (VIF)
# ==========================================================

cat("\n==============================\n")
cat("Variance Inflation Factor\n")
cat("==============================\n\n")

vif_values <- vif(model)

print(vif_values)

# Convert VIF matrix to data frame
vif_df <- as.data.frame(vif_values)

# Add variable names
vif_df$Variable <- rownames(vif_df)

# Move Variable column to the front
vif_df <- vif_df[, c("Variable", "GVIF", "Df", "GVIF^(1/(2*Df))")]

# Remove row names
rownames(vif_df) <- NULL

# Display
print(vif_df)

# Save to CSV
write.csv(
  vif_df,
  "D:/Talent assessment/Data/cleaned/vif_results.csv",
  row.names = FALSE
)

cat("VIF results saved successfully.\n")

# ==========================================================
# Residual Diagnostics
# ==========================================================

cat("\n==============================\n")
cat("Residual Diagnostics\n")
cat("==============================\n\n")

print(bptest(model))

print(dwtest(model))

# ==========================================================
# Prediction
# ==========================================================

regression_data$PredictedPrice <- predict(model)

head(
  
  regression_data %>%
    
    select(price,PredictedPrice)
  
)

write.csv(
  
  regression_data,
  
  "D:/Talent assessment/Data/cleaned/regression_predictions.csv",
  
  row.names=FALSE
  
)

cat("\nRegression analysis completed successfully.\n")

