select * from gvt_rajadas where external_id = 999990791857

select * from payment_trans where account_no = 3861883 and BILL_REF_NO = 97099284

select a.*, rowid from gvt_rajadas_baixa a

insert into gvt_rajadas_baixa (EXTERNAL_ID,ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS, CHECK_AMOUNT ,DEPOSIT_DT ,GL_AMOUNT ,EXTERNAL_AMOUNT,MSG)
                    VALUES ('999985180922',   4149008,    97755012,               0,         9636,to_date('06/12/2011','dd/mm/yyyy'),      15951, 15951,'SANTANDER')

  select p.* 
    from payment_trans p,
         gvt_rajadas_baixa g
   where P.ACCOUNT_NO = G.ACCOUNT_NO
     and P.BILL_REF_NO = G.BILL_REF_NO
     
     
     select * from gvt_rajadas_baixa where external_id = '999985279845'
     
     
   select p.* 
     from payment_trans p,
         gvt_rajadas_baixa g
    where P.ACCOUNT_NO = G.ACCOUNT_NO
      and P.BILL_REF_NO = G.BILL_REF_NO;