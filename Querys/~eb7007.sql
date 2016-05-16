delete bill_invoice_detail where BILL_REF_RESETS = 9

select * from bill_invoice_detail where bill_ref_no = 318768056
and OPEN_ITEM_ID between 4 and 89


update bill_invoice_detail set provider_id = -1
 where 1=1 --bill_ref_no in (Select bill_ref_no from vrc_cdr_cob_zerado_2)
   and OPEN_ITEM_ID between 4 and 89
   --and TYPE_CODE in  7
   and bill_ref_no in (314669572)
   and AMOUNT = 0


select *
  from bill_invoice_detail
 where 1=1 --bill_ref_no in (Select bill_ref_no from vrc_cdr_cob_zerado_2)
   and OPEN_ITEM_ID between 4 and 89
   --and TYPE_CODE = 7
   and bill_ref_no in (79008097,80521698,82212526,83914184,85573761,87260183,89926952,91893938,93981527,96319916,98307313,100473895,102734284,105058483,107497500,110179129,112660775,115161393,117746242,120420284,123208940,126186780,128778805,131615858,134448665,137260300,140096906,143027440,146042946,148845879,152017637,155095552,158268728,161151292,164376377,167519891,170717606,174061859,177701350,181302633,185016152,189151427,193162063,197501365,202402267,208567881,215253150,221835860,228472854,235153683,241649982,248421695,255353397,262180309,269073608,276058828,283246311,290503359,297468018,304511471,311634270,318768056,217683063,224195612,230912344,237557669,244169818,250878158,257658305,264858232,271858955,278994080,285955654,293636777,300686106,307768141,314882248,322064096,266844987,273869154,281159655,288273371,295358880,302242611,309316336,316519668,307646151,314669572,321862788)
   and AMOUNT = 0
   
   AND bill_ref_no in (select bill_ref_no from bill_invoice where IMAGE_DONE = 1) order by 1 desc
   
   and bill_ref_no = 301690535
   ---and AMOUNT = 0

select * from cdr_billed where bill_ref_no = 317284312 and TYPE_ID_USG between 360 and 370

update cdr_billed set BILL_REF_RESETS = 0 where bill_ref_no = 317284312 and TYPE_ID_USG between 360 and 370

select * from cdr_billed where bill_ref_no = 317284312 and TYPE_ID_USG between 360 and 370

select bill_fmt_opt from cmf  where account_no = 10876563

update cmf set bill_fmt_opt = 2 where account_no = 10876563

select * from bill_invoice where bill_ref_no = 317284312

   
  301690535
  
  select * from sin_seq_no where bill_ref_no = 318768056
  
  select * from sin_seq_no where bill_ref_no in (316519668,314882248,314669572)
  
                                                                                    
  select * from SERVICE_PROVIDERS_REF
  
  
   SELECT DISTINCT BID.provider_id, decode(BID.open_item_id,0,1,1,1,2,1,3,1,90,90,91,90,92,90,93,93,94,93,95,93,bid.open_item_id)
      FROM BILL_INVOICE_DETAIL BID, SERVICE_PROVIDERS_REF SP
      WHERE BID.bill_ref_no     = 317284312
        AND BID.bill_ref_resets = 0
        AND ( BID.type_code IN (2,3,4,7))
        AND BID.provider_id = SP.provider_id
      ORDER BY decode(BID.open_item_id,0,1,1,1,2,1,3,1,90,90,91,90,92,90,93,93,94,93,95,93,bid.open_item_id);
      
      
      select * from bill_invoice where account_no in (10716931, 9441705, 10148902, 3557398) and prep_status = 1 and format_status = -1
      
      -- 318768056
      -- 3557398
      
      select data.*
        from cdr_billed bid,
             cdr_data data
       where bid.account_no = data.ACCOUNT_NO
         and bid.bill_ref_no = 318768056
         and BID.MSG_ID = DATA.MSG_ID
         and DATA.ACCOUNT_NO = BID.ACCOUNT_NO
         and DATA.MSG_ID2 = BID.MSG_ID2
         and DATA.MSG_ID_SERV = BID.MSG_ID_SERV
      
            select * from cdr_billed where account_no = ACCOUNT_NO and bill_ref_no = 318768056
            
            
            Select * from g0010388sql.vrc_cdr_cob_zerado_1
            
            select count(1) from fatweb_RETAIL 
            
            
            
            insert into fatweb_RETAIL values (select bill_ref_no from G0023421SQL.BILL_INVOICE_DETAIL_BK);
            
            
            INSERT INTO fatweb_RETAIL (bill_ref_no) SELECT bill_ref_no FROM BILL_INVOICE_DETAIL_BK; 

            insert into fatweb_RETAIL (bill_ref_no) values (select bill_ref_no from BILL_INVOICE_DETAIL_BK);
            
            
            select * from customer            