declare
cursor c1 is
    SELECT distinct(Q.ROW_ID),
       A.EXTERNAL_ID as CMF_EXT_ID,
       EIEM.EXTERNAL_ID as EMF_EXT_ID,
       SERVICE.SERVICE_ACTIVE_DT as SERVICE_START,
       null as SERVICE_END,
       's/' as DEGRAU,
       TO_NUMBER(RTRIM(REPLACE(UPPER(GPV.VELOCITY),',','.'), 'KMBGT ')) VELOCIDADE,
       LTRIM(GPV.VELOCITY, '1234567890.') as UNID_VELOCIDADE,
       CNL.point_class as CNLA,
       CNL.point_class as CNLB,
       LOCAL_ADDRESS.ADDRESS_1 as ADDRESS_B,
       null as NUMBER_B,
       LOCAL_ADDRESS.ADDRESS_2 as COMPL_B,
       LOCAL_ADDRESS.STATE as DISTRICT_B,
       null as PHONE_NUMBER
FROM  CUSTOMER_ID_EQUIP_MAP EIEM,
      SERVICE,
      CUSTOMER_ID_ACCT_MAP A,
      EMF_CONFIG_ID_VALUES ECI,
      PRODUCT EP,
      LOCAL_ADDRESS,
      SERVICE_ADDRESS_ASSOC,       
      GVT_PRODUCT_VELOCITY GPV,
      DBAREM.S_QUOTE_SOLN Q,
      GVT_FEBRABAN_PONTA_B_ARBOR F,
      ( SELECT MIN(point_class) as point_class,
               trim(POINT_STATE_ABBR) as POINT
          FROM USAGE_POINTS
         WHERE INACTIVE_DT IS NULL
           AND LENGTH(point_class)=5
        GROUP BY POINT_STATE_ABBR) CNL 
WHERE SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 1
AND   A.EXTERNAL_ID_TYPE = 1
AND   A.ACCOUNT_NO = SERVICE.PARENT_ACCOUNT_NO
AND   EIEM.INACTIVE_DATE IS NULL
AND   EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
AND   EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO
AND   EP.TRACKING_ID = GPV.TRACKING_ID
AND   EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV
AND   SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
AND   ECI.LANGUAGE_CODE = 2
AND   Q.COPIED_FLG = 'N'
AND   EIEM.EXTERNAL_ID = Q.ASSET_NUM
AND   F.CMF_EXT_ID = a.EXTERNAL_ID
AND   F.SERVICE_END IS NULL
AND   CNL.POINT = LOCAL_ADDRESS.STATE
AND   service.parent_ACCOUNT_NO in (select account_no from customer_id_acct_map where external_id in ('999997308304'))
AND   NOT EXISTS (SELECT 1 FROM GVT_FEBRABAN_PONTA_B_ARBOR B WHERE B.EMF_EXT_ID = EIEM.EXTERNAL_ID);

begin
for x in c1 loop
 INSERT INTO GVT_FEBRABAN_PONTA_B_ARBOR_BK ( ROW_ID,
                                            CMF_EXT_ID,
                                            EMF_EXT_ID,
                                            SERVICE_START,
                                            SERVICE_END,
                                            DEGRAU,
                                            VELOCIDADE,
                                            UNID_VELOCIDADE,
                                            CNLA,
                                            CNLB,
                                            ADDRESS_B,
                                            NUMBER_B,
                                            COMPL_B, 
                                            DISTRICT_B,
                                            PHONE_NUMBER)
           VALUES            (x.ROW_ID,
                              x.CMF_EXT_ID,
                              x.EMF_EXT_ID,
                              x.SERVICE_START,
                              x.SERVICE_END,
                              x.DEGRAU,
                              x.VELOCIDADE,
                              x.UNID_VELOCIDADE,
                              x.CNLA,
                              x.CNLB,
                              x.ADDRESS_B,
                              x.NUMBER_B,
                              x.COMPL_B,
                              x.DISTRICT_B,
                              x.PHONE_NUMBER);    

END LOOP;
    commit;
END;
