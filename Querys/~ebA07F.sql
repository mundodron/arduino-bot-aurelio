update GVT_ERRO_CEF G set G.status = (select account_no from customer_id_acct_map where G.CONTA = external_id)

update GVT_ERRO_CEF set valor = to_number (replace(replace(VALOR,'.',''),',',''))

select * from GVT_ERRO_CEF


select G.CONTA, G.FATURA, G.VALOR
 from GVT_ERRO_CEF G,
      BMF b
 where G.STATUS = B.ACCOUNT_NO
   and G.VALOR = B.GL_AMOUNT
   and B.DISTRIBUTED_AMOUNT = 0
   and B.BILL_REF_NO = 0