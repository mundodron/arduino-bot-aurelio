
select * from gvt_bankslip where bill_ref_no in (163334545, 162204541, 162033129)


select * from gvt_bankslip where full_sin_seq is null 
and status <> '5'

438971-PR

438971-PR

 SELECT * --full_sin_seq,statement_date 
   FROM sin_seq_no
  WHERE bill_ref_no  in (163334545, 162204541, 162033129)
    AND bill_ref_resets = 0 
    AND open_item_id = 0 