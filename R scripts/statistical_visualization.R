# ==========================================================
# statistical_visualization.R
# Airbnb Boston - Correlation & Non-linear Analysis
# ==========================================================


library(tidyverse)
library(corrplot)


# ==========================================================
# Load Dataset
# ==========================================================

cat("Loading dataset...\n")

airbnb <- read.csv(
  "D:/Talent assessment/Data/cleaned/master_dataset.csv",
  stringsAsFactors = FALSE
)


cat("Dataset loaded\n")



# ==========================================================
# Data Preparation
# ==========================================================


airbnb$room_type <- trimws(airbnb$room_type)


# Select numerical variables

numeric_data <- airbnb %>%
  select(
    price,
    accommodates,
    bedrooms,
    beds,
    review_scores_rating,
    occupancy_rate,
    total_reviews,
    availability_30,
    availability_60,
    availability_90,
    availability_365
  ) %>%
  na.omit()



# ==========================================================
# Correlation Matrix
# ==========================================================


cat("\n============================\n")
cat("Correlation Matrix\n")
cat("============================\n")


cor_matrix <- cor(
  numeric_data,
  method = "pearson"
)


print(cor_matrix)



# Save correlation matrix

write.csv(
  cor_matrix,
  "D:/Talent assessment/Data/cleaned/correlation_matrix.csv"
)



# ==========================================================
# Correlation Visualization
# ==========================================================


png(
  "D:/Talent assessment/Data/cleaned/correlation_plot.png",
  width = 900,
  height = 700
)


corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.col = "black",
  tl.srt = 45
)


dev.off()



# ==========================================================
# Identify Strongest Price Drivers
# ==========================================================


cat("\n============================\n")
cat("Correlation with Price\n")
cat("============================\n")


price_correlation <- cor_matrix["price",]


price_correlation <- sort(
  price_correlation,
  decreasing = TRUE
)


print(price_correlation)



write.csv(
  data.frame(
    Variable = names(price_correlation),
    Correlation = price_correlation
  ),
  "D:/Talent assessment/Data/cleaned/price_drivers.csv",
  row.names = FALSE
)



# ==========================================================
# LOWESS / LOESS Visualizations
# ==========================================================


# 1. Accommodates vs Price


ggplot(
  airbnb,
  aes(
    x = accommodates,
    y = price
  )
) +
  
  geom_point(
    alpha = 0.3
  ) +
  
  geom_smooth(
    method = "loess",
    se = TRUE
  ) +
  
  labs(
    title = "Price vs Number of Guests Accommodated",
    x = "Accommodates",
    y = "Price"
  )


ggsave(
  "D:/Talent assessment/Data/cleaned/price_vs_accommodates.png"
)



# ==========================================================
# 2. Bedrooms vs Price
# ==========================================================


ggplot(
  airbnb,
  aes(
    x = bedrooms,
    y = price
  )
) +
  
  geom_point(
    alpha = 0.3
  ) +
  
  geom_smooth(
    method = "loess",
    se = TRUE
  ) +
  
  labs(
    title="Price vs Bedrooms",
    x="Number of Bedrooms",
    y="Price"
  )


ggsave(
  "D:/Talent assessment/Data/cleaned/price_vs_bedrooms.png"
)



# ==========================================================
# 3. Reviews vs Price
# ==========================================================


ggplot(
  airbnb,
  aes(
    x = total_reviews,
    y = price
  )
) +
  
  geom_point(
    alpha = 0.3
  ) +
  
  geom_smooth(
    method="loess",
    se=TRUE
  ) +
  
  labs(
    title="Price vs Number of Reviews",
    x="Total Reviews",
    y="Price"
  )


ggsave(
  "D:/Talent assessment/Data/cleaned/price_vs_reviews.png"
)



# ==========================================================
# 4. Occupancy Rate vs Price
# ==========================================================


ggplot(
  airbnb,
  aes(
    x = occupancy_rate,
    y = price
  )
) +
  
  geom_point(
    alpha=0.3
  ) +
  
  geom_smooth(
    method="loess",
    se=TRUE
  ) +
  
  labs(
    title="Price vs Occupancy Rate",
    x="Occupancy Rate",
    y="Price"
  )


ggsave(
  "D:/Talent assessment/Data/cleaned/price_vs_occupancy.png"
)



cat("\nStatistical visualization completed successfully.\n")

