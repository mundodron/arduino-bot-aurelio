select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (142148136,141759364)

select * from GVT_FBB_BILL_INVOICE where bill_ref_no in (142148136,141759364)

select * from gvt_febraban_accounts where account_no in (4646486,2633494)

144714550    $423,615.47
141811211    $385,398.94
138842913    $313,346.26
136203175    $364,167.46


select * from all_tables where table_name like '%DETALHADA%' 

select * from cmf_balance where bill_ref_no in (144714550,141811211,138842913,136203175)

select * from GVT_PL_CONTA_DETALHADA

select * from gvt_conta_internet where account_no = 3858364 and bill_ref_no in (144714550,141811211,138842913,136203175)

select * from CDC_PROCESSAR_BACKLOG

truncate table CDC_PROCESSAR_BACKLOG


select * from GVT_CONTAS_CONTAFACIL

Insert into GVT_CONTAS_CONTAFACIL
   (ACCOUNT_NO, ACCOUNT_CATEGORY, PROCESSO)
 Values
   (3858364, 10, 99);
COMMIT;



