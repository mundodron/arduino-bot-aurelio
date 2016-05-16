select count(*),
       REMARK 
  from CMF
 where no_bill = 1
 group by (REMARK)
 order by 1 desc


select count(*), 
       CHG_WHO 
  from CMF
 where no_bill = 1
 group by (CHG_WHO)
 order by 1 desc
 
 
 select * from all_tables where table_name like '%CMF%' 
 
 select quem, quando  from GVT_LOG_CMF
 
 select * from GVT_CONTROLE_NOBILL where account_no = 1510624
 
  R_ARBOR_RO
  
 select * from arborgvt_billing.GVT_CONTROLE_NO_BILL
  
  select * from GVT_CONTROLE_NOBILL order by 1 desc
  
  select * from gvt_no_bill_audit
  
  select * from gvt_log_cmf where account_no = 1510624
  
select * from PROCESS_SCHED 

select * from cmf where remark = 'PROC_AUT_NO_BILL'

select * from CDR_DATA_WORK

select * from cmf where upper(remark) = 'PROC_AUT_NO_BILL'