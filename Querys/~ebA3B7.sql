
select * from PL0720_DATA where bill_ref_no = 153834509

select * from cmf_balance where bill_ref_no = 153834509

select type_code, sum(amount) from bill_invoice_detail where bill_ref_no = 153834509
group by type_code
