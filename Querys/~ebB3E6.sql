/*
_________________________________________________________________
*** Inicio - PBCT1 - M15 - 15/10/2014 15:36:25
CENARIO;CONTA_COBRANCA;ACCOUNT;SUBSCR_NO;INSTANCIA;FAT_ATUAL;COMPONENTE_ID;COMPONENTE;COMENTARIO
C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30487;GVT Na Medida Nacional - Conta
30367
C4 Produto Faltando;999988338223;3910188;8977545;999988338223;203080027;30488;GVT Na Medida Nacional - Instancia
30367
_________________________________________________________________
*** Fim - PBCT1 - M15 - 15/10/2014 15:36:25
*/

        SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30367) --cc_id) 
           AND   A.TIPOELEMENTO = 'RC - Conta'
                 AND NOT EXISTS
                       (SELECT   *
                          FROM   bill_invoice_detail CPC,
                                 bill_invoice BB
                         WHERE   BB.ACCOUNT_NO = 3910188 -- acc_no
                           AND   CPC.BILL_REF_NO = 203080027 -- bill_no
                           AND   CPC.TYPE_CODE = 2
                           AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                           AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                           AND   CPC.COMPONENT_ID = A.COMPONENT_ID)