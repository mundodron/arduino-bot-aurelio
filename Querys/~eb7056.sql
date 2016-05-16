select * from cmf_balance where bill_ref_no = 156525720

select * from cmf where account_no = 4415970

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor)

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor_bk)

select * from gvt_febraban_ponta_b_arbor_bk where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor)

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'SDR-3012WZUQB'

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'SDR-3012WZUQB-16031'

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'CAS-3012X1LW1'

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'CAS-3012X1LW1-16031' -- inserir

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'RCE-30N9AGF0'

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'RCE-30N9AGF0-003-30N9AGFC'

select * from bill_invoice_detail where BILL_REF_NO = 156524132

Insert into GVT_FEBRABAN_PONTA_B_ARBOR_bk
  (ROW_ID,     CMF_EXT_ID, EMF_EXT_ID        , SERVICE_START                                          , DEGRAU, VELOCIDADE, UNID_VELOCIDADE,    CNLA,    CNLB,                ADDRESS_B, COMPL_B, DISTRICT_B)
Values
  ('3-12X1LWB', '999983129627', 'CAS-3012X1LW1-16031', TO_DATE('03/07/2012 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 's/'  , 100, 'MB'   , '11000', '11000', 'RUA        MIGUEL PASCOAL 104',  '', 'PR');

commit;


select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID = '8006002008'

select * from GVT_FEBRABAN_PONTA_B_ARBOR_BK where CMF_EXT_ID = '999983129627'

select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)

select * 


select ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS,0,1,0,NULL,NULL,NULL,0,NULL,NULL,0,NULL,NULL,2
FROM BILL_INVOICE



select * from gvt_febraban_bill_invoice
WHERE BILL_REF_NO in (156525720,156523327,156524132,156523576,156524570,156524772,156524773,156524974,156522923,156523322,156523931,156524317,156524929,156525539,156524538,156524577,156525538,156525584)
order by 2