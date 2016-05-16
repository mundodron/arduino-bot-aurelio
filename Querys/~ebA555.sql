-- update gvt_itau g set g.status = (select BILL_PERIOD from cmf where account_no = G.account_no)

select * from gvt_itau where account_no is not null


select B.ACCOUNT_NO, B.ORIG_BILL_REF_NO, B.BILL_REF_NO, B.BMF_TRANS_TYPE, B.GL_AMOUNT, count(1)
  from bmf B,
       gvt_itau G
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.ACTION_CODE = 'APP'
   and B.TRANS_DATE = to_date('20/04/2012', 'dd/mm/yyyy')
   group by (B.ACCOUNT_NO, B.ORIG_BILL_REF_NO, B.BILL_REF_NO, B.BMF_TRANS_TYPE, B.GL_AMOUNT) having count(1) > 1
   
   
select B.ACCOUNT_NO, B.ORIG_BILL_REF_NO, B.BILL_REF_NO, B.BMF_TRANS_TYPE, B.GL_AMOUNT,B.TRANS_DATE, count(1)
  from bmf B,
       gvt_itau G
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.ACTION_CODE = 'APP'
   and B.BMF_TRANS_TYPE in (1,-161)
   and B.TRANS_DATE = to_date('20/04/2012', 'dd/mm/yyyy')
   group by (B.ACCOUNT_NO, B.ORIG_BILL_REF_NO, B.BILL_REF_NO, B.BMF_TRANS_TYPE, B.GL_AMOUNT,B.TRANS_DATE) having B.ORIG_BILL_REF_NO > 1
   
   select * from bmf where account_no = 999988119598
      and ACTION_CODE = 'APP'
         and TRANS_DATE = to_date('2012/04/20', 'yyyy/mm/dd')
   
   
   and B.ACCOUNT_NO = 4003936
   
   and B.ORIG_BILL_REF_NO = G.BILL_REF_NO
   
   and B.BMF_TRANS_TYPE = -162
   
   select * from customer_id_acct_map where external_id = '999982598050'
   -- update gvt_itau g set g.status = (select BILL_PERIOD from cmf where account_no = G.account_no)
   
   
select * from gvt_itau where account_no is not null
      
select * from bmf where bill_ref_no = 109037558 and account_no = 4584324
   
select count(*) from gvt_itau where account_no is not null

select count(*) from gvt_itau where account_no is not null


select * from all_tables where owner = 'G0023421SQL'


select * from payment_trans 