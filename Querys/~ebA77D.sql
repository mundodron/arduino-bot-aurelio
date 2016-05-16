        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30367) --cc_id) 
           AND   A.TIPOELEMENTO = 'RC - Conta'
           AND   A.ELEMENTO = 'LDN'
                 AND  EXISTS
                       (SELECT   *
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 3910188 -- acc_no
                           AND   CPC.BILL_REF_NO = 203080027 -- bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.COMPONENT_ID = A.COMPONENT_ID)
                           
                           
                           
                           
           select (select tira_acento(description_text) from descriptions dt where dt.description_code = CPC.ELEMENT_ID and dt.language_code = 2) "PRODUTO",
                  (select tira_acento(display_value) from COMPONENT_DEFINITION_VALUES dv where DV.COMPONENT_ID = CPC.COMPONENT_ID and dv.language_code = 2) "PRODUTO_DV",
                  P.ELEMENT_ID, P.COMPONENT_ID, P.PARENT_SUBSCR_NO                
             FROM   bill_invoice_detail CPC,
                    bill_invoice BB
            WHERE   BB.ACCOUNT_NO = 3910188 -- acc_no
              AND   CPC.BILL_REF_NO = 203080027 -- bill_no
              AND   CPC.TYPE_CODE = 2
              AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
              AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
              AND   CPC.COMPONENT_ID = A.COMPONENT_ID)
