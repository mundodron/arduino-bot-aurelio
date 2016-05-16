    Select 
        count(1) qtde,
        trunc(prep_date) data_processamento, 
        --decode(format_status,2,'Ok',3,'Ok',0,'Pendente',1,'Pendente','Erro') status
        decode(format_status, 2, 'Gerado', -1, 'N�o Gerado') status
      from BILL_INVOICE bi
     where bi.prep_status = 1
     and bi.prep_date >= to_date('01/01/2016','dd/mm/rrrr')
     and bi.prep_error_code is null
     group by 
        trunc(prep_date), 
        --decode(format_status,2,'Ok',3,'Ok',0,'Pendente',1,'Pendente','Erro')
        decode(format_status, 2, 'Gerado', -1, 'N�o Gerado')



select * from 