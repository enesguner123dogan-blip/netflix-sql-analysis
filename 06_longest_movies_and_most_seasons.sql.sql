WITH TopMovies AS (
    --EN UZUN İLK 3 FİLMİ BULMA
    SELECT
        t.title AS Baslik,
        -- ' min' kelimesini cikarip tamsayiya cevirme
        CAST(TRIM(REPLACE(t.duration, ' min', '')) AS INTEGER) AS Sure_Degeri,
        'Minutes' AS sure_sezon,
        t.type AS Tur
    FROM netflix_ham_veriler t
    WHERE t.type = 'Movie' AND t.duration IS NOT NULL AND TRIM(t.duration) <> ''
    ORDER BY Sure_Degeri DESC
    LIMIT 3
),
TopShows AS (
    --EN ÇOK SEZONA SAHİP İLK 3 DİZİYİ BULMA
    SELECT
        t.title AS Baslik,
        -- ' Seasons' ve ' Season' kelimelerini cikarip tamsayiya cevirme
        CAST(TRIM(REPLACE(REPLACE(t.duration, ' Seasons', ''), ' Season', '')) AS INTEGER) AS Sure_Degeri,
        'Seasons' AS sure_sezon,
        t.type AS Tur
    FROM netflix_ham_veriler t
    WHERE t.type = 'TV Show' AND t.duration IS NOT NULL AND TRIM(t.duration) <> ''
    ORDER BY Sure_Degeri DESC
    LIMIT 3
)
-- UNION ALL ile sade ve hatasiz birlestirme
SELECT Baslik, Sure_Degeri, sure_sezon, Tur FROM TopMovies
UNION ALL
SELECT Baslik, Sure_Degeri, sure_sezon, Tur FROM TopShows;