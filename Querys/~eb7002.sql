select * from lbx_error where bill_ref_no in (101321117,101320562,101321158,101321117,101320562,101321158,101792756,101793153)

delete from lbx_error where bill_ref_no in (101321117,101320562,101321158,101321117,101320562,101321158,101792756,101793153);

commit;



update payment_trans 
set trans_status = 6 
where tracking_id = 8916812;


select * from payment_trans where tracking_id = 8916812;