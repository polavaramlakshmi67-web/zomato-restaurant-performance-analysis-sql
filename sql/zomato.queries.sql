CREATE DATABASE zomato_analysis;
USE zomato_analysis;

CREATE TABLE zomato (
    restaurant_id INT,
    restaurant_name VARCHAR(100),
    country_code INT,
    city VARCHAR(100),
    cuisines VARCHAR(255),
    average_cost_for_two INT,
    currency VARCHAR(50),
    has_table_booking VARCHAR(3),
    has_online_delivery VARCHAR(3),
    aggregate_rating DECIMAL(2,1),
    votes INT
);

SELECT * FROM zomato;
SELECT *
FROM zomato
LIMIT 10;


--  Total Restaurants
SELECT COUNT(*) AS total_restaurants
FROM zomato;

-- Q2 Total Cities
SELECT COUNT(DISTINCT city) AS total_cities
FROM zomato;

-- Q3 Total Cuisines
SELECT COUNT(DISTINCT cuisine) AS total_cuisines
FROM zomato;

-- Q4 Average Rating
SELECT ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato;

-- Q5 Average Cost For Two
SELECT ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato;

-- Q6 Minimum Rating
SELECT MIN(aggregate_rating) AS min_rating
FROM zomato;

-- Q7 Maximum Rating
SELECT MAX(aggregate_rating) AS max_rating
FROM zomato;

-- Q8 Minimum Cost For Two
SELECT MIN(average_cost_for_two) AS min_cost
FROM zomato;

-- Q9 Maximum Cost For Two
SELECT MAX(average_cost_for_two) AS max_cost
FROM zomato;

--  Top Cities By Restaurant Count
SELECT city,
       COUNT(*) AS restaurant_count
FROM zomato
GROUP BY city
ORDER BY restaurant_count DESC;

--  Highest Rated Cities
SELECT city,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY city
ORDER BY avg_rating DESC;

--  Most Expensive Cities
SELECT city,
       ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato
GROUP BY city
ORDER BY avg_cost DESC;

--  Cheapest Cities
SELECT city,
       ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato
GROUP BY city
ORDER BY avg_cost ASC;

--  Top 10 Rated Restaurants
SELECT restaurant_name,
       aggregate_rating
FROM zomato
ORDER BY aggregate_rating DESC
LIMIT 10;

--  Bottom 10 Rated Restaurants
SELECT restaurant_name,
       aggregate_rating
FROM zomato
ORDER BY aggregate_rating
LIMIT 10;

--  Most Expensive Restaurants
SELECT restaurant_name,
       average_cost_for_two
FROM zomato
ORDER BY average_cost_for_two DESC
LIMIT 10;

-- Cheapest Restaurants
SELECT restaurant_name,
       average_cost_for_two
FROM zomato
ORDER BY average_cost_for_two
LIMIT 10;

--  Restaurants Above Average Rating
SELECT restaurant_name,
      aggregate_rating
FROM zomato
WHERE aggregate_rating >
(
SELECT AVG(aggregate_rating)
FROM zomato
);

--  Restaurants Above Average Cost
SELECT restaurant_name,
       average_cost_for_two
FROM zomato
WHERE average_cost_for_two >
(
SELECT AVG(average_cost_for_two)
FROM zomato
);

-- Most Popular Cuisines
SELECT cuisines,
       COUNT(*) AS total_restaurants
FROM zomato
GROUP BY cuisines
ORDER BY total_restaurants DESC;

--  Highest Rated Cuisines
SELECT cuisines,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY cuisines
ORDER BY avg_rating DESC;

--  Most Expensive Cuisines
SELECT cuisines,
       ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato
GROUP BY cuisines
ORDER BY avg_cost DESC;

--  Restaurants Offering Online Delivery
SELECT has_online_delivery,
       COUNT(*) AS total_restaurants
FROM zomato
GROUP BY has_online_delivery;

-- Online Delivery vs Rating
SELECT has_online_delivery,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY has_online_delivery;

--  Online Delivery vs Cost
SELECT has_online_delivery,
       ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato
GROUP BY has_online_delivery;

