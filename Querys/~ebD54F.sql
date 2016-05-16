SELECT 'SP' TABELA,
       SP.TELEFONE_ORIGEM,
       SP.DATA_SERVICO,
       HI.STATUS_PARA,
       HI.MOTIVO,
       SP.CSP,
       SP.COD_SEQ_TFI,
       SP.SEQUENCIAL_ARRECADACAO,
       decode(trim(SP.PAIS_DESTINO),null,'1','2') || -- Cod. Registro
       RPAD(NVL(SP.TELEFONE_ORIGEM,' '),21,' ') || -- Assinate A
       RPAD(NVL(SP.PAIS_DESTINO,' '),3,' ') || -- Cód. do País
       RPAD(NVL(SP.TELEFONE_DESTINO,' '),21,' ') || -- Assinate B
       RPAD(NVL(SP.TELEFONE_ORIGEM,' '),21,' ') || -- Terminal de cobrança
       RPAD(NVL(TO_CHAR(SP.DATA_SERVICO,'DDMMYYYY'),'0'),8,'0') || -- Data da chamada
       LPAD(nvl(SP.HORA_INICIO,'0'),6,'0') || -- Hora início da chamada
       LTRIM(NVL(TO_CHAR(SP.duracao*10,'09999'),'00000')) || -- Duração da chamada
       NVL(FUNC_CONV_STATUS(SP.PARCEIRO,HI.STATUS_PARA),' ') || -- Motivo do Evento
       rpad(' ',3,' ') || -- Cód. motivo do evento
       DECODE(HI.STATUS_PARA,'AF',NVL(TO_CHAR(HI.DATA_ALTERACAO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'EF',NVL(TO_CHAR(SP.DATA_ENVIO_FAT, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'F' ,NVL(TO_CHAR(SP.DATA_EMISSAO_FATURA,'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'A' ,NVL(TO_CHAR(SP.DATA_RECEBIMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RI',NVL(TO_CHAR(SP.DATA_COBRANCA_RI, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RP',NVL(TO_CHAR(SP.DATA_COBRANCA_RI, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'R' ,NVL(TO_CHAR(SP.DATA_REPASSE, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'DE',NVL(TO_CHAR(SP.DATA_CANCELAMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RJ',NVL(TO_CHAR(SP.DATA_CANCELAMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'PA',NVL(TO_CHAR(SP.DATA_RECEBIMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       TO_CHAR(SYSDATE,'DDMMYYYY')) || -- Data do Evento
       rpad(' ',15,' ') || -- Numero da reclamação
       lpad('0',18,'0') || -- Nro contrato parcelamento
       rpad(' ',10,' ') || -- Numero da Nota Fiscal
       rpad(' ',02,' ') || -- Serie da Nota Fiscal
       LTRIM(REPLACE(TO_CHAR(NVL(SP.VALOR_FATURADO, '0'),'09999.00000'),'.',''))|| -- Valor Liquido
       LTRIM(REPLACE(TO_CHAR(NVL(SP.VALOR_BRUTO/100,'0'),'09999.00000'),'.',''))|| -- Valor Bruto
       NVL(TO_CHAR(SP.DATA_VENCIMENTO,'DDMMYYYY'),'00000000') || -- Data Vcto da Chamada
       rpad(' ',02,' ') || -- UF emissor da Nota Fiscal
       RPAD(NVL(TO_CHAR(SP.DATA_EMISSAO_FATURA,'DDMMYYYY'),'0'),08,'0') || -- Data Emissão da conta
       RPAD(NVL(substr(SP.tcoe,5),SP.lote),35,' ') || -- Dsname (nome arq. remessa)
       LPAD(SP.COD_SEQ_TFI,7,'0') || -- Identificador do Reg. no Lote
       LPAD(' ',27,' ') || -- Filler
       '0' linha_arq,
       SP.SEQUENCIAL_CHAVE,
       SP.LOTE,
       HI.ROWID CHAVE,
       SP.VALOR_FATURADO
     FROM   GRC_SERVICOS_PRESTADOS SP, GRC_HISTORICOS_SERV_PRESTADOS HI
    WHERE   SP.SEQUENCIAL_CHAVE = HI.SERVICO_PRESTADO
      AND   SP.PARCEIRO = 2 --p_parceiro
      AND   HI.STATUS_PARA NOT IN ('RI','RP','RA','DE','RJ','P','EF') --Restrição para contest external_id Rejeit. irem em arq. separados
      AND   HI.DATA_ENVIO_PARCEIRO IS NULL
      AND   SP.EOT_FILIAL in ( SELECT EOT
                                 FROM GRC_EOT_OPERADORAS
                                WHERE EOT_AGRUPADOR = 401 -- p_eot_filial
                                  AND PARCEIRO = 2 --p_parceiro
                                  AND (DATA_INATIVACAO IS NULL OR DATA_INATIVACAO >= SYSDATE)
                             );
