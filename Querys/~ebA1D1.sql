select * from all_tables where table_name like 'MESSAGE'

SELECT *
  FROM GVT_MSG_ISENCAO_ICMS
WHERE UF = 'RS'
   AND MOTIVO = 'Redução BC - Prot 003752-14.00/07-3';

SELECT *--VII.MENSAGEM -- INTO :p_message:i0091
  FROM CMF C, 
       MKT_CODE_VALUES MKT, 
       GVT_MSG_ISENCAO_ICMS VII
WHERE /*C.ACCOUNT_NO = :p_account_no
   AND */C.MKT_CODE = MKT.MKT_CODE
   AND MKT.LANGUAGE_CODE = 2
   AND MKT.SHORT_DISPLAY = VII.UF
   AND C.CONTACT1_PHONE  = VII.DOCUMENTO
   AND MOTIVO = 'Redução BC - Prot 003752-14.00/07-3';


select *
  from bill_invoice
where FORMAT_STATUS = -1
 and file_name is not null
 and prep_status = 1
 
select * 
  from bill_invoice
where FORMAT_STATUS = 2
 and file_name is not null
 and prep_status = 1
 
 select * from P9909295SQL.CARDIONALIDADE_PLANOS;
 
 select * from product where COMPONENT_ID in (36829,36830,36831,36832,36817,36818,36825,36826,36833,36834,36835,36836,36828,36827) -- LOREN