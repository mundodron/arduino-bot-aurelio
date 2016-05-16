select * from gvt_bankslip where trunc(data_atualizacao) = to_date('06/07/2013','dd/mm/yyyy')

select * from gvt_bankslip where trunc(PPDD_DATE) = to_date('21/07/2013','dd/mm/yyyy') and trunc(data_atualizacao)  to_date('06/07/2013','dd/mm/yyyy')