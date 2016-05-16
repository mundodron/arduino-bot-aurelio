select * from bill_invoice_detail 
where bill_ref_no=180146123 order by bill_invoice_row

select * from cmf_balance where bill_ref_no=180146123

select * from customer_id_acct_map where account_no = 3869396

select * from service where parent_account_no = 3869396

select * from cmf where account_no = 3869396
