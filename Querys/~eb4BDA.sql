select * from cmf_balance where bill_ref_no = 156525720

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor_bk)

select * from gvt_febraban_ponta_b_arbor_bk where EMF_EXT_ID not in (select EMF_EXT_ID from gvt_febraban_ponta_b_arbor)

select * from gvt_febraban_ponta_b_arbor where EMF_EXT_ID = 'SDR-3012WZUQB'