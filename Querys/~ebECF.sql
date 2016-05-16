select * from gvt_bankslip where trunc(DATA_ATUALIZACAO) = to_date('28/05/2013','dd/mm/yyyy')
and FULL_SIN_SEQ is null

select NUMERO_FATURA,IMAGE_NUMBER,IMAGE_TYPE from DBAREM.CUSTOMER_CARE where NUMERO_FATURA = '0138086302-0'