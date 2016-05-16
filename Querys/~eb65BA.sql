    SELECT   DISTINCT
               (Q.ROW_ID),
               A.EXTERNAL_ID AS CMF_EXT_ID,
               EIEM.EXTERNAL_ID AS EMF_EXT_ID,
               SERVICE.SERVICE_ACTIVE_DT AS SERVICE_START,
               NULL AS SERVICE_END,
               's/' AS DEGRAU,
               TO_NUMBER (
                     replace(replace(RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT '),'.0',null),'.00',null)
               )
                  VELOCIDADE,
               LTRIM (GPV.VELOCITY, '1234567890.') AS UNID_VELOCIDADE,
               CNL.point_class AS CNLA,
               CNL.point_class AS CNLB,
               LOCAL_ADDRESS.ADDRESS_1 AS ADDRESS_B,
               NULL AS NUMBER_B,
               LOCAL_ADDRESS.ADDRESS_2 AS COMPL_B,
               LOCAL_ADDRESS.STATE AS DISTRICT_B,
               NULL AS PHONE_NUMBER,
               LOCAL_ADDRESS.ADDRESS_ID
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
               (  SELECT   MIN (point_class) AS point_class,
                           TRIM (POINT_STATE_ABBR) AS POINT
                    FROM   USAGE_POINTS
                   WHERE   INACTIVE_DT IS NULL AND LENGTH (point_class) = 5
                GROUP BY   POINT_STATE_ABBR) CNL
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
               -- AND   service.parent_ACCOUNT_NO in (select CMF_EXT_ID from gvt_febraban_ponta_B_arbor where NUMBER_B is not null and rownum <200000000000000000000000000000000000000000000000000000000)
               AND Q.EXTERNAL_ID in ('RJO-30S1A8KD-9592-30S1A8KF','SGO-301D8K81U-9592-301D8K81T','SGO-30S1488F-9592-30S1488H')
               
               select * from gvt_febraban_ponta_B_arbor where NUMBER_B is not null and rownum <200000000000
               
               select * from LOCAL_ADDRESS
               
               select Q.ASSET_NUM, EIEM.EXTERNAL_ID, EIEM.SUBSCR_NO, EIEM.VIEW_ID, EIEM.EXTERNAL_ID_TYPE
                 from S_QUOTE_SOLN Q,
                      CUSTOMER_ID_EQUIP_MAP EIEM
                where Q.ASSET_NUM in ('RJO-30S1A8KD-9592-30S1A8kF','SGO-301D8K81U-9592-301D8K81T','SGO-30S1488F-9592-30S1488H')
                  AND Q.COPIED_FLG = 'N'
                  
                  AND EIEM.EXTERNAL_ID = Q.ASSET_NUM
        
                  
                select * from CUSTOMER_ID_EQUIP_MAP where external_id in ('RJO-30S1A8KD-9592-30S1A8KF','SGO-301D8K81U-9592-301D8K81T','SGO-30S1488F-9592-30S1488H')