select * from GVT_DET_FATURAMENTO_CD where external_id in ('999979635210');

select bill_lname, prep_date, CD_gerado, dt_inclusao from ARBORGVT_BILLING.GVT_LOG_DET_FATURAMENTO_CD where external_id = '999979635210' and cd_gerado in ('S','N')