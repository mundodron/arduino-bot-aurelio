    SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S'
    ORDER BY cod_agente_arrecadador;
    
    
    update gvt_dacc_gerencia_fila_eventos set status_evento = 1 where 