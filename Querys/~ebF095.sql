select * from cmf_balance where bill_ref_no = 267751480

select * from bill_invoice where ACCOUNT_NO=10258762 order by PREP_DATE desc;

select * from GVT_DETALHAMENTO_CICLO where ACCOUNT_NO=10258762;

select sum(amount+discount)/100 "a faturar" from bill_invoice_detail where bill_ref_no=273468565 and type_code in (2,3,7);

select * from gvt_bankslip where bill_ref_no = 273468565

select CT.EXTERNAL_ID,
       CT.ACCOUNT_NO,
       EQ.EXTERNAL_ID,
       EQ.SUBSCR_NO,
       CT.ACTIVE_DATE,
       CT.INACTIVE_DATE,
       EQ.INACTIVE_DATE INACTIVE_DATE_EQ
  from CUSTOMER_ID_EQUIP_MAP EQ, 
       customer_id_acct_map  CT,
       SERVICE SC
 where CT.ACCOUNT_NO = 4378178 
   and EQ.external_id = '6130218866'
   and EQ.SUBSCR_NO = SC.SUBSCR_NO
   and EQ.SUBSCR_NO_RESETS = SC.SUBSCR_NO_RESETS
   and CT.ACCOUNT_NO = SC.PARENT_ACCOUNT_NO 
   and CT.EXTERNAL_ID_TYPE = 1
   
select parent_account_no from service where subscr_no = 11175153

select * from customer_id_acct_map where ACCOUNT_NO = 4378178

select * from customer_id_acct_map where external_id = '899996247466'

select * from bill_invoice where account_no = 10258762


