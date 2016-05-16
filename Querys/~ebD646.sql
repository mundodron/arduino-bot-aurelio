select * from gvt_rajadas where external_id = 999990791857

select * from payment_trans where account_no = 3861883 and BILL_REF_NO = 97099284    

select a.*, rowid from gvt_rajadas_baixa a

insert into gvt_rajadas_baixa (EXTERNAL_ID,ACCOUNT_NO, BILL_REF_NO, BILL_REF_RESETS, CHECK_AMOUNT ,DEPOSIT_DT ,GL_AMOUNT ,EXTERNAL_AMOUNT,MSG)
                    VALUES ('999990791857',   2174794,    97875966,               0,        22469,to_date('06/12/2011','dd/mm/yyyy'),      22469, 22469,'SANTANDER')



  select * 
    from payment_trans p,
         gvt_rajadas_baixa g
   where P.ACCOUNT_NO = G.ACCOUNT_NO
     and P.BILL_REF_NO = G.BILL_REF_NO
     
     
   select g.*, g.rowid
     from payment_trans p,
         gvt_rajadas_baixa g
    where P.ACCOUNT_NO = G.ACCOUNT_NO
      and P.BILL_REF_NO = G.BILL_REF_NO;

      
      select g.*, g.rowid from gvt_rajadas_baixa g where BILL_REF_NO in (97853537,97875966) and account_no in (3120918,2263148)
      
      
      select * from all_tables where table_name like '%DACC%' 
      
      
     select * from bmf where account_no in (3120918,2263148)
     
     select * from cmf_balance where account_no in (3120918,2263148)
     
     
     select * from GVT_DACC_HIST_MET_PGTO where external_id in (select external_id from gvt_rajadas_baixa)
     
     select * from GVT_DACC_GERENCIA_MET_PGTO where external_id in (select external_id from gvt_rajadas_baixa)
     
     select * from GVT_DACC_VALIDACAO_BANCOS