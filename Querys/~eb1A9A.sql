select * from bill_invoice where bill_ref_no = 258219172

select * from cmf where account_no = 371457

select * from gvt_product_velocity where end_DT is not null order by 5 desc

select * 
  from gvt_product_velocity vl,
       bill_invoice_detail det
 where VL.TRACKING_ID = DET.TRACKING_ID
   and VL.TRACKING_ID_SERV = DET.TRACKING_ID_SERV
   and VL.TRACKING_ID = 85484239

select * from bill_invoice_detail det

 where bill_ref_no = 258219172
 
 
select * from bill_invoice_detail where tracking_id = 85484239


select prep_date, prep_status, format_status from bill_invoice where bill_ref_no=258219172;


select * from gvt_product_velocity where tracking_id in (
select tracking_id from gvt_product_velocity group by tracking_id having count(1) > 1)


select * from account_category_values where language_code = 2

delete gvt_product_velocity where tracking_id=18293028 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=15035320 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=20678751 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=15549537 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=18293027 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=20669008 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=15035443 and tracking_id_serv=3;
delete gvt_product_velocity where tracking_id=15549543 and tracking_id_serv=3;


select * from product where tracking_id = 85484239

select * from cmf_balance where account_no = 9452470 order by 3 desc


select account_no, prep_date, prep_status, format_status, prep_status from bill_invoice where bill_ref_no=258219172;

select account_no, prep_date, prep_status, format_status, prep_status from bill_invoice where bill_ref_no=258825708;