select * from cmf_balance where bill_ref_no = 153834509 --153834509

select type_code, sum(1), sum(amount) from bill_invoice_detail where bill_ref_no = 153834509 and type_code in (1,2,3,4,5,6,7) group by type_code order by 3

