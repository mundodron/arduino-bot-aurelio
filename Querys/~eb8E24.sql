SELECT DISTINCT
           s.subscr_no si,        s.subscr_no_resets sir,       service_name_pre,      service_fname,      service_minit,
           service_lname,         m.external_id,                null  ext_id_v  ,      address_1,           address_2,
           address_3,              service_company,              city,                   county,             state,
           postal_code,              ccv.display_value,            s.parent_account_no,  r.description_code, s.service_name_generation,
           sb.service_geocode,     sb.service_franchise_tax_code,cfg.display_value,     c.short_display,    s.service_active_dt,
           s.service_inactive_dt, rec.recurso,                  cfg.short_display,     pb.degrau degrau,   pb.cnla cnla,
           pb.velocidade vel,     pb.unid_velocidade unid_vel,  pb.cnlb cnlb,          pb.address_b addrb, pb.number_b nb,
           pb.compl_b cb,         pb.district_b bairro,         pb.phone_number
    FROM   BILL_INVOICE b, SIN_SEQ_NO ssn, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, COUNTRY_CODE_VALUES ccv, EMF_CONFIG_ID_VALUES cfg, 
           EQUIP_CLASS_CODE_VALUES c, RATE_CLASS_DESCR r, GVT_FEBRABAN_RECURSOS rec, GVT_FEBRABAN_PONTA_B_ARBOR pb, 
           SERVICE_BILLING sb, LOCAL_ADDRESS l, Service_Address_Assoc saa
    WHERE  b.bill_ref_no              = _Orig_bill_refno
      AND  b.bill_ref_resets          = _Orig_bill_ref_resets
      AND  ssn.bill_ref_no            = b.bill_ref_no
      AND  ssn.bill_ref_resets        = b.bill_ref_resets
      AND  s.parent_account_no        = b.account_no 
      AND     s.parent_account_no                = saa.account_no
      AND     s.subscr_no                                = saa.subscr_no
      AND  s.subscr_no_resets                    = saa.subscr_no_resets
      AND     l.address_id                                = saa.address_id
      AND  DECODE(ssn.open_item_id,0,1,ssn.open_item_id) in 
                   ( SELECT distinct open_item_id 
                               FROM bill_invoice_detail
                           WHERE bill_ref_no = b.bill_ref_no
                             AND bill_ref_resets = b.bill_ref_resets
                             AND TYPE_CODE != 5
                             AND subscr_no = s.subscr_no
                   )                           
      AND  m.subscr_no                = s.subscr_no
      AND  m.subscr_no_resets         = s.subscr_no_resets
      AND  m.subscr_no                = sb.subscr_no
      AND  m.subscr_no_resets         = sb.subscr_no_resets
      AND  m.external_id_type         = s.display_external_id_type
      AND  m.is_current               = 1
      AND  m.external_id              = pb.emf_ext_id
      AND  l.country_code             = ccv.country_code     (+)
      AND  ccv.language_code (+)      = _language_code
      AND  m.external_id_type         != 6
      AND  s.emf_config_id            = cfg.emf_config_id    (+)
      AND  cfg.language_code (+)      = _language_code
      AND  sb.equip_class_code        = c.equip_class_code   (+)
      AND  c.language_code   (+)      = _language_code
      AND  s.rate_class               = r.rate_class
      AND  s.emf_config_id            = rec.emf_config_id    (+)
      AND  rec.language_code (+)      = _language_code                    
    UNION ALL      
    SELECT DISTINCT
           s.subscr_no si,        s.subscr_no_resets sir,       service_name_pre,      service_fname,      service_minit,
           service_lname,         m.external_id,                null ext_id_v   ,     address_1,           address_2,
           address_3,              service_company,              city,                  county,             state,
           postal_code,                ccv.display_value,            s.parent_account_no,  r.description_code, s.service_name_generation,
           sb.service_geocode,     sb.service_franchise_tax_code,cfg.display_value,     c.short_display,    s.service_active_dt,
           s.service_inactive_dt, rec.recurso,                  cfg.short_display,     NULL degrau,        NULL cnla,
           0 vel,                 NULL unid_vel,                NULL cnlb,             NULL addrb,         NULL nb,
           NULL cb,               NULL bairro,                  NULL phone_number
    FROM   BILL_INVOICE b, SIN_SEQ_NO ssn, SERVICE s, CUSTOMER_ID_EQUIP_MAP m, COUNTRY_CODE_VALUES ccv, EMF_CONFIG_ID_VALUES cfg, 
           EQUIP_CLASS_CODE_VALUES c, RATE_CLASS_DESCR r, GVT_FEBRABAN_RECURSOS rec, SERVICE_BILLING sb, LOCAL_ADDRESS l, Service_Address_Assoc saa
    WHERE  b.bill_ref_no              = _Orig_bill_refno
      AND  b.bill_ref_resets          = _Orig_bill_ref_resets
      AND  ssn.bill_ref_no            = b.bill_ref_no
      AND  ssn.bill_ref_resets        = b.bill_ref_resets
      AND  s.parent_account_no        = b.account_no 
      AND     s.parent_account_no                = saa.account_no
      AND     s.subscr_no                                = saa.subscr_no
      AND  s.subscr_no_resets                    = saa.subscr_no_resets
      AND     l.address_id                                = saa.address_id
      AND  decode(ssn.open_item_id,0,1,ssn.open_item_id) in 
                   ( SELECT distinct open_item_id 
                               FROM bill_invoice_detail
                           WHERE bill_ref_no = b.bill_ref_no
                             AND bill_ref_resets = b.bill_ref_resets
                             AND TYPE_CODE != 5
                             AND subscr_no = s.subscr_no
                   )                           
      AND  m.subscr_no                = s.subscr_no
      AND  m.subscr_no_resets         = s.subscr_no_resets
      AND  m.subscr_no                = sb.subscr_no
      AND  m.subscr_no_resets         = sb.subscr_no_resets
      AND  m.external_id_type         = s.display_external_id_type
      AND  m.is_current               = 1
      AND  l.country_code             = ccv.country_code     (+)
      AND  ccv.language_code (+)      = _language_code
      AND  s.emf_config_id            = cfg.emf_config_id    (+)
      AND  cfg.language_code (+)      = _language_code
      AND  m.external_id_type           = 6    
      AND  sb.equip_class_code        = c.equip_class_code   (+)
      AND  c.language_code   (+)      = _language_code
      AND  s.rate_class                = r.rate_class
      AND  s.emf_config_id            = rec.emf_config_id    (+)
      AND  rec.language_code (+)      = _language_code
    ORDER  BY si, sir
    
    
    
Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID, CMF_EXT_ID, EMF_EXT_ID, SERVICE_START, DEGRAU, VELOCIDADE, UNID_VELOCIDADE, CNLA, CNLB, ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1MP', '999985081749', 'GNA-30W2TANT-9698', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/', 9, 'MB', '61008', '61008', 'RUA 2 140', 'SJ SEGUNDA', 'GO');                 

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1LP', '999985081813', 'CPE-30W2TABH-9698', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '66000', '66000', 'RUA        BARAO DO RIO BRANCO 1256',  'AN 4', 'MS');

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1LY', '999985081812', 'VTA-30W2TAPT-9698', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '27000', '27000', 'AVENIDA NOSSA SENHORA DA PENHA 585',  '', 'ES');

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1M7', '999985081811', 'SDR-30W2TAG9-9698', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '71000', '71000', 'AVENIDA    ANTONIO CARLOS MAGALHAES 3840',  '', 'BA');

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-10PGSXR', '999983680795', 'PAE-3010PGSXQ', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '51000', '51000', 'AV.        SOLEDADE (GVT:034037) 550',  'AN 4 CJ 1201', 'RS');

Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2TAOE', '999985081815', 'FNS-30W2TAOD', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 1, 'MB'   , '47000', '47000', 'RUA FULVIO ADUCCI 1341',  '', 'SC');


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1MY', '999985081748', 'BSA-30W2TACH-9698', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '61000', '61000', 'BL         CRS 506 BLOCO A 506',  '', 'DF');




Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-10OHO9R', '999986501841', 'RCE-30S07RBK-003-30S07RBT', TO_DATE('01/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 10, 'MB'   , '61000', '61000', 'RUA        VINTE E QUATRO DE AGOSTO 209',  '', 'PE');


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-PFQUMJ', '999987348053', 'RJO-30PFRD6O-003', TO_DATE('01/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 100, 'MB'   , '21000', '21000', 'RUA        VINTE E QUATRO DE AGOSTO 209',  '', 'RJ');


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-12X1LW2', '999983129627', 'CAS-3012X1LW1', TO_DATE('03/07/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 100, 'MB'   , '11000', '11000', 'RUA        MIGUEL PASCOAL 104',  '', 'SP');


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-12WZUQC', '777777758100', 'SDR-3012WZUQB', TO_DATE('03/07/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 100, 'MB'   , '71000', '71000', 'RUA        URUGUAI 47/',  '', 'BA');


