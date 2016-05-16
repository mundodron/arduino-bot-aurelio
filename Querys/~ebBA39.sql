      SELECT   DISTINCT
               (Q.ROW_ID),
               A.EXTERNAL_ID AS CMF_EXT_ID,
               EIEM.EXTERNAL_ID AS EMF_EXT_ID,
               SERVICE.SERVICE_ACTIVE_DT AS SERVICE_START,
               NULL AS SERVICE_END,
               's/' AS DEGRAU,
                     replace(replace(RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT '),'.0',null),'.00',null)
                  VELOCIDADE,
               LTRIM (GPV.VELOCITY, '1234567890.') AS UNID_VELOCIDADE,
               CNL.point_class AS CNLA,
               CNL.point_class AS CNLB,
               LOCAL_ADDRESS.ADDRESS_1 AS ADDRESS_B,
               NULL AS NUMBER_B,
               LOCAL_ADDRESS.ADDRESS_2 AS COMPL_B,
               LOCAL_ADDRESS.STATE AS DISTRICT_B,
               NULL AS PHONE_NUMBER,
               GPV.END_DT
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
               AND A.EXTERNAL_ID_TYPE in (1,7)
               AND A.ACCOUNT_NO = SERVICE.PARENT_ACCOUNT_NO
               AND EIEM.INACTIVE_DATE IS NULL
               AND EIEM.SUBSCR_NO = SERVICE.SUBSCR_NO
               AND EIEM.SUBSCR_NO = EP.parent_SUBSCR_NO
               AND EP.TRACKING_ID = GPV.TRACKING_ID
               AND GPV.END_DT is null
               AND EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV
               AND SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
               AND ECI.LANGUAGE_CODE = 2
               AND Q.COPIED_FLG = 'N'
               AND EIEM.EXTERNAL_ID = Q.ASSET_NUM
               AND CNL.POINT = LOCAL_ADDRESS.STATE
               AND   F.EXTERNAL_ID = a.EXTERNAL_ID
               AND   F.ACCOUNT_NO = A.ACCOUNT_NO
               AND   F.INACTIVE_DATE IS NULL
               AND   service.parent_ACCOUNT_NO in (select account_no from customer_id_acct_map where external_id in ('777777752096','999986491618','999984588981','999986600869','999988685449','999985332929','999989197584','999989197583','999989197581','999979696940','777777763529','999979696381','777777760729','777777752092','999986492349','999980674767','999979696307'))      
               
               AND not EXISTS (SELECT   1
                                 FROM   GVT_FEBRABAN_PONTA_B_ARBOR B
                                WHERE   B.EMF_EXT_ID = EIEM.EXTERNAL_ID);
                                
                                
                                                                select * from bill_invoice where bill_ref_no = 231921369