select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, c.CREATION_DATE, b.file_name, b.image_done, B.PREP_STATUS, C.NO_BYTES 
  from gvt_febraban_accounts a,
       gvt_febraban_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  a.external_id in (777777775143,999990240501,999989775347,999989775183,999989775115,999992095491,999991910257,999991910319,999991910251,999991850449,999990240442,999990240499,999991850437,999990240500)
  order by 2
  
  
union all

select a.account_no, a.external_id, b.bill_ref_no, a.version_feed, c.CREATION_DATE, b.file_name, b.image_done, B.PREP_STATUS, C.NO_BYTES
  from gvt_febraban_accounts a,
       gvt_fbb_bill_invoice b,
       gvt_febraban_bill_files c
where  a.account_no = b.account_no
  and  b.file_name = c.filename
  and  a.external_id in (777777775143,999990240501,999989775347,999989775183,999989775115,999992095491,999991910257,999991910319,999991910251,999991850449,999990240442,999990240499,999991850437,999990240500)
  
  
  drop table G0023421SQL.GVT_EIF_CICLO_PROFORMA
  
  select * from ARQUIVOS_COBILLING order by sequencial desc
  
  select * from COBILLING.GVT_CONTROLE_CAD_CLIENTE
  
  select * from CONTROLE_EXECUCAO_COBILLING where rotina =