SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S'