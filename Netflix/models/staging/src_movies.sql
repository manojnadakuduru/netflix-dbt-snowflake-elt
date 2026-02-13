WITH raw_movies as(
    select *from movielens.raw.raw_movies
)
select 
    movieId as movie_id,
    title,
    genres
From raw_movies