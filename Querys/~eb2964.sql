insert into fatweb_RETAIL (bill_ref_no) values (select bill_ref_no from G0023421SQL.BILL_INVOICE_DETAIL_BK);

commit;


select * from BILL_INVOICE_DETAIL_BK where rownum < 30


select count(1), provider_id from bill_invoice_detail where bill_ref_no in (select bill_ref_no from G0023421SQL.BILL_INVOICE_DETAIL_BK) and provider_id = -1 group by provider_id