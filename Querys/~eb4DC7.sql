
select * from cmf_balance where bill_ref_no = 145414262

select * from bmf where account_no = 7662073 and orig_bill_ref_no = 145414262

select * from bmf

--delete from cmf_balance where bill_ref_no = 145414262

update cmf_balance set CLOSED_DATE = null,  where bill_ref_no = 145414262

select * from bill_invoice where account_no = 7662073 and bill_ref_no = 145414262