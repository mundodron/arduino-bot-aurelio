select * from CONTROLE_EXECUCAO_COBILLING where rotina = 'pl_cnc_arquivo_cnc' order by data_inicio desc

select rowid, a.* from CONTROLE_EXECUCAO_COBILLING a where a.rotina = 'pl_cnc_arquivo_cnc' and a.status in ('S', 'Y', 'OK') order by data_fim desc

  Select max(data_fim)
    --into iBUSCA_ULTIMA_EXECUCAO
    from CONTROLE_EXECUCAO_COBILLING
   where rotina = 'pl_cnc_arquivo_cnc'
     -- status com sucesso
     and status in ('S', 'Y', 'OK');
     
update CONTROLE_EXECUCAO_COBILLING set data_fim = sysdate - 90 where rotina = 'pl_cnc_arquivo_cnc' and status in ('S', 'Y', 'OK');