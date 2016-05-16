SET VERIFY                     OFF;
SET SERVEROUT                  ON SIZE 1000000;
SET FEED                       OFF;
SET SPACE                      0;
SET PAGESIZE                   0;
SET LINE                       500;
SET WRAP                       ON;
SET HEADING                    OFF;

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
               TO_NUMBER (
                  RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT ')
               )
                  VELOCIDADE,
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
               GVT_FEBRABAN_PONTA_B_ARBOR F,
               (  SELECT   MIN (point_class) AS point_class,
                           TRIM (POINT_STATE_ABBR) AS POINT
                    FROM   USAGE_POINTS
                   WHERE   INACTIVE_DT IS NULL AND LENGTH (point_class) = 5
                GROUP BY   POINT_STATE_ABBR) CNL
       WHERE   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
               AND SERVICE_ADDRESS_ASSOC.account_no =
                     service.parent_account_no
               AND SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
               AND SERVICE_ADDRESS_ASSOC.subscr_no_resets =
                     service.subscr_no_resets
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
               AND F.CMF_EXT_ID = a.EXTERNAL_ID
               AND F.SERVICE_END IS NULL
               AND CNL.POINT = LOCAL_ADDRESS.STATE
               -- AND   service.parent_ACCOUNT_NO in (select account_no from customer_id_acct_map where external_id in ('999980450607'))
               AND NOT EXISTS (SELECT   1
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
               DBMS_OUTPUT.put_line ('ERRO AO TENTAR INSERIR: ' || x.CMF_EXT_ID||' - '|| x.EMF_EXT_ID || '- ERRO: ' || SQLERRM );
         END;
      END IF;
   END LOOP;
END;


-- truncate table GVT_FEBRABAN_PONTA_B_ARBOR_BK

-- select * from GVT_FEBRABAN_PONTA_B_ARBOR_BK

-- select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk bk where BK.EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)