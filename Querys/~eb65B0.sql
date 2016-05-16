select * from GVT_DETALHAMENTO_CICLO where bill_period = 'M20' and PREP_DATE > sysdate -20 and anotation like '%EIF%'

select * from GVT_DETALHAMENTO_CICLO