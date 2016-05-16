 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number, bill_no number, cc_id number, subs_cc number) is -- C4
        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = cc_id) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID)
        UNION
       SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = CC_ID) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
           and A.COMPONENT_ID not in (30491,30492) --Verificar, o caso de type_code = 6 ignorar por enquanto.
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = subs_cc
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);
