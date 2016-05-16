SELECT EIEM.EXTERNAL_ID,
                   SERVICE.EMF_CONFIG_ID,
                   ECI.DISPLAY_VALUE,
                   SERVICE.SERVICE_ACTIVE_DT, 
                   LOCAL_ADDRESS.ADDRESS_1,
                   LOCAL_ADDRESS.ADDRESS_2, 
                   LOCAL_ADDRESS.STATE,              
                   GPV.VELOCITY
FROM CUSTOMER_ID_EQUIP_MAP EIEM,
                 SERVICE,
                 EMF_CONFIG_ID_VALUES ECI,
                 PRODUCT EP,
                 LOCAL_ADDRESS,
                 SERVICE_ADDRESS_ASSOC,          
                 GVT_PRODUCT_VELOCITY GPV
WHERE service.parent_ACCOUNT_NO = 4241226
AND   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 7
AND   EIEM.INACTIVE_DATE IS NULL
AND   EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
AND   EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO (+)
AND   EP.TRACKING_ID = GPV.TRACKING_ID (+)
AND   EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV (+)
AND   SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
AND   ECI.LANGUAGE_CODE = 2
AND   NOT EXISTS (SELECT 1 FROM GVT_FEBRABAN_PONTA_B_ARBOR B WHERE B.EMF_EXT_ID = EIEM.EXTERNAL_ID)


select account_no from customer_id_acct_map where external_id in ('999999259802') and EXTERNAL_ID_TYPE =1