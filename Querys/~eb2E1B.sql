-- 03420926000124 

select contact1_phone from cmf where account_no = 4610803

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ where account_no = 4610803

select * from gvt_layout_faturas_corp where account_no in (4610803)AND data_exclusao is null AND flag = 1

select * from gvt_layout_faturas_corp where account_no in (9698339) AND data_exclusao is null AND flag = 1
 
 SELECT A.CNPJ, B.MENSAGEM, C.NUM_CONTRATO
       -- INTO :p_cnpj:i0090, :p_mensagem:i0091, :p_num_contrato:i0092
      FROM (SELECT G1.account_no ACCOUNT_NO, G1.cnpj CNPJ, to_char(NULL) MENSAGEM, to_char(NULL) NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G1
               WHERE G1.account_no = 4610803
                 AND G1.data_exclusao is null
                 AND G1.flag = 1
             ) A,
             (SELECT G2.account_no ACCOUNT_NO, to_char(NULL) CNPJ, G2.mensagem MENSAGEM, to_char(NULL) NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G2
               WHERE G2.account_no = 4610803
                 AND G2.data_exclusao is null
                 AND G2.flag = 2
             ) B,        
             (SELECT G3.account_no ACCOUNT_NO, to_char(NULL) CNPJ, to_char(NULL) MENSAGEM, G3.num_contrato NUM_CONTRATO
                FROM GVT_LAYOUT_FATURAS_CORP G3
               WHERE G3.account_no = 4610803
                 AND G3.data_exclusao is null
                 AND G3.flag = 3
             ) C,
             CMF
      WHERE CMF.account_no = 4610803
        AND A.account_no (+) = CMF.account_no 
        AND B.account_no (+) = CMF.account_no
        AND C.account_no (+) = CMF.account_no;

        select * from bill_invoice where bill_ref_no = 317292329
        
        select * from bill_invoice where account_no = 4610803 order by bill_ref_no desc
        
        select mkt_code, account_category from cmf where account_no = 4610803 order by prep_date
                
        select * from mkt_code_values where mkt_code = 21
                
        select * from all_tables where table_name like'%CNPJ%'
                
        select * from GVT_LOTERICA_CONSULTA_CPFCNPJ where contact1_phone = '999985254604'
                
        select * from gvt_cobilling_operadora where cod_cnpj = '03420926000124'
                
        select max(bill_ref_no) from bill_invoice where account_no = 4610803 and prep_status =1 and prep_error_code is null 
                
                v1063
                
                SELECT *  FROM RATE_RC WHERE UNITS_LOWER_LIMIT >= 201602 AND INACTIVE_DATE IS NULL AND ELEMENT_ID = 10093;    

select account_no, DATA_PROCESSAMENTO, count(1) from gvt_conta_internet where data_processamento > sysdate -15 and bill_ref_no is not null group by account_no, DATA_PROCESSAMENTO having count(1) > 1

select * from gvt_conta_internet where data_processamento > sysdate -5 and bill_ref_no is not null and external_id = 899996470965

select * from gvt_conta_internet where account_no = 10620354 order by 3 desc

select * from customer_id_acct_map where external_id = '899995382904'

select * from customer_id_acct_map where account_no = 10938828

select * from bill_invoice where bill_ref_no = '324478379'

select account_no, bill_lname from cmf where account_no = 10707190

select * from gvt_conta_internet where account_no = 3551840 and nome_arquivo = 'Marco/6/2016Marco999986204786_250.cdc'
           
           select count(1) from 
           (select nome_arquivo, count(1) 
             from gvt_conta_internet
            where data_processamento > sysdate -120
              --and account_no = 3551840
              and nome_arquivo is not null
            group by nome_arquivo having count(1) > 1)
            
            select 2753 + 983 from dual
            
            
            select * from bill_invoice where bill_ref_no = 319667746
            
            select * from customer_id_acct_map where account_no = 3821173
            
            select * from bill_invoice where account_no = 3821173 order by 2 desc
            
            select * from customer_care where codigo_cliente = 999985254604 and numero_fatura = '0317292329-0'
                
          
            select account_category from cmf where account_no = 1299870
            
            select * from bill_invoice where account_no = 1299870 order by 2 desc