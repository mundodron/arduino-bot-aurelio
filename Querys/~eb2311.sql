          select (select tira_acento(description_text) from descriptions dt where dt.description_code = P.ELEMENT_ID and dt.language_code = 2) "PRODUTO",                  
                  P.ELEMENT_ID, P.COMPONENT_ID, P.PARENT_SUBSCR_NO
             from product p
            where p.billing_account_no = 3910188
              and P.BILLING_INACTIVE_DT is null
              order by 3
                
       union
       
          SELECT   (select tira_acento(description_text) from descriptions dt where dt.description_code = CPC.ELEMENT_ID and dt.language_code = 2) "PRODUTO",
                   CPC.ELEMENT_ID, CPC.COMPONENT_ID, CPC.SUBSCR_NO
            FROM   bill_invoice_detail CPC,
                   bill_invoice BB
           WHERE   BB.ACCOUNT_NO = 3910188 -- acc_no
             AND   CPC.BILL_REF_NO = 203080027 -- bill_no
             AND   CPC.TYPE_CODE = 2
             AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
             AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
             order by 3
       