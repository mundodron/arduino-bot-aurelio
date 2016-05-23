SELECT Q.ROW_ID,
       A.EXTERNAL_ID as CMF_EXT_ID,
       EIEM.EXTERNAL_ID as EMF_EXT_ID,
       --SERVICE.EMF_CONFIG_ID,
       --ECI.DISPLAY_VALUE,
       SERVICE.SERVICE_ACTIVE_DT as SERVICE_START,
       's/' as DEGRAU,
       RTRIM(upper(GPV.VELOCITY), 'KMBGT') as VELOCIDADE,
       LTRIM(GPV.VELOCITY, '1234567890') as UNID_VELOCIDADE,
       '11000' as CNLA,
       '11000' as CNLB,
       LOCAL_ADDRESS.ADDRESS_1 as ADDRESS_B,
       LOCAL_ADDRESS.ADDRESS_2 as COMPL_B, 
       LOCAL_ADDRESS.STATE as DISTRICT_B
FROM CUSTOMER_ID_EQUIP_MAP EIEM,
     SERVICE,
     CUSTOMER_ID_ACCT_MAP A,
     EMF_CONFIG_ID_VALUES ECI,
     PRODUCT EP,
     LOCAL_ADDRESS,
     SERVICE_ADDRESS_ASSOC,       
     GVT_PRODUCT_VELOCITY GPV,
     S_QUOTE_SOLN Q
WHERE service.parent_ACCOUNT_NO in (select account_no from GVT_FEBRABAN_ACCOUNTS where external_id in ('999982202062'))
AND   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 7
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

select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_BILL_INVOICE

where 
 'MGA-30NR90WQ-013'