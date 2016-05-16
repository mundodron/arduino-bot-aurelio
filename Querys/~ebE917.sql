select /*+ leading(gvtcd, conta) */  
  distinct 
  nvl( cli.PARENT_ID, '0') parent_id, 
  conta.EXTERNAL_ID  conta, 
  cli.bill_lname nome_cliente, 
  conta.ACCOUNT_NO, 
  bi.bill_ref_no, 
  trim( substr( fv.display_value, length(fv.display_value) -2) ) UF, 
  bi.payment_due_date vencimento, 
  bi.Prep_Date, 
  cli.bill_period, 
  cli.account_category
from 
  ARBOR.cmf cli, 
  ARBOR.customer_id_acct_map conta, 
  ARBOR.FRANCHISE_CODE_VALUES fv, 
  ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD gvtcd, 
  ARBOR.bill_invoice bi 
where conta.ACCOUNT_NO = cli.ACCOUNT_NO 
and bi.ACCOUNT_NO = cli.ACCOUNT_NO 
and cli.bill_period = bi.bill_period 
and cli.cust_franchise_tax_code  = fv.FRANCHISE_CODE 
and fv.LANGUAGE_CODE = 2 
and conta.external_id_type = 1 
and conta.external_id = trim(gvtcd.EXTERNAL_ID) 
AND BI.PREP_STATUS = 1
and bi.prep_error_code is null
AND cli.ACCOUNT_CATEGORY IN (9, 12, 13, 14, 15, 21, 22)

and  cli.bill_period = ?
and trunc(bi.Prep_Date) >= ?



select * from ARBORGVT_BILLING.GVT_AVULSO_FATURACD