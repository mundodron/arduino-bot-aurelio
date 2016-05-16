        select pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, PK.ELEMENT_ID, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.FROM_DATE, count(1) total
          from bill_invoice_detail pk,
               bill_invoice bi,
               COMPONENT_DEFINITION_VALUES vl
         where PK.BILL_REF_NO = BI.BILL_REF_NO
           and PK.BILL_REF_RESETS = BI.BILL_REF_RESETS
           and PK.COMPONENT_ID = vl.COMPONENT_ID
           and VL.LANGUAGE_CODE = 2
           and PK.TYPE_CODE = 2
           and PK.PRORATE_CODE not in (1,2)
           and BI.BILL_REF_NO = 211457504
           and bi.account_no = 9321309
        group by (pk.COMPONENT_ID, BI.BILL_REF_NO, BI.ACCOUNT_NO, VL.DISPLAY_VALUE, PK.SUBSCR_NO, PK.ELEMENT_ID, PK.FROM_DATE)
        having count(1) > 1;