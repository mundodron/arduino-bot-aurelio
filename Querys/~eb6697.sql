select * from gvt_bankslip where bill_ref_no in (139380126)

select CODIGO_CLIENTE,NUMERO_FATURA,IMAGE_TYPE from customer_care where codigo_cliente = 999983890676 and image_type = 02

select B.ACCOUNT_NO,
       B.EXTERNAL_ID_A,
       B.BILL_REF_NO,
       B.STATUS,
       B.DATA_ATUALIZACAO,
       C.IMAGE_TYPE
from gvt_bankslip b,
     customer_care c
where  1 =1 
-- and   '0' || B.BILL_REF_NO || '-0' = C.NUMERO_FATURA
and  B.BILL_REF_NO in (139380126)
and  B.EXTERNAL_ID_A = C.CODIGO_CLIENTE

and  C.IMAGE_TYPE = 02
