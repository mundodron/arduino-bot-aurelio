Select MAP.EXTERNAL_ID, CMF.BILL_LNAME, CMF.BILL_PERIOD , bil.bill_ref_no, CMF.ACCOUNT_CATEGORY, bil.prep_date, PC.PROCESSAMENTO, CMF.NO_BILL, MAP.INACTIVE_DATE
  from bill_invoice bil, cmf, GVT_PROCESSAMENTO_CICLO PC, customer_id_acct_map map
 where bil.prep_date > '01/03/2016'
   and bil.prep_status = 1
   and BIL.ACCOUNT_NO = CMF.ACCOUNT_NO
   and bil.prep_error_code is null
   and MAP.ACCOUNT_NO = BIL.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and bil.format_error_code is not null
   and PC.BILL_PERIOD = BIL.BILL_PERIOD
   and bil.backout_status = 0
   and exists (select 1 from bill_invoice_detail bb where bb.bill_ref_no = bil.bill_ref_no and bb.provider_id <> 25 and bb.type_code = 3 and open_item_id in (94,95))
   and not exists (select 1 from bill_invoice_detail bb where bb.bill_ref_no = bil.bill_ref_no and bb.provider_id <> 25 and bb.type_code = 3 and open_item_id = 93)
   and external_id in ('899996521337','899995042041')



select * from all_tables where table_name like '%DETALHAMENTO%'

select * from GVT_PROCESSAMENTO_CICLO

select * from GVT_DETALHAMENTO_CICLO

select * from bill_invoice_detail where bill_ref_no = 339891324 and provider_id <> 25 and type_code in (2,3,4,7)

select * from cmf_balance_detail where bill_ref_no = 339891324
