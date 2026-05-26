SELECT
    country,
    COUNT(*) AS content_count
FROM (
    SELECT
        TRIM(regexp_split_to_table(country, ',')) AS country
    FROM netflix_ham_veriler
    WHERE country IS NOT null
    --BU kısım eklendi
    and country<>''
) AS t
GROUP BY country
ORDER BY content_count DESC;