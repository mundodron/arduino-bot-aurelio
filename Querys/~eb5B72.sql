update GVT_ERRO_CEF G set G.status = (select account_no from customer_id_acct_map where G.CONTA = external_id)

update GVT_ERRO_CEF set valor = to_number (replace(replace(VALOR,'.',''),',',''))


select * from GVT_ERRO_CEF

select *
  from bmf b,
       GVT_ERRO_CEF G,
       customer_id_acct_map M
  where M.EXTERNAL_ID = G.CONTA
  and M.ACCOUNT_NO = B.ACCOUNT_NO
  and G.FATURA = B.BILL_REF_NO
  and M.EXTERNAL_ID_TYPE = 1
  and M.INACTIVE_DATE is null
  and B.DISTRIBUTED_AMOUNT = 0
  
   
select * from customer_id_acct_map where external_id in (select CONTA from GVT_ERRO_CEF)
and external_id_type = 1
and inactive_date is null 


select b.*
 from GVT_ERRO_CEF G,
      BMF b
 where G.STATUS = B.ACCOUNT_NO
   and G.VALOR = B.GL_AMOUNT
   and B.DISTRIBUTED_AMOUNT = 0
   and B.BILL_REF_NO = 0
    
   
   select sum(b.GL_AMOUNT)
 from GVT_ERRO_CEF G,
      BMF b
 where G.STATUS = B.ACCOUNT_NO
   and G.VALOR = B.GL_AMOUNT
   and B.DISTRIBUTED_AMOUNT = 0
   and B.BILL_REF_NO = 0
 

select * from bmf where GL_amount in (select 


to_number (replace(replace(:V_DEBITO,'.',''),',',''))