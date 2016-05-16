
select * from customer_id_equip_map  where subscr_no in (19478366,19478367);

select * from customer_id_equip_map where 


update customer_id_equip_map_view set is_current=0
where subscr_no in (19478366,19478367)
and inactive_date is not null;


select file_name from bill_invoice where bill_ref_no in (231921312,231918134,238520713,245207528,245207906,245209914,251989310,251989704,251990711,251991712,251991928,251983748,263844305,263844902,263845102,263845305,263845705)