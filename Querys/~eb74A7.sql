select * from customer_id_acct_map where account_no = 2330144


select * from GVT_DACC_GERENCIA_MET_PGTO where PAY_METHOD not in (3,1)

select distinct(account_no) from payment_profile where PAY_METHOD = 2 and account_no in (select account_no from customer_id_acct_map where inactive_date is null and external_id_type = 1)

select * from bmf where account_no = 2330144

select * from cmf_balance where account_no = 2330144

select * from GVT_CONTROLE_CAD_CLIENTE

