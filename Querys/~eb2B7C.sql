           select p.*,
           (select tira_acento(description_text) from descriptions dt where dt.description_code = P.ELEMENT_ID and dt.language_code = 2) "PRODUTO"                  
             from product p
            where p.billing_account_no = 3910188