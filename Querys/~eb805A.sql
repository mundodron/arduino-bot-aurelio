select * from GVT_NRC_INVALIDA where fatura in (select bill_ref_no from cmf_balance where closed_date is null)

select * from cmf_balance where closed_date is null and bill_ref_no in (select fatura from GVT_NRC_INVALIDA)

select * from payment_trans where tracking_id in (8259734,8259665,8260020,8326507)
and bill_ref_no in (94351958,94351552,94351593,94383148);


select * from gvt_nrc_invalida where conta = '999989075484'


-- update gvt_nrc_invalida g set g.status = (select account_no from customer_id_acct_map where G.CONTA = external_id)

select * from gvt_nrc_invalida where conta  = '999989075484'

select * 
   from payment_trans where account_no in (select status from gvt_nrc_invalida)
   
   
   select * from cmf_balance_detail
   
   select * from all_tables where table_name like '%DISTRIBU%' 
   
   select * from BMF_DISTRIBUTION