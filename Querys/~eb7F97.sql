  SELECT /*+ ordered parallel(a 08) full(a) */
          a.account_no,
          a.bill_ref_no,
          a.bill_ref_resets,
          e.full_sin_seq,
          a.closed_date,
          b.statement_date,
          b.payment_due_date,
          substr( CONVERT( replace(replace(DECODE(TRIM(c.bill_lname) , NULL,' ', SUBSTR(TRIM(c.bill_lname), 1,54 )) ,CHR(13),''),CHR(10),''), 'US7ASCII', 'WE8ISO8859P1'),1,54) bill_lname,
          c.account_category,
          d.external_id,
          0 valor_ajustes,
          0 total_adj, 
          0 valor_faturado,
          0 valor_pgtos,
          0 valor_ajustes_baixados
   FROM   cmf_balance a,
          bill_invoice b,
          cmf c,
          CUSTOMER_ID_ACCT_MAP d,
          sin_seq_no e,
          gvt_exec_arg
   WHERE  a.bill_ref_no <> 0
   AND    b.account_no+0 = a.account_no
   AND    b.bill_ref_no = a.bill_ref_no
   AND    b.bill_ref_resets = a.bill_ref_resets
   AND    b.prep_status = 1
   AND    TO_CHAR(b.statement_date, 'YYYYMM') <= TRIM(desc_parametro)
   AND    nome_programa = 'PLCON_0001'
   --AND    flg_utilizado = 'N'
   and    num_execucao = 43611
   AND    b.prep_date+0 <= TO_DATE(TO_CHAR(LAST_DAY(TO_DATE(RTRIM(desc_parametro),'YYYYMM')),'YYYYMMDD')||'235959','YYYYMMDDHH24MISS')
   AND    b.prep_error_code IS NULL
   AND    c.account_no = A.account_no
   AND    c.account_category <> 16
   AND    d.account_no = c.account_no
   AND    d.external_id_type||'' = 1
   AND    (a.closed_date IS NULL
   OR     TO_CHAR(a.closed_date, 'YYYYMM') > TRIM(desc_parametro))
   AND    e.bill_ref_no(+) = b.bill_ref_no
   AND    e.bill_ref_resets (+) = b.bill_ref_resets
   AND DECODE(NVL(e.open_item_id(+),0),90,0,91,0,92,0,NVL(e.open_item_id(+),0)) < 4;
   
   
   --select * from gvt_exec_arg where nome_programa = 'PLCON_0001' order by 1 desc