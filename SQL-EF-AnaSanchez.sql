-- Evaluación final SQL - Ana Sánchez de la Fuente

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title -- Se introduce DISCTINC para evitar duplicados
FROM film;

    
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating
FROM film
WHERE rating = 'PG-13'; /*Condición en rating para que aparezcan solo las "PG-13" 
						(incluyo rating en la consulta para confirmar que está ok, pero no lo pide el enunciado)*/


/* 3. Encuentra el título y la descripción de todas las películas 
que contengan la palabra "amazing" en su descripción.*/
SELECT title, `description`
FROM film
WHERE `description` LIKE '%amazing%'; -- Condición en descripción para filtrar por solo las que incluye 'amazing'


/* 4. Encuentra el título de todas las películas que tengan una 
duración mayor a 120 minutos.*/
SELECT title, `length` AS duracion
FROM film
WHERE `length`> 120; /*Condición en length para que aparezcan solo las >120
						(incluyo length en la consulta para confirmar que está ok, pero no lo pide el enunciado)*/


-- 5. Recupera los nombres de todos los actores
SELECT first_name, last_name
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%'; -- Condición en apellido para filtra por 'Gibson'


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20; -- Condición en actor_id, lo incluyo en la consulta para ver que está ok, pero no lo pide el enunciado


/*8. Encuentra el título de las películas en la tabla film que no sean 
ni "R" ni "PG-13" en cuanto a su clasificación*/
SELECT title, rating
FROM film
WHERE rating NOT IN ('R', 'PG-13'); -- Condición en rating, incluyo rating en la consulta para ver que está ok, pero no lo pide el enunciado


/* 9. Encuentra la cantidad total de películas en cada clasificación 
 de la tabla film y muestra la clasificación junto con el recuento*/
 SELECT rating, COUNT(rating) AS Recuento -- cuento rating por coherencia pero podría contar *
 FROM film
 GROUP BY rating; -- Agrupo por rating
 
 
 /* 10. Encuentra la cantidad total de películas alquiladas por cada cliente 
 y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas*/
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS N_pelis_alquiladas -- recuento pelis alquiladas
FROM customer c
INNER JOIN rental r -- uno a tabla rental por la columna comun
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name; -- agrupo por id del cliente (más su nombre y apellido por coherencia)
 
 
 /* 11. Encuentra la cantidad total de películas alquiladas por categoría 
 y muestra el nombre de la categoría junto con el recuento de alquileres.*/
 SELECT ca.`name` as Nombre_categoria, COUNT(re.rental_id) AS Recuento_alquileres
 FROM rental AS re
 INNER JOIN inventory AS inv
 ON re.inventory_id = inv.inventory_id
 INNER JOIN film AS fi
 ON inv.film_id = fi.film_id
 INNER JOIN film_category AS fc
 ON fi.film_id = fc.film_id
 INNER JOIN category AS ca
 ON fc.category_id = ca.category_id
 GROUP BY ca.`name`;
 -- Necesito 5 tablas, uno todas primero y después incluyo en el select el nombre de la categoría, hago un recuento del rental_id
 -- (para saber numero de alquileres) y agrupo por categoría para saber número de alquileres por categoría
 
 
 /* 12. Encuentra el promedio de duración de las películas para cada 
 clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.*/

 -- Me doy cuenta repasando de que lo que me piden puede ser categoría o rating, incluyo ambas
 -- categoría -----------------------------------------------------------------
SELECT ca.`name` as Nombre_categoria, AVG(`length`) AS media_duracion
FROM film AS fi
INNER JOIN film_category AS fc
ON fi.film_id = fc.film_id
INNER JOIN category AS ca
ON fc.category_id = ca.category_id
GROUP BY ca.`name`; -- agrupo por categoría

-- rating -----------------------------------------------------------------
SELECT rating, AVG(`length`) AS media_duracion
FROM film
GROUP BY rating; -- Agrupo por rating


 -- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
 SELECT ac.first_name AS nombre, ac.last_name AS apellido
 FROM film AS fi
 INNER JOIN film_actor AS fa
 ON fi.film_id = fa.film_id
 INNER JOIN actor as ac
 ON fa.actor_id = ac.actor_id
 WHERE fi.title = 'Indian Love';
 -- Uno las tres tablas de las que necesito información y agrego una condición para que me devuelva solo los actores de Indian Love


 -- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, `description`
FROM film
WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%'; -- Incluyo la condición y añado la descrición a la consulta para confirmar que está ok


-- 15. Hay algún actor que no aparecen en ninguna película en la tabla film_actor
SELECT ac.actor_id, ac.first_name AS nombre, ac.last_name AS apellido
FROM actor AS ac
LEFT JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
WHERE fa.film_id IS NULL; 
-- El resultado está vacío porque no hay ningún null en film_id, es decir, todos los actores está asociados a alguna película


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year AS Año_lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010; -- Son todas de 2006
 
 
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT fi.title AS titulo, ca.`name` AS categoria
FROM film AS fi
INNER JOIN film_category AS fc
ON fi.film_id = fc.film_id
INNER JOIN category AS ca
ON fc.category_id = ca.category_id
WHERE ca.`name` = 'Family';
-- Uno las tres tablas que necesito y filtro las de categoría family con una condición (incluyo la categoría para confirmar que está ok)


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT ac.first_name AS nombre, ac.last_name AS apellido, COUNT(fi.film_id) AS recuento_pelis
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS fi
ON fa.film_id = fi.film_id
GROUP BY ac.first_name, ac.last_name
HAVING recuento_pelis > 10
ORDER BY recuento_pelis DESC;
-- Uno las 3 tablas que necesito, agrupo por actor y filtro aquellos que aparezcan en más de 10 pelis


