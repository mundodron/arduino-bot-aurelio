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
               AND   F.INACTIVE_DATE IS NULL      
               AND not EXISTS (SELECT   1
                                 FROM   GVT_FEBRABAN_PONTA_B_ARBOR B
                                WHERE   B.EMF_EXT_ID = EIEM.EXTERNAL_ID);
                                
                                
                                
                                
                                    INSERT INTO GVT_CONTAS_CONTAFACIL
    select ACCOUNT_NO,
           ACCOUNT_CATEGORY,
           Processo
      from backlog_cdc
     where account_no not in (select account_no from GVT_CONTAS_CONTAFACIL);
     
     select * from backlog_cdc
     
     update backlog_cdc set DATA_PROCESSAMENTO = (select DATA_PROCESSAMENTO from GVT_CONTA_INTERNET where backlog_cdc.account_no = GVT_CONTA_INTERNET.account_no)
     
     select * from GVT_CONTA_INTERNET where account_no = 10373189
     
     ALTER TABLE G0023421SQL.BACKLOG_CDC ADD (DATA_PROCESSAMENTO DATE);
     
     select * from BACKLOG_CDC
  
     UPDATE backlog_cdc SET DATA_PROCESSAMENTO = (SELECT DATA_PROCESSAMENTO
                                                    FROM GVT_CONTA_INTERNET
                                                   WHERE GVT_CONTA_INTERNET.account_no = backlog_cdc.account_no
                                                     AND GVT_CONTA_INTERNET.bill_ref_no = backlog_cdc.REFNO);
     
     SELECT GVT_CONTA_INTERNET.bill_ref_no , count(1)--GVT_CONTA_INTERNET.DATA_PROCESSAMENTO
       FROM GVT_CONTA_INTERNET, 
            backlog_cdc
      where backlog_cdc.account_no = GVT_CONTA_INTERNET.account_no
        and GVT_CONTA_INTERNET.bill_ref_no = backlog_cdc.REFNO
        group by GVT_CONTA_INTERNET.bill_ref_no having count(1) > 1
        
          
                              WHERE GVT_CONTA_INTERNET.account_no = backlog_cdc.account_no
                                                     AND GVT_CONTA_INTERNET.bill_ref_no = backlog_cdc.REFNO
     
     
     UPDATE backlog_cdc SET DATA_PROCESSAMENTO = SELECT GVT_CONTA_INTERNET.DATA_PROCESSAMENTO FROM GVT_CONTA_INTERNET WHERE GVT_CONTA_INTERNET.account_no = backlog_cdc.account_no
     
     
     create table backlog_cdc as
     select nome_arquivo arq, external_id, count(1) QT, max(account_no) account_no, max(bill_ref_no) bill_ref_no, max(data_processamento) data_processamento,10 ACCOUNT_CATEGORY,
       (1+ABS(MOD(dbms_random.random,100))) as PROCESSO
       from GVT_CONTA_INTERNET
      where data_processamento between to_date('20151001','yyyymmdd') and to_date('20160401','yyyymmdd')
        and bill_ref_no is not null
   group by nome_arquivo, external_id 
     having count(1) > 1

   update backlog_cdc set processo = 15 where bill_ref_no = 316470997
   
   select * from backlog_cdc where account_no =  9537955
   
    select account_no,PROCESSO, count(1) from backlog_cdc group by account_no, PROCESSO having count(1) > 1


