-- CENARIO;CONTA_COBRANCA;ACCOUNT;SUBSCR_NO;INSTANCIA;FAT_ATUAL;COMPONENTE_ID;COMPONENTE;COMENTARIO
-- C4 Produto Faltando;999988501203;2794447;5780198;999988501203;199493114;30492;GVT Ilimitado Total - Franquia LDN    

   SELECT   *
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30492) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
           and A.COMPONENT_ID not in (30491) --Verificar, o caso de type_code = 6 ignorar por enquanto.
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 2794447
                           AND   CPC.BILL_REF_NO = 199493114
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = 5780198
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);
