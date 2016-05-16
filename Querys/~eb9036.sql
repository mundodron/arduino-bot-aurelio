         select count(1) from 
           (select bill_ref_no,nome_arquivo, count(1) 
             from gvt_conta_internet
            where data_processamento > sysdate -120
              --and account_no = 3551840
              and nome_arquivo is not null
            group by nome_arquivo having count(1) > 1)
            
            
            select * from bill_invoice where bill_ref_no = 317292329