select * from bill_invoice where bill_ref_no = 258219172

select * from gvt_product_velocity where tracking_id in (
select tracking_id from gvt_product_velocity group by tracking_id having count(1) > 1)