select * from all_directories

select * from gvt_chamadas_cb where substr(external_id,1,3) = 'TCS' 

select * from CONTROLE_EXECUCAO_COBILLING order by data_fim desc

select * from COBILLING_STATUS where DT_ULTIMO_STATUS > sysdate -2

delete from COBILLING_STATUS where DT_ULTIMO_STATUS > sysdate -2