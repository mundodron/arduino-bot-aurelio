-- --143494431,142815730,--142815531,--141426118,141430134

select account_no from cmf_balance where bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

select * from GVT_HISTORY_EIF where account_no in (3610811,2826277,4318950,4350086,4779188) and bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

select * from PL0720_DATA where bill_ref_no in (143494431,142815730,142815531,141426118,141430134)

select * from GVT_HISTORY_EIF order by bill_mes desc