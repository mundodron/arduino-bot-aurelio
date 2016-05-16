 select to_date(gvt_date, 'dd/mm/yy') DATA,
        GVT_FILE_NAME,
        TOT_CONTAS_ABNC,
        PDF_MATCH_OK,
        PDF_MATCH_ERROR 
   from gvt_invoice_control 
  where gvt_mode = 'BOLETO'
    and to_date(gvt_date,'dd/mm/yy') > trunc(sysdate) - 90
  order by to_date(gvt_date,'dd/mm/yy') desc;