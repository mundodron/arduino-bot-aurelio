
SELECT   A.COMPONENT_ID, TIRA_ACENTO (A.COMPONENTE) AS COMPONENTE
  FROM   G0023421SQL.GVT_VAL_PLANO A
 WHERE       A.PLANO IN (SELECT   PLANO
                           FROM   g0023421sql.GVT_VAL_PLANO
                          WHERE   COMPONENT_ID = 30367)               --cc_id)
         AND A.TIPOELEMENTO = 'RC - Conta'
         --AND A.ELEMENTO = 'LDN'
         AND A.COMPONENT_ID not in (30487)
         AND not EXISTS
               (SELECT   1
                  FROM   bill_invoice_detail CPC, bill_invoice BB
                 WHERE       BB.ACCOUNT_NO = 3910188                 -- acc_no
                         AND CPC.BILL_REF_NO = 203080027            -- bill_no
                         AND CPC.TYPE_CODE = 2
                         AND CPC.BILL_REF_NO = BB.BILL_REF_NO
                         AND CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS
                         AND CPC.COMPONENT_ID = A.COMPONENT_ID)