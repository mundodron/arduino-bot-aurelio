select * from all_tables where table_name like '%PROFORMA%'

select * from GVT_TEMP_CONTAS_PROFORMA

select * from GVT_PROFORMA_HIST_CONTAS order by 4 desc

  select * from gvt_blacklist_faturamento
  
  select trim(GLOBAL_NAME) from GLOBAL_NAME;
  
  Select bill_period
    from bill_cycle where bill_period like 'M%' and prep_date = (Select max(prep_date) from bill_cycle where bill_period like 'M%' and prep_date <= sysdate);
    
  