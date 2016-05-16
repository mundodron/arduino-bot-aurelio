insert into GUSUARIOSQL.CDC_PROCESSAR_BACKLOG
select ACCOUNT_NO, BILL_REF_NO, PAYMENT_DUE_DATE, 1 processo, ( select ACCOUNT_CATEGORY from cmf c where c.account_no = b.account_no ) account_category 
from bill_invoice b
where bill_ref_no in ();