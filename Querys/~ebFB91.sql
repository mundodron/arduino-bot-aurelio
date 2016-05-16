select * from service where parent_account_no = 3869396

select * from bill_invoice_detail where bill_ref_no = 175097702 

select * from bill_invoice where bill_ref_no = 176428122 and account_no = 3869396

select * from cmf_balance where bill_ref_no = 175097702

select * from customer_id_acct_map where account_no = 3869396

select DISTINCT SUBSCR_NO from bill_invoice_detail where bill_ref_no=180146123 and type_code not in (5,6,1,4);

select subscr_no, service_inactive_dt from service where subscr_no in (9353463,9353447,9353455,9353456,9628014,9353448,9353449,9353457,9353476,9353446,10870127,10870218);

select * from GVT_PRODUCT_VELOCITY where TRACKING_ID in (37255986,37255985)