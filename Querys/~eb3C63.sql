
SELECT Q.ROW_ID,
       A.EXTERNAL_ID as CMF_EXT_ID,
       EIEM.EXTERNAL_ID as EMF_EXT_ID,
       --SERVICE.EMF_CONFIG_ID,
       --ECI.DISPLAY_VALUE,
       SERVICE.SERVICE_ACTIVE_DT as SERVICE_START,
       null as SERVICE_END,
       's/' as DEGRAU,
       RTRIM(upper(GPV.VELOCITY), 'KMBGT') as VELOCIDADE,
       LTRIM(GPV.VELOCITY, '1234567890.') as UNID_VELOCIDADE,
       decode(LOCAL_ADDRESS.STATE, 'PR','41000',
                                   'SP','11000',
                                   'SC','47000',
                                   'PE','39062',
                                   'RJ','21000') CNLA,
       decode(LOCAL_ADDRESS.STATE, 'PR','41000',
                                   'SP','11000',
                                   'SC','47000',
                                   'PE','39062',
                                   'RJ','21000') CNLB,
       LOCAL_ADDRESS.ADDRESS_1 as ADDRESS_B,
       LOCAL_ADDRESS.ADDRESS_2 as COMPL_B, 
       LOCAL_ADDRESS.STATE as DISTRICT_B,
       null as PHONE_NUMBER
       -- ,display_value
FROM  CUSTOMER_ID_EQUIP_MAP EIEM,
      SERVICE,
      CUSTOMER_ID_ACCT_MAP A,
      EMF_CONFIG_ID_VALUES ECI,
      PRODUCT EP,
      LOCAL_ADDRESS,
      SERVICE_ADDRESS_ASSOC,       
      GVT_PRODUCT_VELOCITY GPV,
      S_QUOTE_SOLN Q,
      GVT_FEBRABAN_PONTA_B_ARBOR F
WHERE service.parent_ACCOUNT_NO in (select account_no from customer_id_acct_map where external_id in ('999983892842','999982223746'))
AND   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 1
AND   A.EXTERNAL_ID_TYPE = 1
AND   A.ACCOUNT_NO = SERVICE.PARENT_ACCOUNT_NO
AND   EIEM.INACTIVE_DATE IS NULL
AND   EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
AND   EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO (+)
AND   EP.TRACKING_ID = GPV.TRACKING_ID (+)
AND   EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV (+)
AND   SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
AND   ECI.LANGUAGE_CODE = 2
AND   EIEM.EXTERNAL_ID = Q.ASSET_NUM
AND   F.CMF_EXT_ID = a.EXTERNAL_ID
AND   F.SERVICE_END IS NULL
AND   GPV.VELOCITY IS NOT NULL
--AND   EIEM.EXTERNAL_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)


  select * from payment_trans where to_char(payment_due_date,'yymmdd') in ('140102') and TRANS_STATUS in (2,0)