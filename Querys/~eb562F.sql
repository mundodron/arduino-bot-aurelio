select * from bill_invoice where account_no in (select account_no from customer_id_acct_map where external_id in ('899998696204'))
order by 2 desc