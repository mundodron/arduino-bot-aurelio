
           SELECT count(*) FROM GVT_DETALHAMENTO_CICLO
            WHERE DATA_PROCESSO >= TO_DATE ('2016053100:12:11','YYYYMMDDHH24:MI:SS') 
              AND DATA_PROCESSO >= TO_DATE ('2016060100:12:11','YYYYMMDDHH24:MI:SS') 
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


select * from bill_invoice where account_no in (select account_no from customer_id_acct_map where external_id in ('899996839189')) --'899999310547 ','899998696204'))