---
COMMIT;

select * 
  from BQ_FEBRABAN_PONTA
 where external_id = 999983680795


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
   
   select * from GVT_FEBRABAN_PONTA_B_ARBOR where CMF_EXT_ID = 999983129627
   
   select * from s_quote_soln where ASSET_NUM = 'FNS-30W2TAOT-9698'
   
   
   and A.EXTERNAL_ID = 'FNS-30W2TAOT-9698'
   
   --FNS-30W2TAOT-9698
   
   select * from s_quote_soln where ASSET_NUM = 'FNS-30W2TAOT-9698'
   
   GNA-30W2TAHT
   
--- contas com problema.  
INSERT INTO GVT_FEBRABAN_BILL_INVOICE 
select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE
WHERE BILL_REF_NO in (114144521,114147316,114146316,114146744,114145538,114144930,114145131,114145533,114145913,114146123,114147139);
commit;

select * from ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR where CMF_EXT_ID = '999983225553'


Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-13S5SK9', '999983225553', 'SPO-3012I7QYJ-032', TO_DATE('01/31/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 0, 'MB'   , '11000', '11000', 'AV         PAULISTA 2073',  'CJ Conjunto Nacional', 'SP');



Insert into ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-W2R1MP', '999985081749', 'GNA-30W2TAHT', TO_DATE('05/13/2011 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 9, 'MB'   , '61008', '61008', 'RUA 2 140',  'SJ SEGUNDA', 'GO');

select * from cmf where account_no = 2670087

   select * from s_quote_soln where ASSET_NUM = 'SDR-30W2TAFT'
