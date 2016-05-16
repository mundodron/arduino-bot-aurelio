SELECT   distinct(MAP.EXTERNAL_ID),
         MAP.ACCOUNT_NO,
           d.BILL_REF_NO,
           D.SUBSCR_NO,
           D.COMPONENT_ID,
           B.PREP_DATE,
           B.PREP_STATUS,
           B.BILL_PERIOD  
    FROM   bill_invoice b,
           bill_invoice_detail d,
           cmf c,
           customer_id_acct_map map,
           customer_id_equip_map eq
   WHERE   d.bill_ref_resets = b.bill_ref_resets
           AND d.type_code IN (2)
           AND MAP.ACCOUNT_NO = B.ACCOUNT_NO
           AND MAP.INACTIVE_DATE is null
           AND C.ACCOUNT_NO = MAP.ACCOUNT_NO
           AND C.ACCOUNT_CATEGORY in (10,11) -- Retail
           AND MAP.EXTERNAL_ID_TYPE = 1
           AND EQ.SUBSCR_NO = D.SUBSCR_NO
           AND EQ.SUBSCR_NO_RESETS = D.BILL_REF_RESETS
           AND EQ.INACTIVE_DATE is null
           AND EQ.IS_CURRENT = 1
           --AND EQ.EXTERNAL_ID_TYPE in (6,7)
           AND MAP.IS_CURRENT = 1
           AND B.BILL_REF_NO = D.BILL_REF_NO
           AND B.BILL_REF_RESETS = D.BILL_REF_RESETS
           --AND B.BILL_PERIOD = AUX_CICLO
           AND B.PREP_DATE > sysdate - 15
           AND B.PREP_STATUS = 1 --> 4 proforma 1 production
           AND B.PREP_ERROR_CODE is null
           -- AND B.BILL_REF_NO = 202065847
           -- AND MAP.EXTERNAL_ID in ('899999360809')
           -- AND MAP.ACCOUNT_NO = 8968474
           AND D.COMPONENT_ID in (36829,36830,36831,36832,36817,36818,36825,36826,36833,36834,36835,36836,36828,36827) -- LOREN
           AND D.FROM_DATE = B.FROM_DATE;