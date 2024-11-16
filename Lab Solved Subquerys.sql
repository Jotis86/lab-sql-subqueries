USE sakila;

SELECT 
    COUNT(*) AS number_of_copies
FROM 
    inventory
WHERE 
    film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');


SELECT 
    title, 
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);
    

SELECT 
    first_name, 
    last_name
FROM 
    actor
WHERE 
    actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip'));

    
    
SELECT 
    title
FROM 
    film
WHERE 
    film_id IN (SELECT film_id FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = 'Family'));

    
    
SELECT 
    first_name, 
    last_name, 
    email
FROM 
    customer
WHERE 
    address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')));


    
-- Find the most prolific actor
SELECT 
    title
FROM 
    film
WHERE 
    film_id IN (SELECT film_id FROM film_actor WHERE actor_id = (SELECT actor_id FROM (SELECT actor_id, COUNT(film_id) AS film_count FROM film_actor GROUP BY actor_id ORDER BY film_count DESC LIMIT 1) AS prolific_actor));



-- Find the most profitable customer
SELECT 
    title
FROM 
    film
WHERE 
    film_id IN (SELECT film_id FROM inventory WHERE inventory_id IN (SELECT inventory_id FROM rental WHERE customer_id = (SELECT customer_id FROM (SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id ORDER BY total_spent DESC LIMIT 1) AS profitable_customer)));


SELECT 
    customer_id, 
    total_amount_spent
FROM 
    (SELECT 
        customer_id, 
        SUM(amount) AS total_amount_spent
    FROM 
        payment
    GROUP BY 
        customer_id) AS customer_totals
WHERE 
    total_amount_spent > (SELECT AVG(total_amount_spent) FROM (SELECT SUM(amount) AS total_amount_spent FROM payment GROUP BY customer_id) AS avg_totals);
