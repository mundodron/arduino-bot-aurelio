select external_id, 
       bill_ref_no,
       DT_STATUS,
       cd_gerado
from ARBORGVT_BILLING.GVT_LOG_DET_FATURAMENTO_CD where external_id in (999979724383,999979720057) and bill_ref_no in (314629773,307537312,300468315,280222882,314624115,307533426,300465237,293431513)
and CD_gerado = 'S'
order by 1


select * from GVT_DURATION_USG_VARIABLE where set_units_2 = 'P' 