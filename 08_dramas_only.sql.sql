select TRIM(unnested_Listed) as İçerikler, title,  release_year
from netflix_ham_veriler
CROSS JOIN LATERAL unnest(string_to_array(listed_in , ',')) AS unnested_Listed
where TRIM(unnested_Listed) in('Dramas')