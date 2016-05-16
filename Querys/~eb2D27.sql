select bill.* 
  from bill_invoice BILL,
       BIPP15_TESTE BIP
 where BILL.ACCOUNT_NO = BIP.ACCOUNT_NO
 
 
 select * from bill_invoice where FORMAT_ERROR_CODE is not null
 
 
 
--Retorno d Valid - PBCAT
select distinct(bill_ref_no), problema 
from retorno_corrompidas_abnc
where bill_ref_no in('121332911','126892194',
                     '130147326','129695902');