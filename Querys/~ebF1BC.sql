select EXTERNAL_ID, ACCOUNT_NO, BILL_REF_NO, BAIXA, V_DEBITO, V_PAGO, DT_PAGTO, MSG, NSA, STATUS--, count(*)
  from gvt_rajadas_bill
 where account_no is not null
   and status = 99
 group by (EXTERNAL_ID, ACCOUNT_NO, BILL_REF_NO, BAIXA, V_DEBITO, V_PAGO, DT_PAGTO, MSG, NSA, STATUS)
HAVING COUNT(*) > 1
order by NSA

select * from bmf where account_no = 2078336 and orig_bill_ref_no = 96455381 and orig_bill_ref_no in (select bill_ref_no from gvt_rajadas_bill)


select G.EXTERNAL_ID, G.ACCOUNT_NO, G.BILL_REF_NO, trunc(B.POST_DATE) DT_BAIXA, G.V_PAGO, B.DISTRIBUTED_AMOUNT VL_DISTRIBUIDO, B.BMF_TRANS_TYPE ,D.DESCRIPTION_TEXT, I.BILL_PERIOD
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
   and G.VL_BAIXA = 0

select bill_period from bill_invoice 
   
   
   select * from all_tables where table_name like '%DESCRIPTIONS%' 
   
   select * from BMF_TRANS_DESCR
   
      select * from DESCRIPTIONS where DESCRIPTION_CODE = 23302
      
      
      select external_id, bill_ref_no, count(1) from gvt_rajadas_bill where account_no is not null and status = 99 and VL_BAIXA <> 0
      group by external_id, bill_ref_no
      having count(1) > 1
      
      
      select * from gvt_rajadas_bill where account_no is not null and status = 99 and VL_BAIXA <> 0
      
      group by external_id, bill_ref_no
      having count(1) > 1
      
      
      select a.*, rowid from gvt_rajadas_bill a where a.external_id = '999987844056' -- 13270











      
      
   
   