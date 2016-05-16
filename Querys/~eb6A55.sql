###################################
ERROR: INVALID NUMBER OF ARGUMENTS.
###################################

The right format is :

exec_bip.sh PROCESS_NAME CUSTOMER_DB_NAME CUSTOMER_SERVER_ID MODE (for all accounts) or
exec_bip.sh PROCESS_NAME CUSTOMER_DB_NAME CUSTOMER_SERVER_ID MODE CRITERIA

CRITERIA can be ACCOUNT_NO (for modes 0 or 3)  or
                TRACKING_ID (for mode 7 and 8) or
                BILL_REF_NO (for mode 6)

MODE can be one of the following values : 0 (production), 3 (pro-forma), 5 (disc.credits only), 6 (backout)
                                          7 (HQ discount), 8 (HQ discount proforma)

svuxd1b1:/app/arbor12/fx/scripts:

Segue procedimentos:                                                                                                                                                                                     
                                                                                                                                                                                                         
BIP:                                                                                                                                                                                                     
                                                                                                                                                                                                         
PARA ALTERAR DATA DO AMBIENTE:


ALTER SYSTEM SET FIXED_DATE='20102011' --fixar data de 20 de outubro de 2011

ALTER SYSTEM SET FIXED_DATE='NONE' --Usar data atual do banco.                                                                                                                                                                                                         
                                                                                                                                                                                                         
Insert into PROCESS_SCHED                                                                                                                                                                                
  (PROCESS_NAME, TASK_NAME, TASK_CYCLE, TASK_MODE, SCHED_START, TASK_INTRVL, TASK_STATUS, TASK_PRIORITY, SLIDE_TIME, DB_NAME, SQL_QUERY, DEBUG_LEVEL)                                                    
