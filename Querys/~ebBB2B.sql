select * from GVT_DACC_GERENCIA_MET_PGTO order by DT_CADASTRO desc

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999990000515'

select * from gvt_bill_invoice_nfst where bill_ref_no = 317313303

select * from sin_seq_no where bill_ref_no = 317313303


select * from GVT_DACC_GERENCIA_MET_PGTO where external_id in ('999990000515','999988260505','899996246745')


select * from payment_profile where account_no in (10287165,2816752)


select M.EXTERNAL_ID, DECODE(PY.PAY_METHOD, 1, 'FATURA', 2, 'CARTAO', 3, 'DEBITO', PY.PAY_METHOD) "PAY_METHOD"
  from payment_profile py,
       customer_id_acct_map m
 where Py.ACCOUNT_NO = M.ACCOUNT_NO
   and M.EXTERNAL_ID in ('999990000515','999988260505','899996246745')
   
   
   4cf59cd1a71762e0c34f0d82d48ff43c
   4cf59cd1a71762e0c34f0d82d48ff43c