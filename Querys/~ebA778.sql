select * from GRC_ERROS_BMP 

select * from GRC_SERVICOS_PRESTADOS where COD_REFATURAMENTO is not null

select * from GRC_ERROS_BMP where DURACAO_REAL is not null

select * from GRCOWN.PROC_CARGA_SP

select * from GRC_SERVICOS_PRESTADOS order by data_lote desc

select * from bill_invoice 

 select bill_ref_no fatura, zip cep from bill_invoice
where account_no in (4330340);

select * from gvt_product_velocity where tracking_id in (
select tracking_id from gvt_product_velocity group by tracking_id having count(1) > 1) and end_dt is not null
