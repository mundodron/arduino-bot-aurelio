           select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, count(1) total
             from bill_invoice_detail pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl, 
                  product pr
            where pk.bill_ref_no = 198577908
              and EQ.SUBSCR_NO = 25894055
              and PK.SUBSCR_NO = EQ.SUBSCR_NO
              and PK.TYPE_CODE = 2
              and PK.ELEMENT_ID = PR.ELEMENT_ID
              and PK.COMPONENT_ID = PR.COMPONENT_ID
              and PR.BILLING_INACTIVE_DT is null
              and PK.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
              and EQ.INACTIVE_DATE is null
              and EQ.IS_CURRENT = 1
              and EQ.EXTERNAL_ID_TYPE <> 1
              and EQ.EXTERNAL_ID_TYPE in (6,7)
              and PK.COMPONENT_ID = vl.COMPONENT_ID
              and VL.LANGUAGE_CODE = 2
              and (pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO) or pk.component_id in (SELECT to_number(COMPONENT_ID)FROM g0023421sql.GVT_VAL_PLANO_DADOS))
              and EXISTS (SELECT 1 FROM CMF_PACKAGE_COMPONENT bd WHERE bd.COMPONENT_ID = pk.COMPONENT_ID and bd.PARENT_SUBSCR_NO = 25894055 and bd.INACTIVE_DT is null)
              and PK.ELEMENT_ID in (select PR.ELEMENT_ID from product pr where pr.BILLING_ACCOUNT_NO = 9092005 and pr.parent_subscr_no = 25894055 and pr.component_id = PK.COMPONENT_ID and pr.BILLING_INACTIVE_DT is null)
            group by (pk.COMPONENT_ID,VL.DISPLAY_VALUE,EQ.EXTERNAL_ID)
            having count(1) > 1;
            
            select * from product where BILLING_ACCOUNT_NO = 9092005 and parent_subscr_no = 25894055 and component_id = 30362 and BILLING_INACTIVE_DT is null;