WITH UnnestedData AS (
    -- Director ve listed_in sutunlarini ayirma
    SELECT
        TRIM(unnested_director) AS cleaned_director,
        TRIM(unnested_Listed) AS cleaned_genre
    FROM
        netflix_ham_veriler t -- Tablo adi: netflix
CROSS JOIN LATERAL unnest(string_to_array(t.director, ',')) AS unnested_director
CROSS JOIN LATERAL unnest(string_to_array(t.listed_in , ',')) AS unnested_Listed
    WHERE
    TRIM(unnested_director)<>'' and TRIM(unnested_Listed)<>''
        -- NULL ve "None" degerlerini filtreleme
      /*  t.director IS NOT NULL
        AND t.listed_in IS NOT NULL
        AND t.director <> 'None'*/
)
SELECT
    cleaned_genre AS Tur,
    COUNT(cleaned_director) AS Yonetmen_Sayisi
FROM
    UnnestedData
GROUP BY 1
ORDER BY
    Yonetmen_Sayisi DESC
LIMIT 10;