create table gvt_Erro_ctrl_fluxo_caixa as 
select * from gvt_ctrl_fluxo_caixa where cod_banco = 341 and data_movimento  between TO_DATE('05/28/2012 09:00:00', 'MM/DD/YYYY HH24:MI:SS') and TO_DATE('05/28/2012 12:59:59', 'MM/DD/YYYY HH24:MI:SS');

select count(*) from gvt_Erro_ctrl_fluxo_caixa


grant all on erro_FLUXO_CAIXA to public