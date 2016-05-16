select * from RETORNO_CORROMPIDAS_ABNC where bill_ref_no = 141430134

select * from cmf_balance where bill_ref_no = 158276360

select * from bmf where account_no = 3566249 and orig_bill_ref_no = 158276360

select * from cmf_balance where bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

select * from GVT_HISTORY_EIF where account_no in (3610811, 2826277) and bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

-- 141430134
-- 143494431

select * from CMF_BALANCE_DETAIL where bill_ref_no = 143494431 -- 141430134

select * from CMF_BALANCE_DETAIL where bill_ref_no = 141430134

select * from BILL_INVOICE where bill_ref_no in (143494431,141430134,153343728)

select account_category from cmf where account_no = 3610811


select * from gvt_summary_zero_allowed where (component_id,element_id) in ((29649,10203),(29897,10327));
