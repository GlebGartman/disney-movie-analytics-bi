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

### 📊 Результаты подсчёта метрик
![Результаты метрик](https://drive.google.com/uc?export=view&id=1WgIgv1px6wxeVCfvde-4Cyuqe3XyLuip)

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
![Топ самых кассовых фильмов](https://drive.google.com/uc?export=view&id=1MVZ_J2mPQKqYz6H30jkqCjcLuL4eoK54)

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

![Сборы по жанрам](https://drive.google.com/uc?export=view&id=1wJyRTVy-fhzN7iu1gH1PxxpNdzNqUIwN)

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

#### 💰 Суммарные сборы
![Суммарные сборы](https://drive.google.com/uc?export=view&id=1BubbQcBcyqYz5GOu5VRAGHbmgsDwv-dE)

---

#### 🎥 Количество фильмов
![Количество фильмов](https://drive.google.com/uc?export=view&id=107bBiIDxwQPNXBiL-qJczH71ku4zsVrB)

---

#### 📊 Среднее количество фильмов в год
![Среднее количество фильмов](https://drive.google.com/uc?export=view&id=1ob3JD-rWuEEOb9CZBQewt47J9xOvk6zA)

---

## 🎛 Фильтры и управление дашбордом

В дашборде реализованы следующие элементы управления:

- `Жанр` — позволяет отбирать фильмы по выбранным категориям  
- `Период (годы)` — ограничивает анализ по году релиза  
- `Тип сборов (Gross Type)` — выбор между обычными сборами и сборами с учётом инфляции  
- `Формат отображения (Gross Display)` — отображение значений:
  - в полном виде (`Full`)
  - в миллионах (`Millions`)

Все элементы управления влияют на визуализации и позволяют гибко анализировать данные.

![Фильтры](https://drive.google.com/uc?export=view&id=1X-46-B3DHRP7x-ohTB0Sp46kxWI6xvyb)
