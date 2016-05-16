select G.EXTERNAL_ID, G.ACCOUNT_NO, G.BILL_REF_NO, trunc(B.POST_DATE) DT_BAIXA, G.V_PAGO, B.DISTRIBUTED_AMOUNT VL_DISTRIBUIDO, B.BMF_TRANS_TYPE ,D.DESCRIPTION_TEXT, I.BILL_PERIOD, G.NSA
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
 
 
 select * from customer_id_acct_map where external_id = '999992152975'  
   
 select * from cmf where account_no = 1686426 
   
 update cmf set CUST_ADDRESS2 = 'AN 10  AP 1101' where account_no = 1686426;
 update cmf set BILL_ADDRESS2 = 'AN 10  AP 1101' where account_no = 1686426;
 commit;
 

 999989381147    M28    2    39,42    39,42    39,42

 
 select * from gvt_rajadas_bill where account_no is not null and status = 99
 
update gvt_rajadas_bill set 


alter table gvt_rajadas_bill add baixa number(10) NULL

ALTER table add COLUMN gvt_rajadas_bill number(10) NULL

ALTER TABLE [dbo].[phone]
ADD   inactive_date DATETIME NULL  

alter table
   gvt_rajadas_bill
add
   (
   VL_baixa number(10) NULL
   );

select * from gvt_rajadas_bill where external_id = '777777754956'

update gvt_rajadas_bill A set A.vl_baixa = 2045 where A.external_id = '777777754956' and A.account_no = (select account_no from bmf where account_no = A.account_no and bill_ref_no = A.bill_ref_no and DISTRIBUTED_AMOUNT = 0) and external_id = (select external_id from bmf where account_no = A.account_no and bill_ref_no = A.bill_ref_no and DISTRIBUTED_AMOUNT = 0)