
select b.*
  from bmf b,
       gvt_rajadas_baixa g
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.BILL_REF_NO = G.BILL_REF_NO
   and G.STATUS = 1
   
   
    select * from GVT_EXEC_ARG where desc_parametro like '%CLRH_BILL_DEB_AUTOM%'
    
    select * from GVT_EXEC_ARG where NOME_PROGRAMA like '%PL0601%' 