select account_no,
       file_name,
       prep_date,
       format_status 
  from bill_invoice
 where bill_ref_no = 25254597

select TELEFONE,
       CODIGO_CLIENTE,
       NUMERO_FATURA,
       NOME,
       DATA_EMISSAO,
       IMAGE_TYPE
  from customer_care
 where numero_fatura = '25254597'
 
 
 
 PKG_VAL_CONTAS_PROFORMA