KPI

SELECT 'Total Sales Millions' as metric, CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS value FROM blinkit
UNION ALL
SELECT 'Avg Sales', CAST(AVG(Total_Sales) AS DECIMAL(10,0)) FROM blinkit
UNION ALL  
SELECT 'No of Items', CAST(COUNT(*) AS DECIMAL(10,0)) FROM blinkit
UNION ALL
SELECT 'Avg Rating', CAST(AVG(Rating) AS DECIMAL(10,2)) FROM blinkit;


1 -- Total Sales in Millions
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions FROM blinkit

2 -- Average Sales per Item
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit

3 -- Total Number of Items
SELECT COUNT (*) AS No_of_items FROM blinkit

4 -- Total Sales for Low-Fat Items (2022 Outlets)
SELECT CAST(AVG(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Low_Fat FROM blinkit
WHERE outlet_establishment_year = 2022

5 -- Total Low-Fat Sales (2022 Outlets)
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Low_Fat FROM blinkit
WHERE outlet_establishment_year = 2022

6 -- Count of Low-Fat Items (2022 Outlets)
SELECT COUNT(*) AS Number_of_items FROM blinkit
WHERE outlet_establishment_year = 2022

General Ratings and Fat Content Standardization

7 -- Average Item Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_rating FROM blinkit

8 -- Standardize Fat Content Categories (UPDATE)

UPDATE blinkit
SET item_fat_content =
    CASE
        WHEN LOWER(item_fat_content) IN ('lf', 'low fat', 'low_fat')
            THEN 'Low Fat'
        WHEN LOWER(item_fat_content) IN ('reg', 'regular')
            THEN 'Regular'
        ELSE item_fat_content
    END;

9 -- Total Sales by Fat Content
SELECT item_fat_content, ROUND(SUM(Total_sales),0) AS Total_sales
From blinkit
GROUP BY item_fat_content

Item-Type Performance

10 --  Top 5 Item Types by Sales (with Fat Content)
SELECT
    item_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,1)) AS avg_sales,
    COUNT(*) AS no_of_items,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM blinkit
GROUP BY item_type, item_fat_content
ORDER BY total_sales DESC
LIMIT 5;

11 -- Item type by total sales
SELECT
    item_type,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,1)) AS avg_sales,
    COUNT(*) AS no_of_items,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM blinkit
GROUP BY item_type
ORDER BY total_sales DESC;

Outlet Location Analysis

12 -- Low-Fat vs Regular Sales by Location Type

SELECT
    outlet_location_type,
    COALESCE(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN total_sales END), 0) AS low_fat,
    COALESCE(SUM(CASE WHEN item_fat_content = 'Regular' THEN total_sales END), 0) AS regular
FROM blinkit
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

13 -- Total Sales by Establishment Year (Ascending/Total Sales Order)
SELECT
    outlet_establishment_year,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales
FROM blinkit
GROUP BY outlet_establishment_year
ORDER BY total_sales ASC;

14 -- Comprehensive Metrics by Establishment Year
SELECT
    outlet_establishment_year,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales
FROM blinkit
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year ASC;

15 -- Total sales, average sales, no of items, average rating, sales percentage based on outlet establishment year
SELECT
    outlet_establishment_year,
    CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales,
    CAST(AVG(total_sales) AS DECIMAL(10,1)) AS avg_sales,
    COUNT(*) AS no_of_items,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS avg_rating
FROM blinkit
GROUP BY outlet_establishment_year
ORDER BY total_sales DESC;

16 -- Total sales, average sales, no of items, average rating, sales percentage based on location 

WITH location_metrics AS (
    SELECT
        outlet_location_type,
        SUM(total_sales) AS total_sales,
        AVG(total_sales) AS avg_sales,
        COUNT(*) AS no_of_items,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY outlet_location_type
)
SELECT
    outlet_location_type,
    CAST(total_sales AS DECIMAL(10,2)),
    CAST(avg_sales AS DECIMAL(10,1)),
    no_of_items,
    CAST(avg_rating AS DECIMAL(10,2)),
    CAST(total_sales * 100.0 / SUM(total_sales) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM location_metrics
ORDER BY total_sales DESC;

17 -- Sales Percentage by Outlet Size

WITH outlet_totals AS (
    SELECT 
        outlet_size,
        CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales
    FROM blinkit
    GROUP BY outlet_size
)
SELECT
    outlet_size,
    total_sales,
    CAST(total_sales * 100.0 / SUM(total_sales) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM outlet_totals
ORDER BY total_sales DESC;

18 -- Location Sales with CTE Percentage (Corrected)
WITH outlet_totals AS (
    SELECT 
        outlet_location_type,
        CAST(SUM(total_sales) AS DECIMAL(10,2)) AS total_sales
    FROM blinkit
    GROUP BY outlet_location_type
)
SELECT
    outlet_location_type,
    total_sales,
    CAST(total_sales * 100.0 / SUM(total_sales) OVER() AS DECIMAL(10,2)) AS sales_percentage
FROM outlet_totals
ORDER BY total_sales DESC;
















