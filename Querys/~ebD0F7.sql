            SELECT seq_numb
              --INTO v_seq_numb
              FROM DBAREM_PBCT2.BANK_SEQS -- bank_seqs
              
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             
             
             select v$instance from dual
             
               SELECT GLOBAL_NAME into v_banco FROM GLOBAL_NAME;
               
               
                SELECT 'DBAREM_' || GLOBAL_NAME || '.bankseqs' FROM GLOBAL_NAME;
  
  
  execute immediate 'alter session set current_schema =  DBAREM_ ' || SELECT GLOBAL_NAME FROM GLOBAL_NAME';