update gvt_rajadas_bill a set a.account_no = (select account_no from customer_id_acct_map where external_id = A.external_id)


