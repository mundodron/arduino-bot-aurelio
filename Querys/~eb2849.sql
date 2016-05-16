select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') 


select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') and status_evento = 0;