--  Restaurants Offering Table Booking
SELECT has_table_booking,
       COUNT(*) AS total_restaurants
FROM zomato
GROUP BY has_table_booking;

--  Table Booking vs Rating
SELECT has_table_booking,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY has_table_booking;

--  Table Booking vs Cost
SELECT has_table_booking,
       ROUND(AVG(average_cost_for_two),2) AS avg_cost
FROM zomato
GROUP BY has_table_booking;

-- Cities Having More Than 50 Restaurants
SELECT city,
       COUNT(*) AS restaurant_count
FROM zomato
GROUP BY city
HAVING COUNT(*) > 50;

--  Cities Having Average Rating Above 4
SELECT city,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY city
HAVING AVG(aggregate_rating) > 4;

--  Restaurant Rating Categories
SELECT
CASE
    WHEN aggregate_rating >= 4.5 THEN 'Excellent'
    WHEN aggregate_rating >= 4 THEN 'Good'
    WHEN aggregate_rating >= 3 THEN 'Average'
    ELSE 'Poor'
END AS category,
COUNT(*) AS total_restaurants
FROM zomato
GROUP BY category;

--  Cost Categories
SELECT
CASE
    WHEN average_cost_for_two < 500 THEN 'Budget'
    WHEN average_cost_for_two BETWEEN 500 AND 1500 THEN 'Mid Range'
    ELSE 'Premium'
END AS cost_category,
COUNT(*) AS total_restaurants
FROM zomato
GROUP BY cost_category;

-- Restaurants With Rating Between 4 And 5
SELECT restaurant_name,
       aggregate_rating
FROM zomato
WHERE aggregate_rating BETWEEN 4 AND 5;

-- Restaurants In Selected Cities
SELECT *
FROM zomato
WHERE city IN ('Hyderabad','Bangalore','Chennai');

--  Restaurants Starting With Cafe
SELECT *
FROM zomato
WHERE restaurant_name LIKE 'Cafe%';

--  Restaurants Ending With House
SELECT *
FROM zomato
WHERE restaurant_name LIKE '%House';

-- Cities With Average Rating Above 4 Using CTE
WITH city_rating AS
(
SELECT city,
       AVG(aggregate_rating) AS avg_rating
FROM zomato
GROUP BY city
)
SELECT *
FROM city_rating
WHERE avg_rating > 4;

-- Restaurant Ranking Within City
SELECT city,
       restaurant_name,
       rating,
       RANK() OVER
       (
       PARTITION BY city
       ORDER BY rating DESC
       ) AS rank_no
FROM zomato;

--  Top Restaurant In Each City
SELECT *
FROM
(
    SELECT city,
           restaurant_name,
           aggregate_rating,
           ROW_NUMBER() OVER (
               PARTITION BY city
               ORDER BY aggregate_rating DESC
           ) AS rn
    FROM zomato
) ranked_restaurants
WHERE rn = 1;



-- Dense Rank Restaurants Within City
SELECT city,
       restaurant_name,
       rating,
       DENSE_RANK() OVER
       (
       PARTITION BY city
       ORDER BY rating DESC
       ) AS dense_rank_no
FROM zomato;

--  Running Total Of Cost
SELECT restaurant_name,
       average_cost_for_two,
       SUM(average_cost_for_two) OVER
       (
       ORDER BY cost_for_two
       ) AS running_total
FROM zomato;

--  Average Rating By City Using Window Function
SELECT city,
       restaurant_name,
       aggregate_rating,
       AVG(aggregate_rating) OVER
       (
       PARTITION BY city
       ) AS city_avg_rating
FROM zomato;

--  Highest Rated Restaurant In Each City
SELECT *
FROM zomato z1
WHERE aggregate_rating =
(
SELECT MAX(z2.aggregate_rating)
FROM zomato z2
WHERE z1.city = z2.city
);

--  Count Restaurants By City And Cuisine
SELECT city,
       cuisines,
       COUNT(*) AS total_restaurants
FROM zomato
GROUP BY city,cuisines
ORDER BY total_restaurants DESC;

--  Top 5 Cities By Average Rating
SELECT city,
       ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM zomato
GROUP BY city
ORDER BY avg_rating DESC
LIMIT 5;