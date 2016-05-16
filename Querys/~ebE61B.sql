select * from all_tables where owner = 'G0023421SQL'

select * from GVT_RAJADAS_BILL

drop table GVT_RAJADAS_BILL

select * from all_tables where table_name like '%DACC%' 

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = 999986298364

select * from GVT_DACC_HIST_MET_PGTO where external_id = 999986298364

select * from payment_profile where account_no = 3515302

select * from customer_id_acct_map where external_id = '999986298364'

select * from trans_source_values where trans_source = 28

select * from trans_source_ref where source_id = '237'

select * from all_tables where table_name like '%VALUES%' 

select M.EXTERNAL_ID, M.DT_CADASTRO, M.PAY_METHOD, P.PAY_METHOD
  from GVT_DACC_GERENCIA_MET_PGTO M,
       payment_profile p
 where M.EXTERNAL_ID = P.CUST_BANK_ACC_NUM
   and M.PAY_METHOD <> P.PAY_METHOD
   --and M.PAY_METHOD = 1
   and M.OLD_PAY_METHOD = 1
   and trunc(M.DT_CADASTRO) > to_date ('01/01/2011', 'DD/MM/YYYY')
order by 2 desc
     
   and P.PAY_METHOD = 3
   -- and M.EXTERNAL_ID = 999993777879


   GVT_DACC_GERENCIA_FILA_EVENTOS
   
   and M.external_id = '999986298364'
    
   select * from payment_profile where account_no = 1339308
   
   select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999993777879
   
   select * from all_tables where table_name like '%DACC%' 
   
   select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = 999993777879
   
   select * from GVT_DACC_HIST_MET_PGTO where external_id = 999986298364
   
   
       
