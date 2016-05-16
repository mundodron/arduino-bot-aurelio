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
   
   
select S.account_no, S.bill_ref_no, S.status, count(*)
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   and B.BMF_TRANS_TYPE = 90
   and S.BILL_REF_NO = 112154440
   group by S.account_no, S.bill_ref_no, S.status
   
   
   
   
   select * from bmf where orig_bill_ref_no = 112154440 and account_no = 3128566
   
   select * from GVT_ERRO_SANTANDER where  account_no = 3128566
   
   select * from antander_diff where status > baixa