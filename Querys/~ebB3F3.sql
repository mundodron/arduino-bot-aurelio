select * from BANK_SEQS --interno
where bank_id = 001


update BANK_SEQS set SEQ_NUMB = SEQ_NUMB + 1 where bank_id = 001;

select * from customer_id_acct_map where external_id = '999983331257'

select * from bmf where account_no = 4417862 

select bill_ref_no, chg_date, CHG_WHO  from cmf_balance where account_no = 4417862 and bill_ref_no in (0107071909,0104717703)
