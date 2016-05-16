select * from gvt_product_velocity where tracking_id in (
select tracking_id from gvt_product_velocity group by tracking_id having count(1) > 1)

select prep_date, prep_status, format_status from bill_invoice where bill_ref_no=258219172;
