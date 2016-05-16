select G.EXTERNAL_ID, G.ACCOUNT_NO, G.BILL_REF_NO, B.POST_DATE, G.V_PAGO, B.GL_AMOUNT
  from gvt_rajadas_bill g,
       bmf b
 where G.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = G.BILL_REF_NO
   and G.STATUS = 99
   and B.BMF_TRANS_TYPE = 90
   and G.ACCOUNT_NO is not null;
   
   
   
      select sum(v_pago) from gvt_rajadas_bill where nsa <291 and status = 99 and account_no is not null order by nsa 
   
   select EXTERNAL_ID, ACCOUNT_NO, BILL_REF_NO, BAIXA, V_DEBITO, V_PAGO,DT_PAGTO,MSG,NSA, STATUS, count(*)
    from gvt_rajadas_bill where status = 99 and account_no is not null 
   group by (EXTERNAL_ID, ACCOUNT_NO, BILL_REF_NO, BAIXA, V_DEBITO, V_PAGO,DT_PAGTO,MSG,NSA, STATUS)
   
   order by nsa desc
  
 
  select * from customer_id_acct_map where external_id = '999985139421'  
   
   select * from bmf where account_no = 3236643 

select * from gvt_rajadas_bill where external_id = '777777754956'

update gvt_rajadas_bill A set A.vl_baixa = 2045 where A.external_id = '777777754956' and A.account_no = (select account_no from bmf where account_no = A.account_no and orig_bill_ref_no = A.bill_ref_no) and external_id = (select external_id from bmf where account_no = A.account_no and orig_bill_ref_no = A.bill_ref_no and DISTRIBUTED_AMOUNT = 0) 

update gvt_rajadas_bill A set A.vl_baixa = C1 where A.external_id = 'C2' and A.account_no = E2;

update gvt_rajadas_bill set vl_baixa = 0 where external_id = '777777740052' and bill_ref_no = 97326113;

update gvt_rajadas_bill set vl_baixa = 0 where external_id = '777777740052' and bill_ref_no = 97326113;

select * from bmf where orig_bill_ref_no = 97326113




