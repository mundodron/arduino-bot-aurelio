select account_no from cmf_balance where bill_ref_no in (175097702,175097502,180146123,176428122)

select * from bill_invoice where account_no = 3869396 and bill_ref_no in (180146123,176428122)

gvt_sempre_local_full

select * from account_category_values 

select account_no,account_category from cmf where account_no in (select account_no from cmf_balance where bill_ref_no in (175097702,175097502,180146123,176428122))