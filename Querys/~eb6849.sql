Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID, CMF_EXT_ID, EMF_EXT_ID, SERVICE_START, DEGRAU, VELOCIDADE, UNID_VELOCIDADE, CNLA, CNLB, ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1LY', '999985081812', 'VTA-30W2TAPD', TO_DATE('03/27/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/', 100, 'MB        ', '21000', '21000', 'AVENIDA RIO BRANCO 123', 'AN 3', 'RJ');                 

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (     ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-111LT24', '999987348053', 'RJO-30XRF8J5-003', TO_DATE('11/04/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 100       , 'MB        '   , '21000', '21000', 'AVENIDA RIO BRANCO 123',  'AN 3', 'RJ');
COMMIT;



select * from customer_id_equip_map where subscriber_no = 

select X.ROW_ID, A.EXTERNAL_ID as CMF_EXT_ID, E.EXTERNAL_ID as EMF_EXT_ID
  from s_org_ext x,
       customer_id_equip_map e,
       customer_id_acct_map a,
       service s
 where e.SUBSCR_NO = s.SUBSCR_NO
   and A.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
   and x.x_acct_id_num = '999985081812'--A.EXTERNAL_ID
   and A.EXTERNAL_ID_TYPE = 1
   and A.INACTIVE_DATE is null
   and A.EXTERNAL_ID = '999985081812'
   
   select * from service
  
  select * from cmf where account_no = 



select * from service where parent_account_no = 3856302 

