select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, b.file_name, b.image_done,b.PREP_ERROR_CODE,c.FORMAT_STATUS, C.NO_BYTES 
  from gvt_febraban_accounts a,
       gvt_febraban_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  bill_ref_no in (168540756,171736809,175216337);
  
  
union all
select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, b.file_name, b.image_done, C.NO_BYTES
  from gvt_febraban_accounts a,
       gvt_fbb_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  bill_ref_no in (168540753,171736806,175216334)