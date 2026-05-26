WITH UnnestedContent AS (
    SELECT
        TRIM(regexp_split_to_table(t.country, ',')) AS country_name,
        TRIM(t.type) AS content_type,
        t.show_id
    FROM netflix_ham_veriler t
    WHERE t.country IS NOT NULL 
      AND TRIM(t.country) <> ''
      AND TRIM(t.type) IN ('Movie', 'TV Show')
),
CountryCounts AS (
    --Her ulke-tip ciftinin kac farkli icerige sahip oldugunu sayar
    SELECT
        country_name,
        content_type,
        COUNT(show_id) AS content_count
    FROM UnnestedContent
    WHERE TRIM(country_name) NOT IN ('Unknown', '')
    GROUP BY 1, 2
),
TotalCounts AS (
    --Ulkenin Toplam Icerik Sayisini bulur
    SELECT 
        country_name,
        SUM(content_count) AS total_content
    FROM CountryCounts
    GROUP BY 1
),
Top10Countries AS (
    --Toplam icerige gore ILK 10 ulkeyi belirler
    SELECT 
        country_name
    FROM TotalCounts
    ORDER BY total_content desc
    limit 10
)
SELECT
    cc.country_name AS Country,
    cc.content_type AS type,
    cc.content_count AS number_of_counts,
    tc.total_content AS Total_Count,
    -- Oran hesaplamasi: (Parca / Butun) * 100
    ROUND((cc.content_count::decimal / tc.total_content) * 100, 2) AS Percentage
FROM CountryCounts cc
JOIN TotalCounts tc ON cc.country_name = tc.country_name
WHERE cc.country_name IN (SELECT country_name FROM Top10Countries)
ORDER BY 
    tc.total_content DESC, -- En cok icerik ureten ulke basa gelir
    cc.content_count DESC; -- Aynı ulke icinde Film/Dizi siralamasi