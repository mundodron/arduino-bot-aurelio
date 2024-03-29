SELECT DISTINCT C.BILL_STATE,
                C.CUST_STATE,
                C.ACCOUNT_NO,
                MKT.SHORT_DISPLAY MKT_CODE,
                LA.STATE SERVICE_STATE,
                (SELECT DISTINCT SUBSTR(S.FULL_SIN_SEQ, -2, 2)
                   FROM SIN_SEQ_NO S
                  WHERE S.BILL_REF_NO IN 
                        (SELECT MAX(B.BILL_REF_NO)
                           FROM BILL_INVOICE B
                          WHERE B.ACCOUNT_NO = C.ACCOUNT_NO)) UF_NOTA,
                CIAM.EXTERNAL_ID,
                --LA.ADDRESS_ID,
                LA.FRANCHISE_TAX_CODE,
                FCV.DISPLAY_VALUE,
                C.CUST_FRANCHISE_TAX_CODE CUST_FRAN,
                FCV2.DISPLAY_VALUE,
                C.BILL_FRANCHISE_TAX_CODE BILL_FRAN,
                FCV3.DISPLAY_VALUE,
                CIEM.EXTERNAL_ID
  FROM CMF                   C,
       CUSTOMER_ID_ACCT_MAP  CIAM,
       MKT_CODE_VALUES       MKT,
       SERVICE               S,
       SERVICE_ADDRESS_ASSOC SAA,
       LOCAL_ADDRESS         LA,
       FRANCHISE_CODE_VALUES FCV,
       FRANCHISE_CODE_VALUES FCV2,
       FRANCHISE_CODE_VALUES FCV3,
       CUSTOMER_ID_EQUIP_MAP CIEM
WHERE CIAM.EXTERNAL_ID IN ('899997760911','899996660745','899997179769','899997760911','899999626707')
   AND CIAM.ACCOUNT_NO = C.ACCOUNT_NO
   AND C.MKT_CODE = MKT.MKT_CODE
   AND MKT.LANGUAGE_CODE = 2
   AND C.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
   AND S.SERVICE_INACTIVE_DT IS NULL
   AND S.SUBSCR_NO = SAA.SUBSCR_NO
   AND SAA.ADDRESS_ID = LA.ADDRESS_ID
   AND SAA.ASSOCIATION_STATUS = 2
   AND LA.FRANCHISE_TAX_CODE = FCV.FRANCHISE_CODE
   AND C.CUST_FRANCHISE_TAX_CODE = FCV2.FRANCHISE_CODE
   AND C.BILL_FRANCHISE_TAX_CODE = FCV3.FRANCHISE_CODE
   AND FCV.LANGUAGE_CODE = 2
   AND FCV2.LANGUAGE_CODE = 2
   AND FCV3.LANGUAGE_CODE = 2
   AND S.SUBSCR_NO = CIEM.SUBSCR_NO
   order by 2;
   
   select * from customer_id_acct_map where external_id = '899996287819'
   
   select * from bill_invoice where account_no = 10229294
   
   select EXTERNAL_ID,QUEM,DT_CADASTRO,TIPO_ERRO from gvt_dacc_gerencia_met_pgto where EXTERNAL_ID = '899997161794' 
   
   select C.ACCOUNT_NO, C.NO_BILL, C.ACCOUNT_STATUS, C.ACCOUNT_STATUS_DT, C.ACCOUNT_CATEGORY, C.CONTACT1_PHONE, C.CUST_ZIP, C.BILL_PERIOD, C.NEXT_BILL_DATE
     from cmf c
    where c.account_no = 10258762 
   
   select B.ACCOUNT_STATUS from bill_invoice b where b.account_no = 10258762 