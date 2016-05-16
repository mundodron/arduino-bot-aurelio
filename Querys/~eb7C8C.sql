-- C4 Produto Faltando;899997830976;9078689;25847869;198578309;30489;25 Cidade Local - Conta
-- C4 Produto Faltando;899997830976;9078689;25847869;198578309;30490;25 Cidade Local - Instancia


        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30489) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 9078689
                           AND   CPC.BILL_REF_NO = 198578309
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID)
      

 -- UNION
       SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30489) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
           and A.COMPONENT_ID <> 30491 --Verificar, o caso de type_code = 6 ignorar por enquanto.
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 9078689
                           AND   CPC.BILL_REF_NO = 198578309
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = 25847869
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);