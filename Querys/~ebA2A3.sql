update chamados A set A.account_no = (select account_no from cmf_balance where bill_ref_no = a.fatura)

update chamados A set A.external_id = (select external_id from customer_id_acct_map where account_no = a.account_no and external_id_type = 1)

select * from chamados


select * from gvt_bankslip where bill_ref_no = 131255410