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
 
 select * from G0023421SQL.GVT_RAJADAS_BILL where external_id in (select external_id from customer_id_acct_map) and status != 99
 


 -- update G0023421SQL.GVT_RAJADAS_BILL B set account_no = (select account_no from customer_id_acct_map where external_id = b.external_id)
  
 select * from GVT_RAJADAS_BILL where account_no is not null
  
 -- update GVT_RAJADAS_BILL set account_no = null
  
 select * from gvt_rajadas_bill where external_id = '999994226920'
  
 -- update GVT_RAJADAS_BILL B set b.account_no = (select m.account_no from customer_id_acct_map m where m.external_id = b.external_id)
 
 select * from gvt_rajadas_bill where external_id = '999983866357'
 
 select nsa, count(*) from gvt_rajadas_bill group by nsa
 
 
  select * from gvt_rajadas where status = 28