
select * from customer_id_acct_map where external_id = '899997251142' 

select * from cmf_balance where bill_ref_no = 214209347

select * from adj where account_no = '7382339'

select account_category from cmf where account_no = 7382339

select * from adj where bill_ref_no = 214209347

select bill_ref_no, ORIG_BILL_REF_NO, TRANS_AMOUNT, ANNOTATION from bmf where account_no = 7382339 and bill_ref_no = 214209347 and BMF_TRANS_TYPE = -13
union all
select bill_ref_no, ORIG_BILL_REF_NO, total_amt, ANNOTATION from adj where bill_ref_no = 214209347


select * from bill_invoice where account_no = 9513022