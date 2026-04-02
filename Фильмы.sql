-- Основной Запрос
WITH films as (
SELECT
 movie_title,
 CAST(release_date AS DATE) as release_date,
 COALESCE(genre, 'Not specified') AS genre,
 mpaa_rating,
 total_gross,
 inflation_adjusted_gross,
 YEAR(CAST(release_date AS DATE)) as release_year,
 DENSE_RANK() OVER(PARTITION BY YEAR(CAST(release_date AS DATE)) ORDER BY total_gross DESC) as gross_index
FROM [phb-test-db].dbo.disney_movies_total_gross
--ORDER BY release_year
)

-- Список самых кассовых фильмов года
/* SELECT release_year, genre, movie_title, total_gross, inflation_adjusted_gross FROM films
WHERE gross_index = 1   */

--Сборы по жанрам (в алфавитном порядке)
/* SELECT genre, SUM(CAST(total_gross as BIGINT)) as sbory, SUM(CAST(inflation_adjusted_gross as BIGINT)) as sbory_inflation FROM films
GROUP BY genre
ORDER BY genre  */

-- Общая Сумма Сборов и кол-во фильмов
/*  SELECT  genre, release_year, SUM(CAST(total_gross as BIGINT)) as sbory, COUNT(movie_title) as kolvo FROM films
GROUP BY genre, release_year */ 



/* SELECT id FROM df
GROUP BY id
HAVING MIN(mark) > 3 */

WITH zvonok as (
SELECT call_date, abon_id, duration, sum(duration) over(PARTITION BY call_date) as sum_duration
FROM calls_agg
)

SELECT call_date, abon_id, duration, duration / sum_duration::NUMERIC
FROM zvonok

20.01.2017 1   1,25
20.01.2017 1   1,25

