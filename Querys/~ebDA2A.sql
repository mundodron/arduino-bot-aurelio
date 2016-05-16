

select * from customer_id_acct_map where external_id = '999992228683'

select * from bmf where account_no = 1768591

select * from cmf_balance where account_no = 1768591

select * from payment_trans where account_no = 1768591

select *
   from payment_trans
  where bill_ref_no in (106392114,107341113,106388825);
  