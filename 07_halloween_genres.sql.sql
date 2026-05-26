select distinct TRIM(unnested_Listed) from netflix_ham_veriler
CROSS JOIN LATERAL unnest(string_to_array(listed_in , ',')) AS unnested_Listed
where EXTRACT(MONTH FROM date_added) = 10
  AND EXTRACT(DAY FROM date_added) = 31;