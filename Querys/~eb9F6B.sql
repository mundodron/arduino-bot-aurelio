select * from gvt_fbb_bill_invoice where bill_ref_no in (145310104,145310108)

select * from customer_id_acct_map where account_no in (select account_no from gvt_fbb_bill_invoice where bill_ref_no in (145310104,145310108))

select * from all_tables where table_name like '%FEBRABAN%'

select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID = 'PAA-3019MSLYN-9699-3019MSLYP' 

