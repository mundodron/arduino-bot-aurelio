update GVT_FREEDOM a set a.account_no = (select b.account_no from customer_id_acct_map b where A.CONTA_COBRANCA = B.EXTERNAL_ID)


select count(*) from GVT_FREEDOM where account_no is not null