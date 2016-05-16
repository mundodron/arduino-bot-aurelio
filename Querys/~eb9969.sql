select count(1) from GVT_FEBRABAN_PONTA_B_ARBOR_BK

select count(1) from GVT_FEBRABAN_PONTA_B_ARBOR

select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)

select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR_bk)