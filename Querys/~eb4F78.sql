Create table antander_diff as (
select S.bill_ref_no, S.status, count(*) as baixa
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   and B.BMF_TRANS_TYPE = 90
   group by S.bill_ref_no, S.status)
   

   select * from GVT_ERRO_SANTANDER where bill_ref_no in (
   select bill_ref_no from antander_diff where status > baixa)
   
   update GVT_ERRO_SANTANDER S set S.TELEFONE = 'ND' where S.bill_ref_no = (select bill_ref_no from antander_diff where status > baixa and S.BILL_REF_NO = BILL_REF_NO) 