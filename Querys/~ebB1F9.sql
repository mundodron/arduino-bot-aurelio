-- C4 Produto Faltando;899998308301;8673893;24359139;899998308301;199351529;30362;GVT Ilimitado Local Casa - Franquia Mensal

        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30362) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 8673893
                           AND   CPC.BILL_REF_NO = 199351529
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID)
        UNION
       SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30362) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
           and A.COMPONENT_ID <> 30491 --Verificar, o caso de type_code = 6 ignorar por enquanto.
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 8673893
                           AND   CPC.BILL_REF_NO = 199351529
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = 24359139
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);
                           
SELECT * FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 10229