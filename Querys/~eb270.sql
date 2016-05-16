select * from arborgvt_payments.gvt_dacc_controle_nsa order by 3 desc

select * from GVT_DACC_GERENCIA_FILA_EVENTOS

select * from arborgvt_payments.gvt_dacc_controle_nsa order by 2 desc

update arborgvt_payments.gvt_dacc_controle_nsa set NSA = (NSA - 1) where CLEARING_HOUSE_ID in (745,409,748,399,341,275,237,104,001)

select * from gvt_dacc_gerencia_met_pgto where status_cadastramento = 0

select * from gvt_dacc_gerencia_met_pgto where status_cadastramento = 2

update gvt_dacc_gerencia_met_pgto set status_cadastramento = 2 where status_cadastramento = 0 and trunc(DT_CADASTRO) > to_date('04/03/2012','DD/MM/YYYY');

commit;  

select * from gvt_dacc_gerencia_met_pgto where trunc(DT_CADASTRO) > to_date('04/03/2012','DD/MM/YYYY')

update gvt_dacc_gerencia_met_pgto set status_cadastramento = 2 where status_cadastramento = 0 and trunc(DT_CADASTRO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY');

update GVT_DACC_GERENCIA_FILA_EVENTOS set status_evento = 0 where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') and status_evento = 9;

commit;

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where trunc(DT_EVENTO) > to_date('04/03/2012','DD/MM/YYYY') and trunc(DT_EVENTO) < to_date('07/03/2012','DD/MM/YYYY') and status_evento = 9;