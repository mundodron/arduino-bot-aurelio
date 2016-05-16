select * from customer_id_acct_map where external_id = '999982946781'

select * from bmf where account_no = 4470980

select * from bmf where account_no = 1202880 -- Divergência

select * from bmf where TRACKING_ID = 65541058

select * from cmf_balance where account_no = 65541058

select * from bmf_distribution where bmf_TRACKING_ID = 64810717

select * from bmf_distribution where bmf_TRACKING_ID = 65541058

select * from bmf where TRACKING_ID = 65541058

select bill_period from cmf where account_no = 1202880



Update bmf set TRANS_AMOUNT = 100, GL_AMOUNT = 100, EXTERNAL_AMOUNT = 100 where TRACKING_ID = 65541058;

Update bmf_distribution set AMOUNT = -100, GL_AMOUNT = -100 where TRACKING_ID = 65541058;

Update cmf_balance set TOTAL_PAID = -100, BALANCE_DUE = -100;

commit

select * from cmf_balance where account_no = 4470980 and bill_ref_no = 0

BMF_DELETE(65541058,4);

commit;

