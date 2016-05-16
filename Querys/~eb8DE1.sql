
C4 Produto Faltando    999992987456    1843882    3003724    9,99993E+11    204140227    30488    GVT Na Medida Nacional - Instancia    


select * from g0023421sql.GVT_VAL_PLANO where component_id = 30488

select p.*,  
        (select tira_acento(description_text) from descriptions dt where dt.description_code = p.ELEMENT_ID and language_code = 2) "PRODUTO"
from product p where billing_account_no = 8503760  and product_inactive_dt is null

-- 25011
-- Plano Basico - 5 minutos

