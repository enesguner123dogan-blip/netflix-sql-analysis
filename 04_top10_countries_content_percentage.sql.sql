WITH UnnestedData AS (
    -- 1. Country ve Listed_in sutunlarini ayirma
      select  TRIM(unnested_country) AS cleaned_country,
        TRIM(unnested_Listed) AS cleaned_category,
        t.show_id
    FROM
        netflix_ham_veriler t
        CROSS JOIN LATERAL unnest(string_to_array(t.country, ',')) AS unnested_country
CROSS JOIN LATERAL unnest(string_to_array(t.listed_in , ',')) AS unnested_Listed
    WHERE
        TRIM(unnested_country) IS NOT NULL AND TRIM(unnested_country) <> ''
        AND TRIM(unnested_Listed) IS NOT null
        AND TRIM(unnested_Listed) <> ''
),
CategoryCounts AS (
    -- 2. Her ulke-kategori ciftinin kac icerigi oldugunu sayma
    SELECT
        cleaned_country,
        cleaned_category,
        COUNT(show_id) AS content_count
    FROM
        UnnestedData
    GROUP BY 1, 2
),
RankedCategories AS (
    -- 3. Her ulke (PARTITION BY) icinde, kategorileri icerik sayisina gore siralama
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cleaned_country
            ORDER BY content_count DESC
        ) as rank_num
    FROM
        CategoryCounts
)
-- 4. Her ulke icin sadece ilk 10 siradaki kategoriyi secme
SELECT
    cleaned_country AS Ulke,
    cleaned_category AS Kategori,
    content_count AS Icerik_Sayisi,
    rank_num AS Ulke_Ici_Sira_No
FROM
    RankedCategories
WHERE
    rank_num <= 10 -- Sadece ilk 10'u seciyoruz
   -- and cleaned_country<>''
   -- and cleaned_country='South Korea'
ORDER BY
    Ulke, Ulke_Ici_Sira_No asc