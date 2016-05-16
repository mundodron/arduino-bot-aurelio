  SELECT   A.COMPONENT_ID, TIRA_ACENTO(A.COMPONENTE) AS COMPONENTE
          FROM   G0023421SQL.GVT_VAL_PLANO A
         WHERE   A.PLANO in (SELECT PLANO FROM g0023421sql.GVT_VAL_PLANO WHERE COMPONENT_ID = 30367) --cc_id) 
           AND   A.TIPOELEMENTO = 'RC - Conta'
           AND   A.ELEMENTO = 'LDN'
           AND   EXISTS (SELECT  1
                                         FROM   bill_invoice_detail CPC,
                                                bill_invoice BB
                                        WHERE   BB.ACCOUNT_NO = 3910188 -- acc_no
                                          AND   CPC.BILL_REF_NO = 203080027 -- bill_no
                                          AND   CPC.TYPE_CODE = 2
                                          AND   CPC.BILL_REF_NO = BB.BILL_REF_NO
                                          AND   CPC.BILL_REF_RESETS = BB.BILL_REF_RESETS)
                                          
                                          
                                          
             select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, count(1) total
             from bill_invoice_detail pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where pk.bill_ref_no = bill_no
              and EQ.SUBSCR_NO = subs_no
              and PK.SUBSCR_NO = EQ.SUBSCR_NO
              and PK.TYPE_CODE = 2
              and PK.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and EQ.INACTIVE_DATE is null
              and EQ.IS_CURRENT = 1
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO) or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT bd WHERE bd.COMPONENT_ID = pk.COMPONENT_ID and bd.PARENT_SUBSCR_NO = subs_no and bd.INACTIVE_DT is null)
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID)
            having count(1) > 1;