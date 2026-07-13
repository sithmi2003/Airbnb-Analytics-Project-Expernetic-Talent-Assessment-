--Total Listings
SELECT COUNT(*) AS TotalListings
FROM master_dataset;

--Average Price
SELECT
    AVG(price) AS AveragePrice
FROM master_dataset;

--Listings by Room Type
SELECT
    room_type,
    COUNT(*) AS TotalListings
FROM master_dataset
GROUP BY room_type;

--Average Price by Room Type
SELECT
    room_type,
    AVG(price) AS AveragePrice
FROM master_dataset
GROUP BY room_type
ORDER BY AveragePrice DESC;

--Top 10 Most Expensive Listings
SELECT TOP 10
    name,
    neighbourhood_cleansed,
    price
FROM master_dataset
ORDER BY price DESC;

--Average Rating
SELECT
    AVG(review_scores_rating) AS AverageRating
FROM master_dataset;

--Neighbourhoods by Average Price
SELECT
    neighbourhood_cleansed,
    AVG(price) AS AveragePrice
FROM master_dataset
GROUP BY neighbourhood_cleansed
ORDER BY AveragePrice DESC;

--Occupancy by Room Type
SELECT
    room_type,
    AVG(occupancy_rate) AS AvgOccupancy
FROM master_dataset
GROUP BY room_type;

--Listings by Neighbourhood
SELECT
    neighbourhood_cleansed,
    COUNT(*) AS TotalListings
FROM master_dataset
GROUP BY neighbourhood_cleansed
ORDER BY TotalListings DESC;

--Superhost Analysis
SELECT
    host_is_superhost,
    COUNT(*) AS TotalHosts,
    AVG(price) AS AveragePrice
FROM master_dataset
GROUP BY host_is_superhost;

