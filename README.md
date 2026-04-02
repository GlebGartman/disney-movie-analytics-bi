# Disney Movies Analytics Dashboard

## Описание проекта

Разработка интерактивного аналитического дашборда в Power BI для анализа кассовых сборов фильмов Disney с использованием SQL для подготовки и трансформации данных. 
Проект направлен на исследование динамики выручки, жанровой структуры и рейтингов фильмов с учетом инфляции, а также на создание удобного инструмента для анализа ключевых метрик и принятия решений

---

## Цель проекта

Построить аналитический инструмент, позволяющий:

- анализировать кассовые сборы фильмов Disney  
- учитывать влияние инфляции на выручку  
- сравнивать фильмы по годам и жанрам  
- выделять самые успешные фильмы  
- визуализировать ключевые бизнес-метрики  

---

## Используемый стек

- SQL (MS SQL Server)
- Power BI
- DAX
- DBeaver

---

## Источник данных

Данные загружаются из MS SQL Server:

- Server: phb-testsql01.database.windows.net  
- Database: phb-test-db  
- Table: disney_movies_total_gross  

---

## Подготовка данных (SQL)

Подключился к MS SQL Server через DBeaver и сформировал SQL-запрос для предобработки данных

В рамках запроса:

- Привел release_date к типу DATE  
- Заменил NULL значения в genre на Not specified через COALESCE  
- Добавил колонку release_year  
- Рассчитал рейтинг фильмов внутри каждого года  

Для ранжирования использовал DENSE_RANK, так как он формирует последовательный рейтинг без пропусков и корректно обрабатывает одинаковые значения, что делает визуализацию более понятной

Также добавлена сортировка по годам для удобства анализа

## Формирование витрины данных (SQL)

**1. Подсчет метрик**

```sql
WITH films AS (
    SELECT
        movie_title,
        CAST(release_date AS DATE) AS release_date,
        COALESCE(genre, 'Not specified') AS genre,
        mpaa_rating,
        total_gross,
        inflation_adjusted_gross,
        YEAR(CAST(release_date AS DATE)) AS release_year,
        DENSE_RANK() OVER (
            PARTITION BY YEAR(CAST(release_date AS DATE)) 
            ORDER BY total_gross DESC
        ) AS gross_index
    FROM [phb-test-db].dbo.disney_movies_total_gross
)
```

**Тут будет картинка**

**2. Топ самых кассовых фильмов по годам**

```sql
SELECT 
    release_year, 
    genre, 
    movie_title, 
    total_gross, 
    inflation_adjusted_gross 
FROM films
WHERE gross_index = 1;
```


**3. Сборы по жанрам**
```sql
SELECT 
    genre, 
    SUM(CAST(total_gross AS BIGINT)) AS sbory, 
    SUM(CAST(inflation_adjusted_gross AS BIGINT)) AS sbory_inflation 
FROM films
GROUP BY genre
ORDER BY genre;
```

**4. Общие сборы и количество фильмов**
```sql
SELECT  
    genre, 
    release_year, 
    SUM(CAST(total_gross AS BIGINT)) AS sbory, 
    COUNT(movie_title) AS kolvo 
FROM films
GROUP BY genre, release_year;
```
