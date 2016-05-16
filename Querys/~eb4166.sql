select * from bill_invoice_detail

select * from product

select * from all_tables where table_name like '%INIB%' 


select * from GVT_INIBE_RC_LOG where chg_date > sysdate - 5 

select * 
  from product p,
       descriptions d
 where P.ELEMENT_ID = D.DESCRIPTION_CODE
   and D.DESCRIPTION_TEXT like '%DTH%'

select UNITS from product_rate_key a where A.TRACKING_ID = 71899558

select * from gvt_inibe_rc_log where account_no = 8738289

select * from bill_invoice where PREP_DATE > sysdate - 3


select *
  from bill_invoice b,
       bill_invoice_detail d
 where b.prep_Date > sysdate - 30
   and b.prep_status = 1
   and B.BILL_PERIOD = 'M28'
   and D.BILL_REF_NO = B.BILL_REF_NO
   and D.BILL_REF_RESETS = B.BILL_REF_RESETS


select l.*
  from bill_invoice b,
       bill_invoice_detail d,
       gvt_inibe_rc_log l
 where b.prep_Date > sysdate - 30
   and b.prep_status = 1
   and B.BILL_PERIOD = 'M28'
   and D.BILL_REF_NO = B.BILL_REF_NO
   and D.BILL_REF_RESETS = B.BILL_REF_RESETS
   and D.TRACKING_ID = l.tracking_id
   and D.TRACKING_ID_SERV = l.TRACKING_ID_SERV
   and B.ACCOUNT_NO = l.account_no
   and B.ACCOUNT_NO = 1927576
   and l.CHG_DATE > sysdate - 30 


select * from bipM28