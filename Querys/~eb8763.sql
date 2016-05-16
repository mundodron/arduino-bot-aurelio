select CODIGO_CLIENTE, NUMERO_FATURA,IMAGE_NUMBER,IMAGE_TYPE,DATA_EMISSAO, DATA_VENCIMENTO from customer_care where codigo_cliente = '999984839755' and image_type = 02

select * from customer_care where codigo_cliente = '999997190841' and image_type = 02


select * from customer_care where data_emissao <> data_vencimento order by data_vencimento desc


select * from adj