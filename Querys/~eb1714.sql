select * from GVT_DET_FATURAMENTO_CD                        
where external_id in ('999981921510');


            SELECT *
            FROM GVT_LOG_DET_FATURAMENTO_CD
            where external_id = 999988297186
            
            
                  select * from customer_id_acct_map where external_id = '999988297186'
                  
                  
                              select * from customer_id_acct_map where external_id = '999988297186'
            
--  Cadastro                     
select * from GVT_DET_FATURAMENTO_CD                        
 where external_id in ('999988297186');
 

INSERT INTO GVT_DET_FATURAMENTO_CD (external_id) VALUES (select external_id from customer_id_acct_map where external_id in ('999981921510','999988297186','999979663889','999979665568','777777703803','999979673231'));

commit;

select * from GVT_DET_FATURAMENTO_CD where external_id in ('777777746991','777777764185','777777766445','777777768456', '999988297186', '999985062334')


S_QUOTE_SOLN