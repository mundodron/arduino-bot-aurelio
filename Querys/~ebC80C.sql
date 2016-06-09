SELECT account_no, bill_ref_no, file_name FROM GVT_DETALHAMENTO_CICLO
         WHERE DATA_PROCESSO >= TO_DATE ('2016060100:12:11','YYYYMMDDHH24:MI:SS') 
                 AND GVT_DATE = '062016'
                 AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
                 AND ANOTATION = 'CONTA COM ERRO NO EIF'
                 AND ACCOUNT_CATEGORY IN (9,10,11);
                 
select format_status, count(1)
  from bill_invoice where bill_ref_no in (                 
SELECT bill_ref_no FROM GVT_DETALHAMENTO_CICLO
         WHERE DATA_PROCESSO >= TO_DATE ('2016060100:12:11','YYYYMMDDHH24:MI:SS') 
                 AND GVT_DATE = '062016'
                 AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
                 AND ANOTATION = 'CONTA COM ERRO NO EIF'
                 AND ACCOUNT_CATEGORY IN (9,10,11))
 group by format_status             
 
 select 1373 + 1312 from dual