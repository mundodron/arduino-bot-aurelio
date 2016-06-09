
           SELECT account_no, bill_ref_no, file_name FROM GVT_DETALHAMENTO_CICLO
           WHERE DATA_PROCESSO >= TO_DATE ('2016060100:12:11','YYYYMMDDHH24:MI:SS') 
                 AND GVT_DATE = '062016'
                 AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
                 AND ANOTATION = 'CONTA COM ERRO NO EIF'
                 AND ACCOUNT_CATEGORY IN (9,10,11);
                 
           
           SELECT * FROM GVT_DETALHAMENTO_CICLO
           WHERE DATA_PROCESSO >= TO_DATE ('2016060100:12:11','YYYYMMDDHH24:MI:SS') 
                 AND GVT_DATE = '062016'
                 AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
                 AND ANOTATION = 'CONTA COM ERRO NO EIF'
                 AND ACCOUNT_CATEGORY IN (9,10,11);
                 
                grant all on fatweb_dist to public; 
                 
                create table fatweb_dist as ( 
                select distinct(bill_ref_no) from fatweb_retail ) 
                
                insert into fatweb_retail (bill_ref_no) (select bill_ref_no from fatweb_dist)
                
                select count(1) from fatweb_retail