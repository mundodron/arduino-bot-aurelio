select * from gvt_bankslip where bill_ref_no in (163334545, 162204541, 162033129)


select * from gvt_bankslip where full_sin_seq is null 
and status <> '5'


 SELECT *
   FROM sin_seq_no
  WHERE bill_ref_no  in (163334545, 162204541, 162033129)
    AND bill_ref_resets = 0
    AND open_item_id = 0 
    
 select DECODE(90,1,0,2,0,3,0,91,90,92,90,) from dual
 
 select sysdate from dual
 
 SELECT supplier_name,
DECODE(supplier_id, 10000, 'IBM',
                    10001, 'Microsoft',
                    10002, 'Hewlett Packard',
                    'Gateway') result
FROM suppliers;

