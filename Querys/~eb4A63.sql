select * from cmf_balance where account_no in (select account_no from customer_id_acct_map where external_id = '999984095776')

select * from cmf_balance where bill_ref_no = 0134447133