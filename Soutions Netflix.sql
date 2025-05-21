----QUERIES AND SOLUTION-----------


--1. Count the number of Movies vs TV Shows

select type, count(*) as total_count from netflix 
group by type;

---2. Find the most common rating for movies and TV shows

select type, rating from 
( select type, rating, count(*),
	RANK() OVER (PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
from netflix 
group by 1,2) as t1
where ranking = 1;


---3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where type= 'Movie' AND release_year = 2020;

---4. Find the top 5 countries with the most content on Netflix

select count(show_id) as num_shows, UNNEST((STRING_TO_ARRAY(country, ','))) as new_country from netflix 
group by 2
order by num_shows desc limit 5;



---5. Identify the longest movie.

select * from netflix 
where type ='Movie' AND
		duration= (select max(duration) from netflix);




---6. Find content release in the last 5 years------

select * from netflix
where (EXTRACT(YEAR from CURRENT_DATE)- 5 <=release_year);

---7. Find all the movies/TV shows by director Rajiv Chilaka

select * from netflix
where director like '%Rajiv Chilaka%';


---8. List all TV shows with more than 5 seasons

select * from netflix
where type = 'TV Show' AND 
SPLIT_PART(duration,' ',1):: numeric >5;

---9. Count the number of content items in each genre

select COUNT(*), UNNEST (STRING_TO_ARRAY(listed_in,',')) as genre 
from netflix 
group by 2 

---10. Find the average release year for content produced in a specific country

select EXTRACT (YEAR FROM TO_DATE(date_added,'month DD, YEAR')) AS  year,
	count(*) as yearly_content,
	ROUND(count(*):: numeric / (select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content_per_year 
	from netflix 
	where country ='India'
	group by 1



---11. List all movies that are documentaries

select title, type, listed_in, release_year from netflix
where type ='Movie' AND listed_in ilike '%Documentaries%';

---12. Find all content without a director

select title, director, release_year from netflix
where director is NULL;


---13. Find how many movies actor 'Salman Khan' appeared in the last 10 years

select title, type, casts, release_year from netflix
where (EXTRACT(YEAR from CURRENT_DATE)- 10 <=release_year) AND casts ilike '%Salman Khan%';


---14. Find the top 10 actors who have appeared in the highest number of movies produced in india


select count(*), UNNEST (STRING_TO_ARRAY(casts,',')) as actor from netflix
where country ilike '%India%' AND type = 'Movie' 
group by 2 order by 1 desc limit 10;


---15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
---Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

WITH new_table AS (
    SELECT
        *,
        CASE
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
            ELSE 'Good Content'
        END AS category
    FROM netflix
)
SELECT
    category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY 1;









select count(*) as total_show from netflix;