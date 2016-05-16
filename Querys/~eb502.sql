select * from customer_id_acct_map where account_no = 9423509

select * from bill_invoice where account_no = 9423509 and bill_ref_no = 319674505

select * from
customer_id_acct_map where external_id = '999979671438';


select * from open_item_id_values where open_item_id = '4';

select * from GVT_SINSEQNO_SERIES where MKT_CODE = 23

Insert into GVT_SINSEQNO_SERIES
(OPEN_ITEM_ID,
MKT_CODE, SERIE)
Values
(4, 23, 'M');
COMMIT;