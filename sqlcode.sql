/*
CREATE TABLE appleStore_description AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4
*/

/* Check whether Applestore.csv and appleStore_description have matching count*/
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description

/* Check for missing values*/

SELECT COUNT(*) AS MissingValues
From AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
From appleStore_description
WHERE app_desc IS NULL

/* Basic EDA */

/* Calculate the number of apps per genre*/

SELECT prime_genre, Count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

--The games genre has the highest number of apps and therefore is a high competition

/* Check app ratings*/

select MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating
FROM AppleStore

--On Average apps have a 3.5 rating


**DATA ANALYSIS**

/* Check whether paid apps have higher ratings */

SELECT CASE
			WHEN price > 0 THEN 'PAID'
    		ELSE 'FREE'
    	END AS App_Type,
        avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP by App_Type

--PAID APPS HAVE GENERALLY HIGHER RATINGS

/* Check if apps with more language support have higher ratings */

SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            when lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
		END as language_bucket,
        avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_rating DESC

-- 10-30 Languages have better ratings, which means it is better to focus on key languages

/* Check genres with low ratings */

SELECT prime_genre, avg(user_rating) AS Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
LIMIT 10

--Book apps have low ratings, which could be potentially a zone of entry for a new app developer

/* Check correlation between length of app description and user rating*/AppleStore

SELECT CASE
			WHEN length (B.app_desc) < 500 Then 'short'
            When length (B.app_desc) BETWEEN 500 and 1000 then 'medium'
            ELSE 'Long'
       end as description_length_bucket,
       avg(A.user_rating) AS average_rating

FROM AppleStore AS A
JOIN appleStore_description AS B
on A.id = B.id 
GROUP BY description_length_bucket
order by average_rating Desc

--Apps with longer descriptions have better ratings

/* Check the top-rated apps for each genre */

SELECT prime_genre,track_name,user_rating
FROM (SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
      FROM
      AppleStore
      ) AS a
WHERE a.rank = 1

-- This query shows one app in each genre that has a perfect rating














