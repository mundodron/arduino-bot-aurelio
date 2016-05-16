select * from customer_id_acct_map where external_id = '999985081812'

select * from service where parent_account_no = 3856302

select * from customer_id_equip_map where SUBSCR_NO = 10042359 



select *
  from customer_id_acct_map a,
       service s,
       customer_id_equip_map c
 where A.ACCOUNT_NO = S.PARENT_ACCOUNT_NO
   and S.SUBSCR_NO = C.SUBSCR_NO
   and S.SUBSCR_NO_RESETS = C.SUBSCR_NO_RESETS
   and A.EXTERNAL_ID = '999987348053'