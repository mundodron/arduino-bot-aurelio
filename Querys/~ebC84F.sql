           select (select tira_acento(description_text) from descriptions dt where dt.description_code = P.ELEMENT_ID and dt.language_code = 2) "PRODUTO",
                  (select tira_acento(display_value) from COMPONENT_DEFINITION_VALUES dv where DV.COMPONENT_ID = P.COMPONENT_ID and dv.language_code = 2) "PRODUTO_DV",
                  P.ELEMENT_ID, P.COMPONENT_ID, P.PARENT_SUBSCR_NO                
             from product p
            where p.billing_account_no = 3910188
              and P.PRODUCT_INACTIVE_DT is null
              --and P.PARENT_SUBSCR_NO is null
              
              
           select (select tira_acento(description_text) from descriptions dt where dt.description_code = P.ELEMENT_ID and dt.language_code = 2) "PRODUTO",
                  (select tira_acento(display_value) from COMPONENT_DEFINITION_VALUES dv where DV.COMPONENT_ID = P.COMPONENT_ID and dv.language_code = 2) "PRODUTO_DV",
                  P.ELEMENT_ID, P.COMPONENT_ID, P.PARENT_SUBSCR_NO                
             from bill_invoice_detail p
            where P.SUBSCR_NO = 3910188
              and P.PRODUCT_INACTIVE_DT is null
              
     



           