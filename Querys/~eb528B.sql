SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.bill_ref_no,
           D.SUBSCR_NO,
           D.COMPONENT_ID
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           CMF_PACKAGE_COMPONENT cm,
           customer_id_acct_map map
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2, 3, 7)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND MAP.IS_CURRENT = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           AND B.BILL_PERIOD = 'M28'
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 4 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           AND D.COMPONENT_ID in (30367,30368,30369,30370)
           --AND map.account_no = 8512678;
           and rownum < 2000
           order by MAP.EXTERNAL_ID
