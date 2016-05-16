select G.EXTERNAL_ID, G.ACCOUNT_NO, G.BILL_REF_NO, trunc(B.POST_DATE), g.DT_PAGTO, G.V_PAGO, B.DISTRIBUTED_AMOUNT VL_DISTRIBUIDO, B.BMF_TRANS_TYPE ,D.DESCRIPTION_TEXT, I.BILL_PERIOD, G.NSA
  from gvt_rajadas_bill g,
       bmf b,
       BMF_TRANS_DESCR S,
       DESCRIPTIONS D,
       bill_invoice i
 where G.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = G.BILL_REF_NO
   and G.STATUS = 99
   and B.BMF_TRANS_TYPE = S.BMF_TRANS_TYPE
   and S.DESCRIPTION_CODE = D.DESCRIPTION_CODE
   and D.LANGUAGE_CODE = 2
   --and B.BMF_TRANS_TYPE = 90
   and G.ACCOUNT_NO is not null
   and G.ACCOUNT_NO = I.ACCOUNT_NO
   and G.BILL_REF_NO = I.BILL_REF_NO
   
   and external_id = '999985139421'
   
   
   select * from gvt_rajadas_bill