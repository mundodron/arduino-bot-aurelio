           SELECT COUNT(*)
             FROM GVT_DETALHAMENTO_CICLO
            WHERE DATA_PROCESSO >= TO_DATE ('20160431 00:12:11','YYYYMMDDHH24:MI:SS') 
              AND DATA_PROCESSO >= TO_DATE ('201604 03:12:11','YYYYMMDDHH24:MI:SS') 
              AND GVT_DATE = '052016'
              AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
              AND ANOTATION = 'CONTA COM ERRO NO EIF'
              AND ACCOUNT_CATEGORY IN (9,10,11);

select * from cmf_balance_detail where bill_ref_no = 344361828

select * from sin_seq_no where bill_ref_no = 344361828


select * from ARBOR.LOCAL_ADDRESS

select * from  MKT_CODE_VALUES 
where SHORT_DISPLAY = 'SP'
and SHORT_DISPLAY like '%a%'
