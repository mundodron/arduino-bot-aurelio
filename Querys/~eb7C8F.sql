

select * from cmf_balance where bill_ref_no = 153354784

select * from adj where account_no = 3430433 and  orig_bill_ref_no = 153354784  and no_bill = 0

select * from bmf where account_no = 3430433 and  orig_bill_ref_no = 153354784  and no_bill = 0

select * from bill_invoice_detail where  bill_ref_no = 153354784 and type_code = 4

select * from bmf_trans_descr where bmf_trans_type = -289

select * from descriptions where description_code = 23558

select * from bill_invoice where bill_ref_no in(196219568, 194191992)

select * from adj where tracking_id in (74121695,73390531)

