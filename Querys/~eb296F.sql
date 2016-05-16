select external_id, version_feed, active_date from gvt_febraban_accounts where inactive_date is null
and external_id in (select external_id from customer_id_acct_map where INACTIVE_DATE is null and external_id_type = 1)

select * from bill_invoice order by bill_ref_no desc

select * from gvt_conta_internet where data_processamento > sysdate -15 and bill_ref_no is not null order by 3 desc