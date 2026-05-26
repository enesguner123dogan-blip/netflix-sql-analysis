WITH UnnestedCountries AS (
    --CROSS JOIN LATERAL ile ulke listesini ayirip, her satiri cogaltir
    SELECT
        t.director,
        s.country
    FROM
        netflix_ham_veriler t
    CROSS JOIN LATERAL
        -- Country sutununu virgul ile ayirir ve her parca icin yeni bir satir (s) olusturur
        regexp_split_to_table(t.country, ',') AS s(country)
    WHERE
        t.country IS NOT NULL
        AND t.director IS NOT NULL
        AND TRIM(t.director) <> ''
),
DirectorCounts AS (
    --Her ulke-yonetmen ciftini sayar
    SELECT
        TRIM(country) AS cleaned_country,
        TRIM(director) AS cleaned_director,
        COUNT(director) AS film_count
    FROM UnnestedCountries
    WHERE TRIM(country) <> '' 
      AND TRIM(country) <> 'Unknown'
    GROUP BY 1, 2 -- Temizlenmis ulke ve yonetmene gore gruplar
)
-- Nihai siralama ve filtreleme (ROW_NUMBER)
SELECT
    cleaned_country AS Ulke,
    cleaned_director AS Yonetmen,
    film_count AS Film_Sayisi
FROM (
    SELECT *,
           -- Her ulke (PARTITION BY) icinde en cok film yonetenleri sirala
           ROW_NUMBER() OVER (PARTITION BY cleaned_country ORDER BY film_count DESC) AS rn
    FROM DirectorCounts
) AS ranked
WHERE rn <= 3 -- Sadece ilk 3'u secer
ORDER BY Ulke, Film_Sayisi DESC;