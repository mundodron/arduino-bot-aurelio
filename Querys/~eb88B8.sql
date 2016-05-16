select pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.FROM_DATE, count(1) total
  from bill_invoice_detail pk,
       bill_invoice bi,
       COMPONENT_DEFINITION_VALUES vl
 where PK.BILL_REF_NO = BI.BILL_REF_NO
   and PK.BILL_REF_RESETS = BI.BILL_REF_RESETS
   and PK.COMPONENT_ID = vl.COMPONENT_ID
   and VL.LANGUAGE_CODE = 2
   and PK.TYPE_CODE = 2
   and PK.PRORATE_CODE not in (1,2)
   and BI.BILL_REF_NO = 211545780
group by (pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.FROM_DATE)

having count(1) > 1;

select pk.COMPONENT_ID, BI.BILL_REF_NO, PK.SUBSCR_NO ,BI.ACCOUNT_NO, PK.FROM_DATE, count(1) total
  from bill_invoice_detail pk,
       bill_invoice bi
 where PK.BILL_REF_NO = BI.BILL_REF_NO
   and PK.BILL_REF_RESETS = BI.BILL_REF_RESETS
   and PK.TYPE_CODE = 2
   and PK.PRORATE_CODE not in (1,2)
   and BI.BILL_REF_NO = 211545780
group by (pk.COMPONENT_ID, BI.BILL_REF_NO, PK.SUBSCR_NO, BI.ACCOUNT_NO,PK.FROM_DATE) 



          select pk.COMPONENT_ID, EQ.EXTERNAL_ID , VL.DISPLAY_VALUE, PK.FROM_DATE, count(1) total
             from bill_invoice_detail pk,
                  customer_id_equip_map eq,
                  COMPONENT_DEFINITION_VALUES vl
            where pk.bill_ref_no = 211545780-- bill_no
              and EQ.SUBSCR_NO = -- subs_no
              and PK.SUBSCR_NO = EQ.SUBSCR_NO

              and PK.SUBSCR_NO_RESETS = EQ.SUBSCR_NO_RESETS
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
 