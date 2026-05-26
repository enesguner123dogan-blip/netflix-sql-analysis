SELECT TRIM(unnested_country) AS Ülkeler, count(TRIM(unnested_country)) as "Video Sayısı"
FROM netflix_ham_veriler n
CROSS JOIN LATERAL unnest(string_to_array(n.country, ',')) AS unnested_country
where TRIM(unnested_country)<>''
group by TRIM(unnested_country)
order by count(TRIM(unnested_country)) desc