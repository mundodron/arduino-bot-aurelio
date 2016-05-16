select * from customer_id_acct_map where account_no = 1600840

select * from bmf where bill_ref_no = 103158122 and account_no = 1600840

---
select * from GVT_FEBRABAN_ACCOUNTS
where account_no in
(select account_no ---b.file_name, b.prep_date, b.*
from bill_invoice b
where bill_ref_no in ('103158122')
and external_id = '999992905386'
and prep_date > sysdate-45)

select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_ACCOUNTS

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (103227730,103204936)

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (103158122,103157314,103155733,103227730,103204936,103156113,103154913,103156333,103157316,103168310,103156332)

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (102366708)

