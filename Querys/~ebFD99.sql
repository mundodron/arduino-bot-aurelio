select ci.EXTERNAL_ID,
       c.ACCOUNT_NO,
       c.BILL_REF_NO,
       c.TOTAL_DUE 
  from cmf cm,
       cmf_balance c,
       customer_id_acct_map ci 
 where c.CLOSED_DATE is null
   and c.bill_ref_no <> 0
   and c.ACCOUNT_NO = ci.ACCOUNT_NO
   and c.ACCOUNT_NO = cm.ACCOUNT_NO
   and ci.EXTERNAL_ID_TYPE = 1
   and cm.ACCOUNT_CATEGORY = 10
   and cm.ACCOUNT_NO = cm.HIERARCHY_ID
order by c.BILL_REF_NO desc