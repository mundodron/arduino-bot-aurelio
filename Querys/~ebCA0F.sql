select * from cmf_balance where bill_ref_no in (138094502,137807444,135564977,135338902,135564977,136282138,133457305)

select * from cmf_balance where bill_ref_no in (141213493)


select * from all_tables where table_name like '%INVOICE_CONTROL%' 

select * from GVT_INVOICE_CONTROL where GVT_ACCOUNT_TYPE = 'BOLETO'

select *
  from gvt_bankslip where sequencial in (1200,1212)
   and trunc(DATA_MOVIMENTO) = trunc(DATA_ATUALIZACAO)
   and status = 'B'

select *
  from GVT_INVOICE_CONTROL_DETAIL
 where GVT_ACCOUNT_TYPE = 'BOLETO'
   
   and bill_ref_no = 141641550
 
   and GVT_DATE = '080313'