      SELECT   DISTINCT
               (Q.ROW_ID),
               A.EXTERNAL_ID AS CMF_EXT_ID,
               EIEM.EXTERNAL_ID AS EMF_EXT_ID,
               SERVICE.SERVICE_ACTIVE_DT AS SERVICE_START,
               NULL AS SERVICE_END,
               's/' AS DEGRAU,
               case when trim(translate (replace(replace(RTRIM (REPLACE (UPPER (GPV.VELOCITY), ',', '.'), 'KMBGT '),'.0',null),'.00',null), '0123456789', ' ')) is null then replace(replace(RTRIM (REPLACE (UPPER (NVL(GPV.VELOCITY,0)), ',', '.'), 'KMBGT '),'.0',null),'.00',null) else '0' end VELOCIDADE,
               nvl(LTRIM (GPV.VELOCITY, '1234567890.'),'NA') AS UNID_VELOCIDADE,
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
               AND EP.TRACKING_ID = GPV.TRACKING_ID(+)
               AND EP.TRACKING_ID_SERV = GPV.TRACKING_ID_SERV(+)
               AND SERVICE.EMF_CONFIG_ID = ECI.EMF_CONFIG_ID
               AND ECI.LANGUAGE_CODE = 2
               AND Q.COPIED_FLG = 'N'
               AND EIEM.EXTERNAL_ID = Q.ASSET_NUM
               AND CNL.POINT = LOCAL_ADDRESS.STATE
               AND   F.EXTERNAL_ID = a.EXTERNAL_ID
               AND   F.ACCOUNT_NO = A.ACCOUNT_NO
               and a.external_id = '999979685476'
               AND   F.INACTIVE_DATE IS NULL
               
               
                              AND not EXISTS (SELECT   1
                                 FROM   GVT_FEBRABAN_PONTA_B_ARBOR B
                                WHERE   B.EMF_EXT_ID = EIEM.EXTERNAL_ID);
                                
               select * from gvt_febraban_ponta_b_arbor
                                
                                
               select * from gvt_febraban_accounts where external_id = '999979685476'
               
               select * from service where PARENT_ACCOUNT_NO = 9193322
               
               select * from customer_id_equip_map where subscr_no in (29238049,29238050)
               
               select * from S_QUOTE_SOLN where ASSET_NUM in ('CTA-301KINM3R-16032-301KINM40','CTA-301KINM3R')
               
               select * from product where parent_SUBSCR_NO in (29238049,29238050)
               and TRACKING_ID = 
               
               select * from GVT_PRODUCT_VELOCITY where TRACKING_ID in (select TRACKING_ID from product where parent_SUBSCR_NO in (29238049,29238050))
               
               
                select * from descriptions where description_code = 12812
                
                INSERT INTO GVT_CONTAS_CONTAFACIL
select ACCOUNT_NO,
12 as ACCOUNT_CATEGORY,
1 as PROCESSO
from contafacil_corp;
               
               
               
