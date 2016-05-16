-- "EXTERNAL_ID"  "ACCOUNT_NO"    "BILL_REF_NO"    "SUBSCR_NO"    "COMPONENT_ID"
-- 999988338223    3910188          203080027         8977545         30367


-- _________________________________________________________________
--*** Inicio - PBCT1 - M15 - 10/10/2014 11:56:39
--CENARIO;          CONTA_COBRANCA;ACCOUNT;SUBSCR_NO;INSTANCIA;FAT_ATUAL;COMPONENTE_ID;COMPONENTE;COMENTARIO
--C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30487;GVT Na Medida Nacional - Conta
--C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30488;GVT Na Medida Nacional - Instancia
--_________________________________________________________________
--*** Fim - PBCT1 - M15 - 10/10/2014 11:56:39
 
 
        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30367) --cc_id) 
           AND A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 3910188-- acc_no
                           -- AND   CPC.BILL_REF_NO = 203080027 -- bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.COMPONENT_ID = A.COMPONENT_ID)
                           
                                               
       UNION  
       
       
       SELECT   BB.ACCOUNT_NO, BB.BILL_REF_NO, A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
         FROM   G0023421SQL.GVT_VAL_PLANO A,
                bill_invoice_detail CPC,
                bill_invoice BB
         WHERE  A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30487) --CC_ID) 
           AND  A.TIPOELEMENTO = 'RC - Instancia'
           --AND  A.COMPONENT_ID not in (30491,30492) --Verificar, o caso de type_code = 6 ignorar por enquanto.
           AND  BB.ACCOUNT_NO = 3910188-- acc_no
           AND   CPC.BILL_REF_NO = 203080027 -- bill_no
           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
           AND   CPC.SUBSCR_NO = 8977545-- subs_cc
           AND   CPC.TYPE_CODE = 2
           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
           AND   CPC.BILL_REF_RESETS = 0
           AND   CPC.COMPONENT_ID = A.COMPONENT_ID
           
           
           
            AND NOT EXISTS
                       (SELECT   1
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 3910188-- acc_no
                           AND   CPC.BILL_REF_NO = 203080027 -- bill_no
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.SUBSCR_NO = 8977545-- subs_cc
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.BILL_REF_RESETS = 0
                           AND   A.COMPONENT_ID = CPC.COMPONENT_ID);


SELECT * FROM g0023421sql.GVT_VAL_PLANO where plano = 'GVT - Na Medida Casa' AND TIPOELEMENTO = 'RC - Conta'