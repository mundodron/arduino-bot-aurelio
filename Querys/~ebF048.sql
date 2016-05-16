
  select * 
  from all_triggers
  where status = 'ENABLED'
  and owner not in ('ARBOR', 'ARBOR_TEMP')
  and table_name in (select table_name from account_move_tables)
  and trigger_name like 'CMF%_CONTROLE_NO_BILL'
  
  select * from gvt_no_bill_audit
  
  select * from GVT_CONTROLE_NO_BILL
  
     SELECT EXTERNAL_ID,SYSDATE,0
       FROM CUSTOMER_ID_ACCT_MAP EIAM
       WHERE 1=1 --EIAM.ACCOUNT_NO = :OLD.ACCOUNT_NO
       AND   EIAM.EXTERNAL_ID_TYPE=1;