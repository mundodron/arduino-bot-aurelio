select * 
from GVT_FEBRABAN_ACCOUNTS 
where external_id in  ('999985081749','999985081748','999983129627','999985081815','999983680795','999985081811','999985081812','999985081813')

select account_no, max(bill_ref_no) fatura
from bill_invoice
where account_no in (
select account_no 
from GVT_FEBRABAN_ACCOUNTS 
where external_id in  ('999985081749','999985081748','999983129627','999985081815','999983680795','999985081811','999985081812','999985081813')
)
and prep_date > trunc(sysdate) -90
and prep_status = 1
and prep_error_code is null
group by account_no


----------------------------------------------------------------------------------------------------------------------

select file_name from GVT_FEBRABAN_BILL_INVOICE
where BILL_REF_NO in (116652523,116651743,116649941,116653143,116651518,116650149,116650927,116650737)

-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-000.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-002.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-009.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-014.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-018.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-026.txt
-rw-r--r-- 1 arbor arboradm 1053 Jul  6 15:10 TD0303070614262800001AF-0000-032.txt
-rw-r--r-- 1 arbor arboradm 3159 Jul  6 15:10 TD0303070614262800001AF-0000-006.txt

select * from GVT_FEBRABAN_BILL_INVOICE where file_name like '%TD0303070614262800001AF-0000-%' order by 1 asc


select * from all_tables where table_name like '%DETALHADA%' 

select * from GVT_PL_CONTA_DETALHADA 