Values                                                                                                                                                                                                   
  ('bip04   ', 'bip04', 'N ', 0, TO_DATE('09/06/2011 10:45:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 0, 2, 30, 'db1ct1                        ', 'CMF.account_no in (3277056)', 0);
COMMIT;                                                                                                                                                                                                  
                                                                                                                                                                                                         
                                                                                                                                                                                                    
-- inserir na process_sched                                                                                                                                                                              
                                                                                                                                                                                                        
                                                                                                                                                                                                         
<Processo> <nome processo> <base> <server(base)> <mode(proforma, production)> <accounts(select acctoun_no from ‘x’)>                                                                                     
                                                                                                                                                                                                         
./exec_bip.sh bip04 db1ct2 4 3 3457339 –PROFORMA                                                                                                                                                         
                                                                                                                                                                                                         
./exec_bip.sh bip04 db1ct2 4 0 3457339 --PRODUCTION
                                                                                                                                                                                                         
./exec_bip.sh bip11 db1ct2 3 3 3367975 –PROFORMA                                                                                                                                                         
                                                                                                                                                                                                         
--hq                                   

Insert into PROCESS_SCHED                                                                                                                                                                                
  (PROCESS_NAME, TASK_NAME, TASK_CYCLE, TASK_MODE, SCHED_START, TASK_INTRVL, TASK_STATUS, TASK_PRIORITY, SLIDE_TIME, DB_NAME, SQL_QUERY, DEBUG_LEVEL)                                                    
Values                                                                                                                                                                                                   
  ('bip99   ', 'bip99', 'N ', 7, sysdate, 1, 0, 2, 30, 'db1ct2', 'CAH.tracking_id in (16126249)', 0);
COMMIT;                                                                                                                                                                    
                                                                                                                                                                                                         
./exec_bip.sh bip11 db1ct2 4 8 21892204 –PROFORMA                                                                                                                                                        
                                                                                                                                                                                                         
./exec_bip.sh bip11 db1ct2 4 7 21892204 –PRODUCTION                                                                                                                                                      

./exec_bip.sh bip99 db1ct2 4 7 16126249 –PRODUCTION
                                                                                                                                                                                                         
                                                                                                                                                                                                         
SIN:                                                                                                                                                                                                     
                                                                                                                                                                                                         
-- inserir na process_sched                                                                                                                                                                              
                                                                                                                                                                                                         
<Processo> <nome processo>  <server(base)> <prep_date (formato dd-mm-yyyy)>                                                                                                                              
                                                                                                                                                                                                         
./exec_sin_geral_ct1.sh sin01 3 15-12-2011                                                                                                                                                                         

 inserir na process_sched da catalogo apontando para a customer desejada

insert into PROCESS_SCHED
(process_name, task_name, task_cycle, task_mode, sched_start,task_intrvl, task_status, task_priority, slide_time, db_name, sql_query
,debug_level, plat_id, usg_crt_hour, usg_plat_id, usg_version) 
values('sin01', 'sin01', 'N', '0' ,SYSDATE, 1, 0, 2, 0,'DB5CT1', NULL, 0, NULL, NULL, NULL, NULL);


SYSTEM_PARAMETERS SIN_RUN_MODE=1 (RODAR NOS CUSTOMERS)

--inserir na SIN INCOMPLETE CASO RODE SIN AVULSO
SELECT * FROM SIN_INCOMPLETE where bill_ref_no=?? (Bip insere nesta tabela)

./exec_sin_geral.sh sin01 3 

SELECT * FROM SIN_INCOMPLETE where bill_ref_no=?? (Não pode existir na tabela após rodar o SIN)

tem que estar com format_status=0 e image_done=0, format_error_code is null 

validar se não tem registro preso na process_status da catalogo
                                                                                                                                                                                                                                                                                                                                                                                                                  
EIF:                                                                                                                                                                                                     
                                                                                                                                                                                                         
Inserir a fatura na tabela INVOICE_RUN_EIF                                                                                                                                                               
                                                                                                                                                                                                         
sh eifinit_retailct1.sh                                                                                                                                                                                  
                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                 
sh eifinit_retailct2.sh                                                                                                                                                                                  
                                                                                                                                                                                                         
sh eifinit_corpct1.sh                                                                                                                                                                                    
                                                                                                                                                                                                         
eifinit_corpct2.sh                                                                                                                                                                                       
                                                                                                                                                                                                         
Conferir na tabela bill_invoice se o campo file_name foi preenchido e se format_status = 2 e formar_error_code nulo                                                                                      
                                                                                                                                                                                                         
Gerando o arquivo para ABNC                                                                                                                                                                              
                                                                                                                                                                                                         
- A partir do diretório /app/arbor12/fx/data/disp/feed/ready:                                                                                                                                            
                                                                                                                                                                                                         
- ls -ltr                                                                                                                                                                                                
                                                                                                                                                                                                         
- tar -cvf <nome arquivo.tar> <nome feed file>                                                                                                                                                           
                                                                                                                                                                                                         
                * nome arquivo.tar --> gvt_teste_production_<segmento>_<data>_<analista>.tar                                                                                                             
                                                                                                                                                                                                         
- gzip <nome arquivo gerado>                                                                                                                                                                             
                                                                                                                                                                                                         
                                                                                                                                                                                                         
                                                                                                                                                                                                         
Disponibilização do arquivo via ftp                                                                                                                                                                      
                                                                                                                                                                                                         
- ftp 192.4.0.138                                                                                                                                                                                        
                                                                                                                                                                                                         
Usuário para upload
login: gvt_up
senha: BBfg32q 

Usuário para download
login: gvt_down
senha: jk855SS                                                                                                                                                                    
                                                                                                                                                                                                         
- Usar comandos put e get.                                                                                                                                                                               
                                                                                                                                                                                                         
Enviar email para VALID S.A. (abnopera@valid.com.br) de acordo com o padrão abaixo:                                                                                                                      
                                                                                                                                                                                                         
Subject: Geração de PDF's                                                                                                                                                                                
                                                                                                                                                                                                         
Pessoal,                                                                                                                                                                                                 
                                                                                                                                                                                                         
Está disponível no link o seguinte arquivo: gvt_teste_production_corp_12082011_eve.tar.gz (não enviar ao cliente).                                                                                       
                                                                                                                                                                                                         
Favor processar e retornar os PDF's.                                                                                                                                                                     
                                                                                                                                                                                                         
Caso o processamento apresente erro, favor retornar a descrição dos mesmos para análise.                                                                                                                 
                                                                                                                                                                                                         
Att,                                                                                                                                                                                                     
                                                                                                                                                                                                         