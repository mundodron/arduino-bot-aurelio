DECLARE
   v_errcode   NUMBER (10) := 0;

   CURSOR c1
   IS
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
                                
BEGIN
   FOR x IN c1
   LOOP
      IF v_errcode = 0
      THEN
         BEGIN
            INSERT INTO GVT_FEBRABAN_PONTA_B_ARBOR_BK (ROW_ID,
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
              VALUES   (x.ROW_ID,
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

               DBMS_OUTPUT.put_line('Registo Inserido: ' || x.CMF_EXT_ID ||' - '|| x.EMF_EXT_ID );
            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('3RRO AO TENTAR INSERIR: ' || x.CMF_EXT_ID||' - '|| x.EMF_EXT_ID || '- 3RRO: ' || SQLERRM );
         END;
      END IF;
   END LOOP;
   COMMIT;
END;


select * from ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR where emf_ext_id in ('VTA-30S0UIWH','VTA-30S0UIWH-9592-30S0UIWJ','GJA-30S16ESL','GJA-30S16ESL-9592-30S16ESN','PNG-30XLGOTH','PNG-30XLGOTH-9592-30XLGOTJ','RJO-30RS33CG','RJO-30RS33CG-9592-30RS33CI','RJO-30LB35DG','RJO-30LB35DG-012-30LB35DU','GJA-30VCGS8I','GJA-30VCGS8I-9699-30VCGS8K','SDR-30JS079H','SDR-30JS07A0-9698','PNG-30JS06YZ','PNG-30JS06ZI-9698','VTA-30JS0702','VTA-30JS070L-9698','RJO-301KE6YA3','RJO-301KE6YA3-9699-301KE6YAT','SGO-30L4JYJX','SGO-30L4JYJX-9699-30L4JYJZ','SGO-301KE6YBN','SGO-301KE6YBN-9699-301KE79LL','SGO-301KFJ272','SGO-301KFJ27G-012','RJO-301KFP9VV','RJO-301KFP9W9-012','RJO-30S1A8KD','RJO-30S1A8KD-9592-30S1A8KF','RJO-30S18ORN-036','SDR-30S0UOEJ','SDR-30S0UOEJ-9592-30S0UOEL','SGO-30S1488F','SGO-30S1488F-9592-30S1488H','SGO-301D8K81U','SGO-301D8K81U-9592-301D8K81T','SGO-301KFQ6R7','SGO-301KFQ6RL-012')

-- truncate table GVT_FEBRABAN_PONTA_B_ARBOR_BK

-- select * from GVT_FEBRABAN_PONTA_B_ARBOR_BK

-- select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk bk where BK.EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)

-- select * from GVT_FEBRABAN_PONTA_B_ARBOR bk where BK.EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR_BK)