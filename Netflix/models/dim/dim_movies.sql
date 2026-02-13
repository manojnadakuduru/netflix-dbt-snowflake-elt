WITH src_movies AS (
    SELECT * FROM {{ ref('src_movies') }}
)
SELECT
    movie_id,
    INITCAP(TRIM(title)) AS movie_title,
    SPLIT(genres, '|') AS genre_array,
    genres
FROM src_movies

--In SELECT * FROM {{ ref('src_movies') }}, we are referencing the output of the 
--script src_movies.sql and using it here. 
--Basically, here we are creating a temporary named result (CTE) that holds the data 
--of src_movies and writing a query on top of it to make the transformations.
--This is the core of DBT functionality.

--Here by referencing other models, we are creating a dependency graph.