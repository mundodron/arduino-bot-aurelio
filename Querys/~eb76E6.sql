        SELECT  
               bks.SEQUENCIAL,
               bks.ACCOUNT_NO,
               bks.EXTERNAL_ID_A,
               bks.SUBSCR_NO,
               bks.SUBSCR_NO_RESETS,
               bks.EXTERNAL_ID_B,
               bks.BILL_LNAME,
               bks.BILL_TIPO_CLIENTE,
               NVL(bks.BILL_ADDRESS1,' ') BILL_ADDRESS1,
               NVL(bks.BILL_ADDRESS2,' ') BILL_ADDRESS2,
               NVL(bks.BILL_ADDRESS3,' ') BILL_ADDRESS3,
               NVL(bks.BILL_CITY,' ') BILL_CITY,
               NVL(bks.BILL_STATE,' ') BILL_STATE,
               bks.BILL_ZIP,
               bks.BILL_REF_NO,
               bks.BILL_REF_RESETS,
               bks.FULL_SIN_SEQ,
               bks.PPDD_DATE,
               bks.TOTAL_ADJ,
               bks.BILL_DRAFT_AMOUNT,
               bks.BILL_AMOUNT,
               bks.ORIG_PPDD_DATE,
               bks.SHORT_DISPLAY,
               bks.DATA_MOVIMENTO,
               bks.STATUS,
               bks.DATA_ATUALIZACAO,
               bks.ROWID row_id
          FROM GVT_BANKSLIP bks
         WHERE 1=1 
          and full_sin_seq is null
         --and bks.status IN ('T', 'R')
      ORDER BY bks.data_atualizacao desc
               