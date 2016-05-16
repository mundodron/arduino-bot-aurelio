select * 
  from gvt_product_velocity vl,
       bill_invoice_detail det
 where VL.TRACKING_ID = DET.TRACKING_ID
   and VL.TRACKING_ID_SERV = DET.TRACKING_ID_SERV
   and VL.TRACKING_ID = 85484239
   and DET.TRACKING_ID_SERV = 4
   and bill_ref_no = 228652902