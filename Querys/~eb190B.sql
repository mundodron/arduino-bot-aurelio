delete from gvt_ctrl_fluxo_caixa where external_id in (select external_id from g0023421sql.erro_FLUXO_CAIXA) and cod_banco = 341 and data_movimento  between TO_DATE('05/28/2012 09:00:00', 'MM/DD/YYYY HH24:MI:SS') and TO_DATE('05/28/2012 12:59:59', 'MM/DD/YYYY HH24:MI:SS');
commit;

select * from gvt_ctrl_fluxo_caixa where external_id in (select external_id from g0023421sql.erro_FLUXO_CAIXA) and data_movimento  between TO_DATE('05/28/2012 13:00:00', 'MM/DD/YYYY HH24:MI:SS') and TO_DATE('05/28/2012 16:59:59', 'MM/DD/YYYY HH24:MI:SS');
