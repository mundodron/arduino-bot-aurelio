declare v_faturas as number;

v_faturas = &1;

select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, c.CREATION_DATE, b.file_name, b.image_done, B.PREP_STATUS, C.NO_BYTES 
  from gvt_febraban_accounts a,
       gvt_febraban_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  bill_ref_no in (v_faturas)
union all
select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, c.CREATION_DATE, b.file_name, b.image_done, B.PREP_STATUS, C.NO_BYTES
  from gvt_febraban_accounts a,
       gvt_fbb_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  bill_ref_no in (v_faturas);