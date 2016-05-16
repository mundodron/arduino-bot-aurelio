select * from bill_invoice --_detail
where bill_ref_no= 173903103
and type_code in (2,3,7)
and open_item_id not in (0,1,2,3,90,91,92) 


select &