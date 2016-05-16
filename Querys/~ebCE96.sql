      SELECT   DISTINCT
               (Q.ROW_ID),
               A.EXTERNAL_ID AS CMF_EXT_ID,
               EIEM.EXTERNAL_ID AS EMF_EXT_ID,
               SERVICE.SERVICE_ACTIVE_DT AS SERVICE_START,
               NULL AS SERVICE_END,
               's/' AS DEGRAU,
               case when trim(translate (replace(replace(RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT '),'.0',null),'.00',null), '0123456789', ' ')) is null then replace(replace(RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT '),'.0',null),'.00',null) else '0' end VELOCIDADE,
               LTRIM (GPV.VELOCITY, '1234567890.') AS UNID_VELOCIDADE,
               CNL.point_class AS CNLA,
               CNL.point_class AS CNLB,
               LOCAL_ADDRESS.ADDRESS_1 AS ADDRESS_B,
               NULL AS NUMBER_B,
               LOCAL_ADDRESS.ADDRESS_2 AS COMPL_B,
               LOCAL_ADDRESS.STATE AS DISTRICT_B,
               NULL AS PHONE_NUMBER
        FROM   CUSTOMER_ID_EQUIP_MAP EIEM,
               SERVICE,
               CUSTOMER_ID_ACCT_MAP A,
               EMF_CONFIG_ID_VALUES ECI,
               PRODUCT EP,
               LOCAL_ADDRESS,
               SERVICE_ADDRESS_ASSOC,
               GVT_PRODUCT_VELOCITY GPV,
               S_QUOTE_SOLN Q,
               GVT_FEBRABAN_ACCOUNTS F,
               (SELECT MIN (point_class) AS point_class,
                       TRIM (POINT_STATE_ABBR) AS POINT
                  FROM USAGE_POINTS
                 WHERE INACTIVE_DT IS NULL AND LENGTH (point_class) = 5
                 GROUP BY POINT_STATE_ABBR
                )CNL
       WHERE   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
               AND SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
               AND SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
               AND SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
               AND EIEM.EXTERNAL_ID_TYPE = 1
               AND A.EXTERNAL_ID_TYPE = 1
               AND A.ACCOUNT_NO = SERVICE.PARENT_ACCOUNT_NO
               AND EIEM.INACTIVE_DATE IS NULL
               AND EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
               AND EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO
               AND EP.TRACKING_ID = GPV.TRACKING_ID
               AND EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV
               AND SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
               AND ECI.LANGUAGE_CODE = 2
               AND Q.COPIED_FLG = 'N'
               AND EIEM.EXTERNAL_ID = Q.ASSET_NUM
               AND CNL.POINT = LOCAL_ADDRESS.STATE
               AND   F.EXTERNAL_ID = a.EXTERNAL_ID
               AND   F.ACCOUNT_NO = A.ACCOUNT_NO
               AND   F.INACTIVE_DATE IS NULL
               and   F.ACCOUNT_NO = 4848361      
               
           