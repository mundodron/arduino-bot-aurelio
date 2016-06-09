
           SELECT *
             FROM GVT_DETALHAMENTO_CICLO
            WHERE DATA_PROCESSO >= TO_DATE ('2016060100:00:00','YYYYMMDDHH24:MI:SS') 
              AND DATA_PROCESSO <= TO_DATE ('2016073123:59:59','YYYYMMDDHH24:MI:SS') 
              AND GVT_DATE = '062016'
              AND UPPER(BILL_PERIOD) IN (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE UPPER(PROCESSAMENTO) = UPPER('p27'))
              AND ANOTATION = 'CONTA COM ERRO NO EIF'
              AND ACCOUNT_CATEGORY IN (9,10,11);
              
              
                    create table fatweb_dist as ( 
                select distinct(bill_ref_no) from fatweb_retail ) 
                
                select count(1) from fatweb_dist
                
                                grant all on fatweb_dist to public; 
                                
                                select bill_ref_no from g0023421sql.fatweb_dist
                                
                                select count(1) from fatweb_retail


SELECT * FROM GVT_PROCESSAMENTO_CICLO