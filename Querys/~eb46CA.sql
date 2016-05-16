select * from gvt_no_bill_audit where new_no_bill <> 0

  order by NEW_NO_BILL

select count(*) from gvt_no_bill_audit 

select CHG_WHO
  from gvt_no_bill_audit
 where CHG_WHO not like '%bip%'
   and NEW_NO_BILL = 1
   group by CHG_WHO;
   
   
   select * from all_users where USERNAME like '%%'
   
   CREATE INDEX ARBORGVT_BILLING.IDX_ACCOUNT_NO_GVT_NO_BILL_AUDIT ON ARBORGVT_BILLING.GVT_NO_BILL_AUDIT (ACCOUNT_NO);
   
   select * from ARBORGVT_BILLING.gvt_no_bill_audit 
   
   select * from gvt_no_bill_audit 
   
   select * from gvt_no_bill_audit
   
   select * from cmf_balance where bill_ref_no = 161213913
   
   select account_category from cmf where account_no = 3201733
   
   select * from account_category_values 