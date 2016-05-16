update gvt_dacc_gerencia_met_pgto set status_cadastramento = 2 where status_cadastramento = 0 and trunc(DT_CADASTRO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_CADASTRO) < to_date('07/03/2012','DD/MM/YYYY');

update GVT_DACC_GERENCIA_FILA_EVENTOS set status_evento = 0 where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') and status_evento = 9;

select * from gvt_dacc_gerencia_met_pgto where status_cadastramento = 0 and trunc(DT_CADASTRO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_CADASTRO) < to_date('07/03/2012','DD/MM/YYYY');

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') and status_evento = 9;

select * from all_tables where owner = 'G0023421SQL'

select * from GVT_RAJADAS_BILL