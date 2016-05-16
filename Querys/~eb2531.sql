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