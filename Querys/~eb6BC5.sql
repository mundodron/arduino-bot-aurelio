select * from bill_invoice where bill_ref_no = 150706849

select account_no from gvt_febraban_accounts where external_id in (999999234617,999983149056,999980501190)

select * from GVT_FEBRABAN_BILL_FILES where filename in (
select file_name from gvt_FBB_bill_invoice where account_no in (select account_no from gvt_febraban_accounts where external_id in (999999234617,999983149056,999980501190))
and bill_ref_no in (153848153,153846518,153846306)
)

select * from all_tables where table_name like '%FEBRABAN%' 