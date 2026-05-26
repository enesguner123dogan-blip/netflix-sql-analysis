SELECT
    TRIM(regexp_split_to_table("cast", ',')) AS actor,
    type,
    COUNT(*) AS appearances
FROM netflix_ham_veriler
WHERE "cast" IS NOT NULL AND "cast" <> ''
GROUP BY actor, type
ORDER BY appearances DESC
LIMIT 5;
WITH UnnestedActors AS (
    -- Oyuncuları ayır (UNNEST) ve show_id ile tiplerini hazirla
    SELECT
        t.show_id,
        TRIM(regexp_split_to_table(t.cast, ',')) AS actor_name,
        TRIM(t.type) AS content_type
    FROM netflix t
    WHERE t.cast IS NOT NULL AND TRIM(t.cast) <> '' -- Oyuncu filtresi
),
Top5Actors AS (
    -- Once, Toplam rol sayisina gore ILK 5 oyuncuyu belirle
    SELECT
        actor_name
    FROM UnnestedActors
    GROUP BY actor_name
    ORDER BY COUNT(show_id) DESC -- show_id sayisi kadar rol aldi
    LIMIT 5
)
--Sadece bu ILK 5 oyuncunun tur dökümünü hesapla
SELECT
    t1.actor_name AS Oyuncu,
    t1.content_type AS Icerik_Turu,
    COUNT(t1.show_id) AS Rol_Sayisi
FROM UnnestedActors t1
INNER JOIN Top5Actors t2 ON t1.actor_name = t2.actor_name -- Sadece Top 5'i al
GROUP BY 1, 2 -- Oyuncuyu ve Turu gruplayarak dökümü göster
ORDER BY 
    Rol_Sayisi DESC; -- Toplam Rol Sayisina gore siralama yapar
