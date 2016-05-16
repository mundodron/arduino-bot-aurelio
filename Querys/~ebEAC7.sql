select * from GVT_FEBRABAN_PONTA_B_ARBOR


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID     , CMF_EXT_ID    , EMF_EXT_ID         , SERVICE_START                                          , SERVICE_END, DEGRAU, VELOCIDADE, UNID_VELOCIDADE, CNLA   , CNLB   , ADDRESS_B                           , COMPL_B, DISTRICT_B, PHONE_NUMBER)
Values
  ('3-109FV13', '999983795899', 'PROTECT-30109FV14', TO_DATE('21/10/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL       , 's/'  , 0         , ''             , '41000', '41000', 'RODV.      BR 277 (GVT:009903) 591', ''     , 'PR'      , NULL        );




select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no = 133652327 


SELECT MIN(point_class)
FROM USAGE_POINTS
WHERE POINT_STATE_ABBR = RPAD('SP', 6)
AND   INACTIVE_DT IS NULL
AND LENGTH(point_class)=5


SELECT Q.ROW_ID,
       A.EXTERNAL_ID as CMF_EXT_ID,
       EIEM.EXTERNAL_ID as EMF_EXT_ID,
       --SERVICE.EMF_CONFIG_ID,
       --ECI.DISPLAY_VALUE,
       SERVICE.SERVICE_ACTIVE_DT as SERVICE_START,
       null as SERVICE_END,
       's/' as DEGRAU,
       RTRIM(upper(GPV.VELOCITY), 'KMBGT') as VELOCIDADE,
       LTRIM(GPV.VELOCITY, '1234567890.') as UNID_VELOCIDADE,
       decode(LOCAL_ADDRESS.STATE, 'PR','41000',
                                   'SP','11000',
                                   'SC','47000',
                                   'PE','39062',
                                   'RJ','21000') CNLA,
       decode(LOCAL_ADDRESS.STATE, 'PR','41000',
                                   'SP','11000',
                                   'SC','47000',
                                   'PE','39062',
                                   'RJ','21000') CNLB,
       LOCAL_ADDRESS.ADDRESS_1 as ADDRESS_B,
       LOCAL_ADDRESS.ADDRESS_2 as COMPL_B, 
       LOCAL_ADDRESS.STATE as DISTRICT_B,
       null as PHONE_NUMBER
       -- ,display_value
FROM  CUSTOMER_ID_EQUIP_MAP EIEM,
      SERVICE,
      CUSTOMER_ID_ACCT_MAP A,
      EMF_CONFIG_ID_VALUES ECI,
      PRODUCT EP,
      LOCAL_ADDRESS,
      SERVICE_ADDRESS_ASSOC,       
      GVT_PRODUCT_VELOCITY GPV,
      S_QUOTE_SOLN Q,
      GVT_FEBRABAN_PONTA_B_ARBOR F
WHERE service.parent_ACCOUNT_NO in (select account_no from customer_id_acct_map where external_id in ('999983892842','999982223746'))
AND   SERVICE_ADDRESS_ASSOC.address_id = LOCAL_ADDRESS.address_id
AND   SERVICE_ADDRESS_ASSOC.account_no = service.parent_account_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no = service.subscr_no
AND   SERVICE_ADDRESS_ASSOC.subscr_no_resets = service.subscr_no_resets
AND   EIEM.EXTERNAL_ID_TYPE = 1
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
AND   F.CMF_EXT_ID = a.EXTERNAL_ID
AND   F.SERVICE_END IS NULL
AND   GPV.VELOCITY IS NOT NULL
--AND   EIEM.EXTERNAL_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)

order by DISTRICT_B

AND   display_value like '%Ethernet Line%' ;

select Q.ROW_ID, A.EXTERNAL_ID as CMF_EXT_ID, C.EXTERNAL_ID as EMF_EXT_ID, A.ACCOUNT_NO, 
       p.SERVICE_START, P.ADRESS_B, P.COMPL_B, P.DISTRICT_B, P.VELOCIDADE, P.UNID_VELOCIDADE, P.CNL, A.ACCOUNT_NO
  from customer_id_acct_map a,
       service s,
       customer_id_equip_map c,
       s_org_ext x,
       s_quote_soln q,
      BQ_FEBRABAN_PONTA p           
 where A.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
   and S.SUBSCR_NO = C.SUBSCR_NO
   and S.SUBSCR_NO_RESETS = C.SUBSCR_NO_RESETS
   and A.EXTERNAL_ID = '999983129627'
   and X.X_ACCT_ID_NUM = A.EXTERNAL_ID
   and X.x_acct_id_num = '999983129627'
   and P.EXTERNAL_ID = A.EXTERNAL_ID
   and C.EXTERNAL_ID = q.ASSET_NUM
   
select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID in ('TOO-30109FV11-013')


select RTRIM ('500K' ,'KMB') from dual;

select LTRIM ('500K' ,'1234567890') from dual;


decode(LOCAL_ADDRESS.STATE, 'PR', '41000',
                            'SC', '11000') CNLA