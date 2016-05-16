select * 
  from G0009075SQL.bip_production
group by bill_period

select count(1) Total_PROF, bill_period CICLO_PROF
  from G0009075SQL.bip_proforma
group by bill_period

ARBORGVT_BILLING.proc_valida_status_conta