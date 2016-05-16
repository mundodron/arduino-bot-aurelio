          EXECUTE IMMEDIATE   'SELECT seq_numb '
                           || '  FROM ' || v_bank_seqs
                           || ' WHERE bank_id = 001 '
                       INTO v_seq_numb;
                       
          SELECT 'DBAREM_' || GLOBAL_NAME || '.bankseqs' FROM GLOBAL_NAME;