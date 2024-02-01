# AppStore Apps Analysis

This GitHub repository contains SQL code for analyzing AppStore apps data and conducting basic Exploratory Data Analysis (EDA). The dataset consists of two tables: `AppleStore` and `appleStore_description`. The SQL code in this project performs various checks and analyses to gain insights from the data.

## Table of Contents
- [Project Overview](#project-overview)
- [Data Checks](#data-checks)
  - [Matching Count](#matching-count)
  - [Missing Values](#missing-values)
- [Basic EDA](#basic-eda)
  - [Number of Apps per Genre](#number-of-apps-per-genre)
  - [App Ratings](#app-ratings)
- [Data Analysis](#data-analysis)
  - [Paid vs. Free Apps](#paid-vs-free-apps)
  - [Language Support vs. Ratings](#language-support-vs-ratings)
  - [Genres with Low Ratings](#genres-with-low-ratings)
  - [Description Length vs. Ratings](#description-length-vs-ratings)
  - [Top Rated Apps per Genre](#top-rated-apps-per-genre)
- [Conclusion](#conclusion)

## Project Overview

This project aims to analyze AppStore apps data and derive valuable insights from it using SQL queries. The dataset includes information about various app attributes, such as app name, user ratings, genres, pricing, and more.

## Data Checks

### Matching Count

To ensure data integrity, we check whether the `AppleStore` and `appleStore_description` tables have matching counts of unique app IDs.

```sql
-- Check whether AppleStore.csv and appleStore_description have matching counts of unique app IDs
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description
```

### Missing Values

We identify and count missing values in essential columns of the `AppleStore` and `appleStore_description` tables.

```sql
-- Check for missing values in AppleStore table
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

-- Check for missing values in appleStore_description table
SELECT COUNT(*) AS MissingValues
FROM appleStore_description
WHERE app_desc IS NULL
```

## Basic EDA

### Number of Apps per Genre

We calculate the number of apps per genre to understand the distribution of app genres in the dataset.

```sql
-- Calculate the number of apps per genre
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC
```

### App Ratings

We examine the minimum, maximum, and average user ratings for all apps in the dataset.

```sql
-- Check app ratings
SELECT MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating
FROM AppleStore
```

## Data Analysis

### Paid vs. Free Apps

We analyze whether paid apps generally have higher ratings than free apps.

```sql
-- Check whether paid apps have higher ratings
SELECT CASE
    WHEN price > 0 THEN 'PAID'
    ELSE 'FREE'
END AS App_Type,
AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type
```

### Language Support vs. Ratings

We explore whether apps with more language support tend to have higher user ratings.

```sql
-- Check if apps with more language support have higher ratings
SELECT CASE
    WHEN lang_num < 10 THEN '<10 languages'
    WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
    ELSE '>30 languages'
END AS language_bucket,
AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_rating DESC
```

### Genres with Low Ratings

We identify genres with the lowest average ratings, which could be areas of potential improvement or innovation.

```sql
-- Check genres with low ratings
SELECT prime_genre, AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10
```

### Description Length vs. Ratings

We analyze whether the length of app descriptions correlates with user ratings.

```sql
-- Check the correlation between the length of the app description and user rating
SELECT CASE
    WHEN LENGTH(B.app_desc) < 500 THEN 'short'
    WHEN LENGTH(B.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
    ELSE 'long'
END AS description_length_bucket,
AVG(A.user_rating) AS average_rating
FROM AppleStore AS A
JOIN appleStore_description AS B
ON A.id = B.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC
```

### Top Rated Apps per Genre

We find the top-rated app in each genre based on user ratings.

```sql
-- Find the top-rated app in each genre
SELECT prime_genre, track_name, user_rating
FROM (
    SELECT prime_genre, track_name, user_rating,
    RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM AppleStore
) AS a
WHERE a.rank = 1
```
## Conclusion

Our basic Exploratory Data Analysis (EDA) focused on understanding the distribution of apps across genres and exploring app ratings. We discovered that the Games genre had the highest number of apps, indicating a highly competitive market. On average, apps had a user rating of approximately 3.5, which served as a benchmark for further analysis.

In our data analysis phase, we delved deeper into factors affecting user ratings. We found that paid apps generally had higher ratings than free apps, suggesting that users might associate value with paid apps. Additionally, apps with support for 10-30 languages tended to have higher ratings, highlighting the importance of catering to a diverse user base.

We also identified genres with low ratings, such as Book apps, which could represent opportunities for improvement or innovation. Furthermore, we explored the relationship between description length and user ratings, revealing that apps with longer descriptions tended to have better ratings.

Lastly, we identified the top-rated app in each genre, providing insights into exceptional performers in various categories.

This SQL project provides a foundational understanding of AppStore app data and offers insights that can inform business strategies, marketing efforts, and app development decisions. The findings can serve as a starting point for more advanced analyses and decision-making processes within the app development industry.
