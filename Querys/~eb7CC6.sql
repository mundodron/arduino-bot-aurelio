SELECT b.FULL_SIN_SEQ, b.AMOUNT, b.HASH_CODE FROM gvt_bill_invoice_nfst b, E9502243SQL.telefonica_hashcode t
WHERE t.FULL_SIN_SEQ IN ('480-MS')
AND t.bill_ref_no = b.bill_ref_no
AND t.full_sin_seq = b.full_sin_seq
AND t.prep_date >= '20-OCT-2011';
