select count(*) from G0009075SQL.bip_production where UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P27')) 

select count(*) from  G0009075SQL.bip_proforma where UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P27')) 