CREATE OR REPLACE TRIGGER GRCOWN.TRG_SERV_PRESTADOS
  BEFORE INSERT OR UPDATE
  ON GRCOWN.GRC_SERVICOS_PRESTADOS   FOR EACH ROW
DECLARE

/*--------------------------------------------------------------------------------------------------
NAME.............: trg_serv_prestados
PURPOSE..........: Grava/Atualiza a tabela GRC_HISTORICOS_SERV_PRESTADOS o log das alterações dos status dos CDRs.
                   Impede que os CDRs mudem para status inválidos.
DATA BASE........: PBCT1
OWNER............: GRCOWN

-----------------------------------------------------------------------------------------------------
VERSÃO  AUTOR:               DATA:       DOC:        RDM       MOTIVO:
------  -------------------- ----------- ----------- --------- --------------------------------------
1.00                                                           Desenvolvimento
1.01    g0010388 Valter      08/08/2014  PROB512443  RDM8482   Impossibilitar a mudança de status de F9/F2 (inadimplente) para A (arrecadado).
1.02    g0010388 Valter      28/08/2014  PROB609174  RDM9279   Cadastro do Status "RA" (Contestado após Arrecadado, e antes de Repassado.
1.03    g0010388 Valter      07/11/2014  PROB713192  RDM12140  Não permitir mudar o status para (RJ, RI, RP, RA) quando o Motivo for nulo.
1.04    g0010388 Valter      19/11/2014  PROB720484  RDM12410  Correção da msg de erro ao trocar para o status "A"
---------------------------------------------------------------------------------------------------- */
   v_existe VARCHAR2(1);
   BACK_STS VARCHAR2(2);
