select * from GVT_FEBRABAN_ACCOUNTS where external_id in(999992022033,999992012382,999991692714);

select * from cmf_balance where bill_ref_no in(72999940,74735079)

delete from lbx_error where bill_ref_no in(72999940,74735079);

commit;


select * from 