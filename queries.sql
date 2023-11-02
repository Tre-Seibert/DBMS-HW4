-- 1. What is the average length of films in each category? 
-- 	  List the results in alphabetical order of categories.


-- Select the category name and the average film length for each category
SELECT c.name AS category, AVG(f.length) AS avg_length
-- From the "film" table, join with "film_category" on film_id, and join with "category" on category_id
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
-- Group the results by the "category" column
GROUP BY category
-- Order the results in alphabetical order of categories
ORDER BY category;


-- 2. Which categories have the longest and shortest average 
-- film lengths?

-- Create a table named category_avg_lengths to calculate average film lengths for each category
WITH category_avg_lengths AS (
    -- Select the category name and its average film length
    SELECT c.name AS category, AVG(f.length) AS avg_length
    -- From the film table, join with film_category on film_id, and join with category on category_id
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    
    -- Group the results by the category column
    GROUP BY category
)
-- Select the category and its average length for categories with the maximum and minimum average lengths
SELECT
    category,
    avg_length
FROM category_avg_lengths
-- Find the max avg length
WHERE avg_length = (SELECT MAX(avg_length) FROM category_avg_lengths)
UNION
SELECT
    category,	 
    avg_length
FROM category_avg_lengths
-- Find the min avg length
WHERE avg_length = (SELECT MIN(avg_length) FROM category_avg_lengths);



-- 3. Which customers have rented action but not 
-- comedy or classic movies?

-- Select the customer_id, first_name, and last_name from the customer table
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
-- Check if there exists a rental of films in the 'Action' category for this customer
WHERE EXISTS (
    SELECT 1
    -- From the "rental" table, join with "inventory" on inventory_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    -- Join with film_category on film_id and category on category_id to find films in the 'Action' category
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    -- Match the rental with the customer and films in the 'Action' category
    WHERE r.customer_id = c.customer_id
    AND cat.name = 'Action'
)
-- Ensure the customer does not have rentals in the 'Comedy' or 'Classics' categories
AND NOT EXISTS (
    SELECT 1
    -- From the "rental" table, join with "inventory" on inventory_id
    FROM rental r
     -- Join with "film_category" on film_id and "category" on category_id to find films in the 'Comedy' or 'Classics' categories
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    -- Match the rental with the customer and films in the 'Comedy' or 'Classics' categories
    WHERE r.customer_id = c.customer_id
    AND cat.name IN ('Comedy', 'Classics')
);

-- 4. Which actor has appeared in the most English-language movies?

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
-- Join with the "film_actor" table to associate actors with films
JOIN film_actor fa ON a.actor_id = fa.actor_id
-- Join with the "film" table to get information about the films
JOIN film f ON fa.film_id = f.film_id
-- Join with the "language" table to filter films by the English language
JOIN language l ON f.language_id = l.language_id
-- Filter for films with the language name 'English'
WHERE l.name = 'English'
GROUP BY a.actor_id, a.first_name, a.last_name
-- Order the results by the count in descending order and limit of 1 result
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 5. How many distinct movies were rented for exactly 10 days 
-- from the store where Mike works?

SELECT COUNT(DISTINCT r.inventory_id) AS distinct_movies
FROM rental r
-- Join with the "staff" table to associate rentals with staff members
JOIN staff s ON r.staff_id = s.staff_id
-- Filter for rentals associated with staff named 'Mike'
WHERE s.first_name = 'Mike'
-- Filter for rentals with a rental duration of exactly 10 days
AND DATEDIFF(r.return_date, r.rental_date) = 10;

-- 6. Alphabetically list actors who appeared in 
-- the movie with the largest cast of actors.

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
-- Filter for film_actor records where the film_id matches the film_id of the largest cast movie
WHERE a.actor_id IN (
    SELECT actor_id
    -- From a subquery that finds the film_id with the largest cast
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM (
            SELECT film_id, COUNT(actor_id) AS actor_count
            FROM film_actor
			-- Group film_actor records by film_id and count the actors
            GROUP BY film_id
            -- Order the results by actor_count in descending order to get the largest cast. 
            ORDER BY actor_count DESC
            -- Limit to 1 result
            LIMIT 1
        ) AS largest_cast
    )
)
-- Order the results by actor first name and last name
ORDER BY a.first_name, a.last_name;