BEGIN
  -- INSERTING
  IF INSERTING THEN
    INSERT INTO GRC_HISTORICOS_SERV_PRESTADOS
          ( SERVICO_PRESTADO,      STATUS_DE, STATUS_PARA,  DATA_ALTERACAO,  MOTIVO,       PARCEIRO)
    VALUES( :NEW.SEQUENCIAL_CHAVE, 'XX',      :NEW.STATUS,  SYSDATE,         :NEW.Motivo,  :NEW.PARCEIRO);

  -- UPDATE
  ELSE
    IF :NEW.STATUS <> :OLD.STATUS THEN
      -- EM FATURAMENTO
      IF    :NEW.STATUS IN ('RJ','RI','RP','RA') AND :NEW.MOTIVO IS NULL        THEN RAISE_APPLICATION_ERROR(-20250, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o MOTIVO deve ser diferente de nulo!');  -- RDM12140
      ELSIF :NEW.STATUS = 'EF' AND :OLD.STATUS <> 'AF'                          THEN RAISE_APPLICATION_ERROR(-20251, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "AF"!');
      ELSIF :NEW.STATUS = 'F'  AND :OLD.STATUS NOT IN ('EF','RI')               THEN RAISE_APPLICATION_ERROR(-20252, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "EF" ou "RI".');
      ELSIF :NEW.STATUS = 'F9' AND :OLD.STATUS NOT IN ('F','RI')                THEN RAISE_APPLICATION_ERROR(-20253, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F" ou "RI".');
      ELSIF :NEW.STATUS = 'F2' AND :OLD.STATUS <> 'F9'                          THEN RAISE_APPLICATION_ERROR(-20254, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F9".');
    --ELSIF :NEW.STATUS = 'A'  AND :OLD.STATUS NOT IN ('F','F9','F2','RI','CA') THEN RAISE_APPLICATION_ERROR(-20255, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F" ou "F9" ou "F2" ou "RI" ou "CA".'); -- RDM8482
      ELSIF :NEW.STATUS = 'A'  AND :OLD.STATUS NOT IN ('F',     'RA','RI','CA') THEN RAISE_APPLICATION_ERROR(-20255, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F".');
      ELSIF :NEW.STATUS = 'RI' AND :OLD.STATUS NOT IN ('F','A','F9','F2')       THEN RAISE_APPLICATION_ERROR(-20256, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F" ou "A" ou "F9" ou "F2".');
      ELSIF :NEW.STATUS = 'R'  AND :OLD.STATUS NOT IN ('A','F','RP')            THEN RAISE_APPLICATION_ERROR(-20257, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "A" ou "F" ou "RP".');
      ELSIF :NEW.STATUS = 'DE' AND :OLD.STATUS NOT IN ('AF','RI','P')           THEN RAISE_APPLICATION_ERROR(-20258, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "AF" ou "RI" ou "P".');
      ELSIF :NEW.STATUS = 'RJ' AND :OLD.STATUS <> 'EF'                          THEN RAISE_APPLICATION_ERROR(-20260, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "EF".');
      ELSIF :NEW.STATUS = 'CA' AND :OLD.STATUS NOT IN ('F','F9','F2')           THEN RAISE_APPLICATION_ERROR(-20262, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "F" ou "F9" ou "F2".');
      ELSIF :NEW.STATUS = 'RP' AND :OLD.STATUS <> 'R'                           THEN RAISE_APPLICATION_ERROR(-20265, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "R".');
      ELSIF :NEW.STATUS = 'RA' AND :OLD.STATUS <> 'A'                           THEN RAISE_APPLICATION_ERROR(-20265, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "A".');
      ELSIF :NEW.STATUS = 'RV' AND :OLD.STATUS NOT IN ('A','R','RP','RI')       THEN RAISE_APPLICATION_ERROR(-20266, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "A" ou "R" ou "RP" ou "RI".');
      ELSIF :OLD.STATUS = 'P'  AND :NEW.STATUS NOT IN ('AF','DE')               THEN RAISE_APPLICATION_ERROR(-20264, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: o status anterior deve ser igual a "P".');
      ELSIF :OLD.STATUS = 'DE' AND :NEW.STATUS <> :OLD.STATUS                   THEN RAISE_APPLICATION_ERROR(-20259, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: O status "Desprezado" é o ultimo status do CDR.');
      ELSIF :OLD.STATUS = 'RJ' AND :NEW.STATUS <> :OLD.STATUS                   THEN RAISE_APPLICATION_ERROR(-20261, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: O status "Rejeitado" é o ultimo status do CDR.');
      ELSIF :OLD.STATUS = 'CA' AND :NEW.STATUS NOT IN ('CA','A')                THEN RAISE_APPLICATION_ERROR(-20263, 'Voce esta mudando o status de ('||:OLD.STATUS||') para ('||:NEW.STATUS||'). ERRO: O status "Cancelado" é o ultimo status do CDR.');
      ELSE NULL; --DBMS_OUTPUT.PUT_LINE('Mudança de status ocorreu sem problemas');
      END IF;

      INSERT INTO GRC_HISTORICOS_SERV_PRESTADOS
               ( SERVICO_PRESTADO,        STATUS_DE,    STATUS_PARA,  DATA_ALTERACAO,  MOTIVO,       PARCEIRO       ) VALUES(
                 :OLD.SEQUENCIAL_CHAVE,   :OLD.STATUS,  :NEW.STATUS,  SYSDATE,         :NEW.Motivo,  :OLD.PARCEIRO );
      -- Tratamento de chamadas com reversão de pagamento:
      --  Se a chamada sofrer reversão de pgto após o repasse sem que esta tenha sido contestada, a chamada é armazenada
      --  em tabela de reversões para que seja somada e contabilizada como crédito para a GVT no momento do calculo do Repasse.
      --  Nos demais casos o status na SP(serv.Prestados) é alterado para o ultimo status antes da arrecadação e na HSP(Históricos)
      --  é inserido um status de RV e tbem o status antes da Arrecadação com data de alteração 1 Segundo depois do Status de RV.
      IF (:NEW.STATUS = 'RV' ) THEN

        IF :OLD.STATUS NOT IN ('RI','RP') THEN
          SELECT HSP.STATUS_DE
            INTO BACK_STS
            FROM GRC_HISTORICOS_SERV_PRESTADOS HSP
           WHERE HSP.SERVICO_PRESTADO = :NEW.SEQUENCIAL_CHAVE
             AND HSP.STATUS_PARA = 'A'
             AND HSP.DATA_ALTERACAO = ( SELECT MAX(DATA_ALTERACAO)
                                        FROM GRC_HISTORICOS_SERV_PRESTADOS
                                        WHERE SERVICO_PRESTADO = HSP.SERVICO_PRESTADO
                                        AND STATUS_PARA = 'A'
                                      );
          ---
          IF BACK_STS NOT IN ('RI','RP') THEN
            :NEW.STATUS := BACK_STS;

            INSERT INTO GRC_HISTORICOS_SERV_PRESTADOS
                      ( SERVICO_PRESTADO,       STATUS_DE,  STATUS_PARA,  DATA_ALTERACAO,      MOTIVO,       PARCEIRO        ) VALUES (
                        :OLD.SEQUENCIAL_CHAVE,  'RV',       :NEW.STATUS,  SYSDATE + 0.00001,   :NEW.Motivo,  :OLD.PARCEIRO   );

            IF :OLD.STATUS = 'R' THEN
              INSERT INTO GRC_REVERSAO  VALUES ( :OLD.PARCEIRO,   :OLD.SEQUENCIAL_CHAVE,   :OLD.VALOR_BRUTO,   NULL  );
            END IF;
          END IF;
        END IF; -- IF :OLD.STATUS NOT IN ('RI','RP') THEN
      END IF; -- IF (:NEW.STATUS = 'RV' ) THEN
    END IF; -- IF :NEW.STATUS <> :OLD.STATUS THEN
  END IF; -- IF INSERTING THEN
END;
/
