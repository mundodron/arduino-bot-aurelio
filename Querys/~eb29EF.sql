drop table G0023421SQL.GVT_RAJADAS_BILL force;

CREATE TABLE G0023421SQL.GVT_RAJADAS_BILL
(
  EXTERNAL_ID  VARCHAR2(12),
  ACCOUNT_NO   NUMBER(10),
  BILL_REF_NO  NUMBER(10),
  BAIXA        NUMBER(10),
  V_DEBITO     NUMBER(16),
  V_PAGO       NUMBER(16),
  DT_PAGTO     DATE,
  MSG          VARCHAR2(2000),
  NSA          NUMBER(12),
  STATUS       VARCHAR2(10)
 );
 
 grant all on G0023421SQL.GVT_RAJADAS_BILL to public;
 
 select * from G0023421SQL.GVT_RAJADAS_BILL
 
 truncate table G0023421SQL.GVT_RAJADAS_BILL
 
  select * from G0023421SQL.GVT_RAJADAS_BILL where external_id = '999984284251'
  
  
  update G0023421SQL.GVT_RAJADAS_BILL set status = 99
  
  update GVT_RAJADAS_BILL set account_no = null
  
  update G0023421SQL.GVT_RAJADAS_BILL B set b.account_no = (select m.account_no from customer_id_acct_map m where m.external_id = b.external_id)
  
  
    truncate table G0023421SQL.GVT_RAJADAS_BILL
    
    
    select external_id, account_no, bill_ref_no, valor from gvt_rajadas where status = 1 and account_no is not null
    
    
 update G0023421SQL.GVT_RAJADAS_BILL set status = 99
 
 
 
 select * from bmf where tracking_id in (62810977,62810978,62810979) and ACTION_CODE = 'API' 
 
 
 select * from all_tables where table_name like '%PROFORMA%'
 
 
 
 select count(*) from ARBORGVT_BILLING.GVT_PROFORMA_CONTAS_SME
 
 
  select * from gvt_rajadas where status = 28
 