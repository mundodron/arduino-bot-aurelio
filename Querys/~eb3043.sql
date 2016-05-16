select * from payment_trans where bill_ref_no = 101323382


update payment_trans 
set trans_status = 6 
where tracking_id = 8916812;


select * from payment_trans where tracking_id = 8916812;