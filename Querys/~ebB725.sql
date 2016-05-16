select * from all_tables where owner = 'G0023421SQL'

select * from CITIBANK_LBX

select * from cmf_balance where bill_ref_no in (select bill_ref_no from CITIBANK_LBX)