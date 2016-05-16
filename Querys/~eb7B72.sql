 CURSOR C_BUSCA_PROD_FALTANDO(acc_no number, bill_no number, cc_id number, subs_cc number) is -- C4
        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE NOME_PLANO = 'TOUCHE' AND COMPONENT_ID = cc_id) 
           AND   A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = acc_no
                           AND   CPC.BILL_REF_NO = bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS)
        UNION ALL
        SELECT A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM G0023421SQL.GVT_VAL_PLANO A
         WHERE A.PLANO = (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE NOME_PLANO = 'TOUCHE' AND COMPONENT_ID = CC_ID) 
           AND A.TIPOELEMENTO = 'RC - Instancia'
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
                           AND   CPC.COMPONENT_ID = A.COMPONENT_ID);



SELECT *
FROM product p
where p.component_id = 31080
and P.PRODUCT_INACTIVE_DT is null
and not exists(select 1
                from product p1
                where P1.PARENT_ACCOUNT_NO = P.PARENT_ACCOUNT_NO
                and P1.PRODUCT_INACTIVE_DT is null
                and P1.COMPONENT_ID = 31075
                )
                
                
 select * from bill_invoice where bill_ref_no = 189654134
 
 select * from GVT_BILL_PRODUCT_RATE_KEY where account_no = 6874715 -- bill_ref_no = 189654134