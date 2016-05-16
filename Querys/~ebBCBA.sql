select * from gvt_bankslip 

select * from gvt_invoice_control where gvt_mode = 'BOLETO'

select * from gvt_invoice_control_detail
 where gvt_mode = 'BOLETO'
   and to_date(gvt_date,'dd/mm/yy') > trunc(sysdate) - 10 
 order by to_date(gvt_date,'dd/mm/yy') desc

select to_date(gvt_date, 'dd/mm/yy') DATA,
       GVT_FILE_NAME,
       TOT_CONTAS_ABNC,
       PDF_MATCH_OK,
       PDF_MATCH_ERROR  
  from gvt_invoice_control 
 where gvt_mode = 'BOLETO'
   and to_date(gvt_date,'dd/mm/yy') > trunc(sysdate) - 90
 order by to_date(gvt_date,'dd/mm/yy') desc
 
 
select *
  from gvt_invoice_control
 where gvt_mode = 'BOLETO'
   and to_date(gvt_date,'dd/mm/yy') > trunc(sysdate) - 10 
 order by to_date(gvt_date,'dd/mm/yy') desc
 
select trunc(sysdate) from dual

select rtrim('teste    ') from dual

select rpad('teste    ', 10) from dual


 select to_date(gvt_date, 'dd/mm/yy') DATA,
        GVT_FILE_NAME,
        TOT_CONTAS_ABNC,
        PDF_MATCH_OK,
        PDF_MATCH_ERROR 
   from gvt_invoice_control 
  where gvt_mode = 'BOLETO'
    and to_date(gvt_date,'dd/mm/yy') > trunc(sysdate) - 90
    and PDF_MATCH_ERROR > 100
    --group by to_date(gvt_date,'dd/mm/yy')
  order by to_date(gvt_date,'dd/mm/yy') desc;
  
  select trunc(DATA_MOVIMENTO), count(1)
    from gvt_bankslip
   where status = 'B'
   group by trunc(DATA_MOVIMENTO)
   order by trunc(DATA_MOVIMENTO) desc;
   
select * from cmf_balance where bill_ref_no = 64458630
   
select * from sin_seq_no where bill_ref_no = 64458630
   
(select external_id_a from gvt_bankslip where sequencial = 1212)

select * from sin_seq_no where bill_ref_no = 64458630
   
select * from gvt_sysrec_fact_arbor where account_no = 2556844 and bill_ref_no = 64458630

select codigo_cliente,
       IMAGE_NUMBER,
       numero_fatura,
       image_type
  from customer_care
 where 1=1 --codigo_cliente in (select external_id_a from gvt_bankslip where sequencial = 1212)
   and trim(numero_fatura) in (select trim(FULL_SIN_SEQ) from gvt_bankslip where sequencial = 1212)
   and DATA_EMISSAO < trunc(sysdate) - 60
   and image_type = 2;
   
   