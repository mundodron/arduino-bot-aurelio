select * from customer_id_acct_map where external_id = '999985081812'

select * from cmf_balance where account_no = 3856302

select *
 from  CUSTOMER_ID_EQUIP_MAP EQ,
       CUSTOMER_ID_ACCT_MAP EX,
       SERVICE SE
where  EQ.SUBSCR_NO = SE.SUBSCR_NO
  and  EX.EXTERNAL_ID_TYPE = 1
  and  EQ.EXTERNAL_ID_TYPE = 1
  and  EQ.SUBSCR_NO_RESETS = SE.SUBSCR_NO_RESETS
  and  SE.PARENT_ACCOUNT_NO = EX.ACCOUNT_NO
  and  EX.INACTIVE_DATE is null
  and  EQ.INACTIVE_DATE is null
  --and  EQ.EXTERNAL_ID = '4130291517'
  and  EX.EXTERNAL_ID = '999985081812'