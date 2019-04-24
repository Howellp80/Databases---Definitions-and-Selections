-- Parker Howell
-- CS 340
-- Wolford 
-- Winter 2017


#1 Find all films with maximum length and minimum rental duration (compared to all other films). 
#In other words let L be the maximum film length, and let R be the minimum rental duration in the table film. You need to find all films with length L and rental duration R.
#You just need to return attribute film id for this query. 

-- There is some confusion on Piazza about this question... I solved it based on the reply by prof Wolford in the Follow Up Discussion area in @142:
-- Student - "So, I would think you actually mean to select one film that has the max length AND the minimum duration of the film.
-- Without stating how I queried that, it should be SWEET Brotherhood. Could I interpret the question that way and be correct (seeing you are saying AND and not OR)?"
-- Justin Wolford - "We will accept both. The wording was sub-optimal."

SELECT f.film_id FROM film f
where f.length = (SELECT MAX(length) FROM `film` f)
and f.rental_duration = (SELECT MIN(rental_duration) FROM `film` f);




#2 We want to find out how many of each category of film ED CHASE has started in so return a table with category.name and the count
#of the number of films that ED was in which were in that category order by the category name ascending (Your query should return every category even if ED has been in no films in that category).

SELECT tbl1.name, IFNULL(tbl2.count, 0) AS count
FROM (
	SELECT DISTINCT c.name 
	FROM category c) AS tbl1
LEFT JOIN (
	SELECT c.name, COUNT(f.film_id) AS count
	FROM `actor` a INNER JOIN
	`film_actor` fa ON a.actor_id = fa.actor_id INNER JOIN
	`film` f ON fa.film_id = f.film_id INNER JOIN
	`film_category` fc ON f.film_id = fc.film_id RIGHT JOIN
	`category` c ON fc.category_id = c.category_id
	WHERE a.first_name = "ED" AND a.last_name = "CHASE"
	GROUP BY c.name) AS tbl2
ON tbl1.name = tbl2.name
ORDER BY tbl1.name ASC;




#3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
#That is the result should list the names of all of the actors(even if an actor has not been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT tbl1.first_name, tbl1.last_name, IFNULL(tbl2.length, 0) AS totalMinutes
FROM (
	SELECT a.actor_id, a.first_name, a.last_name 
	FROM actor a) AS tbl1
LEFT JOIN (
	SELECT a.actor_id, a.first_name, a.last_name, SUM(f.length) AS length 
	FROM `actor` a INNER JOIN 
	`film_actor` fa ON a.actor_id = fa.actor_id INNER JOIN 
	`film` f ON fa.film_id = f.film_id INNER JOIN 
	`film_category` fc ON f.film_id = fc.film_id INNER JOIN 
	`category` c ON fc.category_id = c.category_id 
	WHERE c.name = "Sci-Fi" 
	GROUP BY a.actor_id) AS tbl2
ON tbl1.actor_id = tbl2.actor_id;




#4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT a.first_name, a.last_name
FROM `actor` a 
WHERE a.actor_id NOT IN (
	SELECT a.actor_id
	FROM `actor` a INNER JOIN 
	`film_actor` fa ON a.actor_id = fa.actor_id INNER JOIN 
	`film` f ON fa.film_id = f.film_id INNER JOIN 
	`film_category` fc ON f.film_id = fc.film_id INNER JOIN 
	`category` c ON fc.category_id = c.category_id 
	WHERE c.name = "Sci-Fi");




#5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
#Order the results by title, descending (use ORDER BY title DESC at the end of the query)
#Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
#the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT tbl1.title FROM (SELECT f.title FROM `film` f INNER JOIN
	`film_actor` fa ON f.film_id = fa.film_id INNER JOIN
	`actor` a ON fa.actor_id = a.actor_id
	WHERE a.first_name = "KIRSTEN" AND a.last_name = "PALTROW") AS tbl1
INNER JOIN (
	SELECT f.title FROM `film` f INNER JOIN
	`film_actor` fa ON f.film_id = fa.film_id INNER JOIN
	`actor` a ON fa.actor_id = a.actor_id
	WHERE a.first_name = "WARREN" AND a.last_name = "NOLTE") AS tbl2
WHERE tbl1.title = tbl2.title
ORDER BY `title` DESC;