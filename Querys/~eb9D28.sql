select * from GVT_FEBRABAN_PONTA_B_ARBOR

          EXECUTE IMMEDIATE   'SELECT seq_numb '
                           || '  FROM ' || v_bank_seqs
                           || ' WHERE bank_id = TO_NUMBER (:cod_agente_arrecadador) '
                       INTO v_seq_numb
                      USING r_linha.cod_agente_arrecadador;
         

  SELECT GLOBAL_NAME FROM GLOBAL_NAME;
  
  
  execute immediate 'alter session set current_schema = SCHEMA';
  
  
                  SELECT 'DBAREM_' || GLOBAL_NAME || '.bankseqs' FROM GLOBAL_NAME;