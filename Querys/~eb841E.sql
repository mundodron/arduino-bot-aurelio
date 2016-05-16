DECLARE
   v_errcode   NUMBER (10) := 0;

   CURSOR c1 IS
      select
       MAP.EXTERNAL_ID, 
       bill.account_no,
       max(bill.bill_ref_no) Fatura,
       (BILL.Total_paid*-1/100) Total_pago
  from cmf_balance bill, 
       customer_id_acct_map map
 where MAP.EXTERNAL_ID in (select EXTERNAL_ID from ativos)
   and BILL.ACCOUNT_NO = MAP.ACCOUNT_NO
   and MAP.EXTERNAL_ID_TYPE = 1
   and BILL.ORIG_PPDD_DATE > trunc(sysdate - 60) and  BILL.PPDD_DATE < trunc(sysdate - 30)
   group by MAP.EXTERNAL_ID, bill.account_no, bill.Total_paid having count(1) < 2 ;


BEGIN
   FOR x IN c1
   LOOP
      IF v_errcode = 0
      THEN
         BEGIN
           update ativos set bill_ref_no_60 = x.Fatura, total_pago_60 = x.Total_pago
            where external_id = x.EXTERNAL_ID;
            
               DBMS_OUTPUT.put_line('Registo Inserido: '|| x.EXTERNAL_ID ||' - ' || x.account_no ||' - '|| x.Fatura );
            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('ERRO AO TENTAR INSERIR: '|| x.EXTERNAL_ID ||' - '  || x.account_no||' - '|| x.Fatura || '- ERRO: ' || SQLERRM );
         END;
      END IF;
   END LOOP;
END;


-- select ACCOUNT_NO, count(1) from ativos group by account_no order by 2 desc

-- select * from ativos

-- update ativos set account_no = null 


-- delete ativos where account_no is null

-- select * from ativos
