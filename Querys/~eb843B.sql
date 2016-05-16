select G.CONTA, G.FATURA, G.VALOR
 from GVT_ERRO_CEF G,
      BMF b
 where G.STATUS = B.ACCOUNT_NO
   and G.VALOR = B.GL_AMOUNT
   and B.DISTRIBUTED_AMOUNT = 0
   and B.BILL_REF_NO = 0
   
   select * from GVT_ERRO_CEF
   
   select * from gvt_cmf_rule_acc where CLEARING_HOUSE_ID in (341,1,345)
 