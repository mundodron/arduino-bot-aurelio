select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID = 'SDR-3012WZUQB-16031'

select * from GVT_FEBRABAN_PONTA_B_ARBOR where cmf_ext_ID in ('999985081749','999985081748','999983129627','999985081815','999983680795','999985081811','999985081812','999985081813')
order by EMF_EXT_ID

select * from all_tables where table_name like '%FEBRABAN%' 

select account_no from GVT_FEBRABAN_ACCOUNTS where external_id in  ('999985081749','999985081748','999983129627','999985081815','999983680795','999985081811','999985081812','999985081813')

select * from bill_invoice_detail  

select * from GVT_FEBRABAN_BILL_INVOICE where account_no in (select account_no from GVT_FEBRABAN_ACCOUNTS where external_id in  ('999985081749','999985081748','999983129627','999985081815','999983680795','999985081811','999985081812','999985081813'))
order by FILE_NAME desc