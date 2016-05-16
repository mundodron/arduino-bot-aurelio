select * from customer_id_acct_map where external_id = '999993550274'

select * from all_tables where table_name like '%DACC%'

select * from payment_profile where account_no = 1409494
union all
select * from payment_profile where pay_method = 3

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999993550274'

update payment_profile set PAY_METHOD = 3 where account_no = 1409494 and PROFILE_ID = 1409494500

commit;

