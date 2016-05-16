CREATE OR REPLACE TRIGGER CMF_CONTROLE_NO_BILL
AFTER UPDATE
    OF NO_BILL,REMARK,ACCOUNT_CATEGORY
    ON CMF
    FOR EACH ROW
--    WHEN (NEW.NO_BILL= 1 AND NEW.REMARK = 'Analise Inadimplencia')
DECLARE
    S_CICLO VARCHAR2(10);
    N_CONTA NUMBER;
BEGIN

-- 
IF (UPDATING('NO_BILL') OR UPDATING('REMARK')) AND ((:OLD.NO_BILL <> :NEW.NO_BILL) or (:NEW.REMARK <> :OLD.REMARK)) THEN
  INSERT INTO gvt_no_bill_audit 
  VALUES 
              (:OLD.ACCOUNT_NO,
              :OLD.BILL_PERIOD,
              :OLD.REMARK,
              :NEW.REMARK,
              :OLD.CHG_WHO,
              :OLD.CHG_DATE,
              :OLD.NO_BILL,
              :NEW.NO_BILL,
              SYSDATE
              );
END IF;

-- Testa condição para atualizar tabela de controle de NO_BILL utilizada pelo SIEBEL
IF UPDATING('NO_BILL') AND UPDATING('REMARK') AND :NEW.REMARK = 'Analise Inadimplencia' THEN
  INSERT INTO GVT_CONTROLE_NO_BILL
       SELECT EXTERNAL_ID,:new.no_bill,SYSDATE,0
       FROM CUSTOMER_ID_ACCT_MAP EIAM
       WHERE EIAM.ACCOUNT_NO = :OLD.ACCOUNT_NO
       AND   EIAM.EXTERNAL_ID_TYPE=1;
END IF;



-- Garante que não está alterando no_bill ou account_category para ciclo em produção
IF UPDATING('NO_BILL') OR UPDATING('ACCOUNT_CATEGORY') THEN
  --verifica qual ciclo esta em producao
  N_CONTA := 0;
  S_CICLO := '';

  SELECT NVL(COUNT(1),0)
  INTO N_CONTA
  FROM ARBOR.SYSTEM_PARAMETERS
  WHERE MODULE = 'GVT'
  AND PARAMETER_NAME = 'CICLO_EM_PRODUCAO';

  IF N_CONTA > 0 THEN
    SELECT SUBSTR(CHAR_VALUE,1,3)
    INTO S_CICLO
    FROM ARBOR.SYSTEM_PARAMETERS
    WHERE MODULE = 'GVT'
    AND PARAMETER_NAME = 'CICLO_EM_PRODUCAO';
  END IF;
  S_CICLO := RTRIM(S_CICLO);

  IF LENGTH(S_CICLO) > 0 THEN

    -- no_bill
    IF :OLD.BILL_PERIOD = S_CICLO AND :OLD.NO_BILL != :NEW.NO_BILL THEN
      RAISE_APPLICATION_ERROR(-20001, '100001,TRIG_GVT: Não é permitida a alteração do campo NO_BILL durante a produção do ciclo.');
    END IF;

    -- account_category
    IF :OLD.BILL_PERIOD = S_CICLO AND :OLD.ACCOUNT_CATEGORY != :NEW.ACCOUNT_CATEGORY THEN
      RAISE_APPLICATION_ERROR(-20001, '100002,TRIG_GVT: Não é permitida a alteração do campo ACCOUNT_CATEGORY durante a produção do ciclo.');
    END IF;

  END IF;
END IF;

END;
/