/* 19. Encuentra el título de todas las películas que son "R" y 
tienen una duración mayor a 2 horas en la tabla film.*/
SELECT title, rating, `length` AS duracion
FROM film
WHERE rating = 'R' AND `length`> 120; -- Condición para filtrar, Incluyo ambas en la consulta para confirmar que está ok


/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior
 a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.*/
 SELECT ca.`name` AS categoria , AVG(fi.`length`) AS media_duracion
 FROM category AS ca
 INNER JOIN film_category as fc
 ON ca.category_id = fc.category_id
 INNER JOIN film AS fi
 ON fc.film_id = fi.film_id
 GROUP BY ca.`name`
 HAVING media_duracion > 120;
 -- Uno las tablas que necesito, agrupo por categoría y calculo la media de duración de las categorías con una media superior a 2 horas
 
 
 /* 21. Encuentra los actores que han actuado en al menos 5 películas
 y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/
SELECT ac.first_name AS nombre, ac.last_name AS apellido, COUNT(fi.film_id) AS recuento_pelis
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS fi
ON fa.film_id = fi.film_id
GROUP BY ac.first_name, ac.last_name
HAVING recuento_pelis > 5
ORDER BY recuento_pelis DESC; -- traído del ejercicio 18
 
 
/*22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días
y luego selecciona las películas correspondientes.*/
SELECT DISTINCT fi.title AS titulo, fi.rental_duration
FROM film AS fi
INNER JOIN inventory AS inv
ON fi.film_id = inv.film_id
INNER JOIN rental AS re
ON inv.inventory_id = re.inventory_id
WHERE fi.rental_duration > 5
GROUP BY fi.title, fi.rental_duration;

-- --------------------- subconsulta ------------------
SELECT title
FROM film
WHERE film_id IN (SELECT fi.film_id
					FROM film AS fi
					INNER JOIN inventory AS inv
					ON fi.film_id = inv.film_id
					INNER JOIN rental AS re
					ON inv.inventory_id = re.inventory_id
					WHERE fi.rental_duration > 5);


/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película 
de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado 
en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
SELECT ac.first_name AS nombre, ac.last_name as APELLIDO, ca.`name`AS categoria
FROM actor AS ac
INNER JOIN film_actor AS fa
ON ac.actor_id = fa.actor_id
INNER JOIN film AS fi
ON fa.film_id = fi.film_id
INNER JOIN film_category AS fc
ON fi.film_id = fc.film_id
INNER JOIN category AS ca
ON fc.category_id = ca.category_id
WHERE NOT ca.`name`= 'Horror';

-- --------------------- subconsulta ------------------
SELECT ac.first_name AS nombre, ac.last_name AS apellido
FROM actor AS ac
WHERE ac.actor_id NOT IN (
						SELECT fa.actor_id
						FROM film_actor AS fa
						INNER JOIN film AS fi 
						ON fa.film_id = fi.film_id
						INNER JOIN film_category AS fc 
						ON fi.film_id = fc.film_id
						INNER JOIN category AS ca 
						ON fc.category_id = ca.category_id
						WHERE ca.`name` = 'Horror');
 

/*24. BONUS: Encuentra el título de las películas que son comedias y
tienen una duración mayor a 180 minutos en la tabla film.*/
SELECT fi.title AS titulo, ca.`name`AS categoria, fi.`length`AS duracion
FROM film AS fi
INNER JOIN film_category AS fc
ON fi.film_id = fc.film_id
INNER JOIN category AS ca
ON fc.category_id = ca.category_id
WHERE ca.`name` = 'Comedy' AND fi.`length` > 180;
-- Uno las tablas que necesito e incluyo en la condición los dos requisitos para que me devuelva çunicamente lo que pido


/* 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.*/

-- necesito tabla actores (nb y apellido), tabla film (películas han actuado), film_actor (punto de unión) 
-- lo que quiero ver en el resultado de la consulta final son el nombre y apellidos de los actores 
SELECT a1.first_name AS nombre_1,
       a1.last_name AS apellido_1,
       a2.first_name AS nombre_2,
       a2.last_name AS apellido_2,
       COUNT(DISTINCT fi.film_id) AS pelis_juntos -- y el número de pelis donde han coincidido
FROM actor AS a1 -- Al hacer un SELF JOIN necesito diferenciar ambas tablas (son la misma, asi que una es a1 y la otra a2
INNER JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id -- pelis en las que ha actuado el primer actor
INNER JOIN film AS fi ON fa1.film_id = fi.film_id
INNER JOIN film_actor AS fa2 ON fi.film_id = fa2.film_id -- pelis en las que ha actuado el segundo actor
INNER JOIN actor AS a2 ON fa2.actor_id = a2.actor_id AND a1.actor_id < a2.actor_id -- para no contar la misma pareja 2 veces
GROUP BY a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name
HAVING COUNT(DISTINCT fi.film_id) > 1;

