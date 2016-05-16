select * from bill_invoice where account_no = 10311018


update bill_invoice_detail set provider_id = -1
 where OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE in  7
   and bill_ref_no = 317292329
   and AMOUNT = 0;
   
   
   