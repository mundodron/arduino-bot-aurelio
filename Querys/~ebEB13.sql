-- "EXTERNAL_ID"    "ACCOUNT_NO"    "BILL_REF_NO"    "SUBSCR_NO"    "COMPONENT_ID"    "PREP_DATE"    "PREP_STATUS"    "BILL_PERIOD"
--  899998034415       8891739        206161545        25172494            31080    09/10/2014 22:26:20    4            M28

 CURSOR C_BUSCA_DUPLICIDADE(bill_no number, subs_no number) is -- C2
           select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, PK.FROM_DATE, count(1) total
             from bill_invoice_detail pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where pk.bill_ref_no = 206161545 -- bill_no
              and eq.
              and PK.TYPE_CODE = 2
              and EQ.INACTIVE_DATE is null
              and EQ.IS_CURRENT = 1
              and PK.PRORATE_CODE not in (1,2)
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO where NOME_PLANO = 'TOUCHE') or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT bd WHERE bd.COMPONENT_ID = pk.COMPONENT_ID and bd.PARENT_SUBSCR_NO = subs_no and bd.INACTIVE_DT is null)
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID, PK.FROM_DATE)
            having count(1) > 1;