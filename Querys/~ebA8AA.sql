drop table GVT_FEBRABAN_PONTA_B_ARBOR_BK

create table GVT_FEBRABAN_PONTA_B_ARBOR_BK as select * from ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR

select * from ARBORGVT_PAYMENTS.GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID = 'CTA-3015SO1GQ-9699-3015SO1GZ'

-- select count(*) from GVT_FEBRABAN_PONTA_B_ARBOR_BK

select * from cmf_balance where  bill_ref_no = 145091211;

select * from cmf_balance where bill_ref_no in (145091211)