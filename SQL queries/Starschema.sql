CREATE DATABASE Airbnb_BI;
GO

USE Airbnb_BI;
GO

CREATE TABLE Dim_Property
(
    property_key INT IDENTITY(1,1) PRIMARY KEY,
    listing_id INT,
    property_type VARCHAR(100),
    room_type VARCHAR(100),
    accommodates INT,
    bedrooms FLOAT,
    beds FLOAT,
    bathrooms FLOAT
);

CREATE TABLE Dim_Host
(
    host_key INT IDENTITY(1,1) PRIMARY KEY,
    host_id BIGINT,
    host_name VARCHAR(200),
    host_is_superhost VARCHAR(10),
    host_identity_verified VARCHAR(10),
    host_listings_count INT
);

CREATE TABLE Dim_Neighbourhood
(
    neighbourhood_key INT IDENTITY(1,1) PRIMARY KEY,
    neighbourhood VARCHAR(100),
    neighbourhood_group VARCHAR(100)
);

CREATE TABLE Dim_Date
(
    date_key INT IDENTITY(1,1) PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    quarter INT,
    day INT,
    weekday_name VARCHAR(20)
);

CREATE TABLE Fact_Airbnb
(
    fact_key INT IDENTITY(1,1) PRIMARY KEY,

    property_key INT,
    host_key INT,
    neighbourhood_key INT,
    date_key INT,

    price FLOAT,
    availability_30 INT,
    availability_60 INT,
    availability_90 INT,
    availability_365 INT,

    occupancy_rate FLOAT,
    total_reviews INT,
    review_scores_rating FLOAT,


    FOREIGN KEY(property_key)
        REFERENCES Dim_Property(property_key),

    FOREIGN KEY(host_key)
        REFERENCES Dim_Host(host_key),

    FOREIGN KEY(neighbourhood_key)
        REFERENCES Dim_Neighbourhood(neighbourhood_key),

    FOREIGN KEY(date_key)
        REFERENCES Dim_Date(date_key)
);



