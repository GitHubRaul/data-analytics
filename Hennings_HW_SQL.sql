USE Sakila;
-- 1a
SELECT first_name, last_name 
    FROM actor;
-- 1b
SELECT concat( UPPER(first_name) ,' ', UPPER(last_name)) AS 'Actor Name' 
    FROM actor;
-- 2a
SELECT actor_id 
    FROM actor 
    WHERE first_name='Joe';
-- 2b
SELECT actor_id, first_name, last_name 
    FROM actor 
    WHERE last_name LIKE '%GEN%';
-- 2c
SELECT last_name, first_name 
    FROM actor 
    WHERE last_name LIKE '%LI%' 
    ORDER BY last_name ASC;
-- 2d
SELECT country_id, country 
    FROM country 
    WHERE country IN ('Afghanistan',  'Bangladesh', 'China');
-- 3a
ALTER TABLE actor ADD COLUMN description BLOB AFTER last_update;
-- 3b 
ALTER TABLE actor DROP COLUMN description;
-- 4a
SELECT last_name, COUNT(last_name) 
    FROM actor 
    GROUP BY last_name;
-- 4b
SELECT last_name, COUNT(last_name) AS Count 
    FROM actor 
    GROUP BY last_name HAVING count>1;
-- 4c
UPDATE actor SET first_name = 'HARPO' WHERE last_name='WILLIAMS' AND first_name='GROUCHO';
-- 4d
UPDATE actor SET first_name='GROUCHO'  WHERE first_name='HARPO';
-- 5a
SHOW CREATE TABLE address;
CREATE TABLE `address` (  
    `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,  
    `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,  
    `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,  
    `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,  
    `location` geometry NOT NULL,  
    `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
    PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),  
    SPATIAL KEY `idx_location` (`location`),  
    CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE
    ) 
-- 6a
SELECT staff.first_name, staff.last_name, address.address 
    FROM staff INNER JOIN address ON staff.address_id=address.address_id;
-- 6b
SELECT payment.amount 
    FROM payment 
    INNER JOIN staff ON staff.staff_id=payment.staff_id WHERE MONTH(payment.payment_date)=8;
-- 6c
SELECT film.title, COUNT(*) 
    FROM film 
    CROSS JOIN film_actor ON film.film_id=film_actor.film_id 
    GROUP BY film.title; 
-- 6d
SELECT title, COUNT(*) 
    FROM film WHERE title='Hunchback Impossible' 
    GROUP BY film_id;
-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) 
    AS 'Total Amount Paid' 
    FROM customer 
    INNER JOIN payment ON customer.customer_id=payment.customer_id GROUP BY customer.customer_id 
    ORDER BY customer.last_name ASC;
-- 7a
SELECT title 
    FROM film 
    WHERE film.title 
    IN (SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND film.language_id='English') ;
-- 7b
SELECT actor_id 
    FROM film_actor 
    WHERE film_id 
    IN (SELECT film.film_id FROM film WHERE film.title='Alone Trip');
-- 7c
SELECT first_name, last_name, email 
	FROM customer 
	INNER JOIN address ON address.address_id=customer.address_id
    INNER JOIN country ON country.country='Canada';
-- 7d
SELECT film.title, category.name
	FROM film
    INNER JOIN film_category ON film.film_id=film_category.film_id
    INNER JOIN category ON category.name='Family';
-- 7e
SELECT film.title, rental_rate 
    FROM film 
    ORDER BY rental_rate DESC;
-- 7f
SELECT
	CONCAT(c.city, _utf8',', cy.country) AS store,
	SUM(p.amount) AS total_sales
	FROM payment AS p
	INNER JOIN rental AS r ON p.rental_id = r.rental_id
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
	INNER JOIN store AS s ON i.store_id = s.store_id
	INNER JOIN address AS a ON s.address_id = a.address_id
	INNER JOIN city AS c ON a.city_id = c.city_id
	INNER JOIN country AS cy ON c.country_id = cy.country_id
	INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
	GROUP BY s.store_id
	ORDER BY cy.country, c.city;
-- 7g
SELECT store.store_id, city.city, country.country
	FROM store 
	INNER JOIN address ON store.address_id=address.address_id
    INNER JOIN city ON address.city_id=city.city_id
    INNER JOIN country ON city.country_id=country.country_id;
-- 7h
SELECT
	c.name AS category,
	SUM(p.amount) AS total_sales
	FROM payment AS p
	INNER JOIN rental AS r ON p.rental_id = r.rental_id
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f ON i.film_id = f.film_id
	INNER JOIN film_category AS fc ON f.film_id = fc.film_id
	INNER JOIN category AS c ON fc.category_id = c.category_id
	GROUP BY c.name
	ORDER BY total_sales DESC;
-- 8a
CREATE VIEW sales_by_film_category
AS
SELECT
  c.name AS category,
  SUM(p.amount) AS total_sales
FROM payment AS p
  INNER JOIN rental AS r ON p.rental_id = r.rental_id
  INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN film AS f ON i.film_id = f.film_id
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;
-- 8b
SELECT * FROM sales_by_film_category
-- 8c
DROP VIEW sales_by_film_category;