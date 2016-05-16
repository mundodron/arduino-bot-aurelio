select * from grc_servicos_prestados

select to_date(data_envio_parc), count(1) from grc_erros_bmp where data_envio_parc > sysdate -40 group by to_date(data_envio_parc);

select * from COBILLING.GVT_CONTROLE_CAD_CLIENTE

select bill_period,  from bill_invoice where bill_ref_no = 200307306


select * from GVT_VAL_LOG_EIF

truncate table GVT_VAL_LOG_EIF


select * from bill_invoice where bill_ref_no = 212026038

select * from gvt_val_log_eif



update gvt_val_log_eif set eif = 'SME' where eif in ('eif681','eif682','eif683','eif684','eif685','eif686','eif687','eif688','eif689','eif690','eif701','eif702','eif703','eif704','eif705','eif706','eif707','eif708','eif709','eif710')