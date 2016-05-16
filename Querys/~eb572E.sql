select * from gvt_rajadas_bill where account_no is not null and status = 99

update gvt_rajadas_bill g set G.ACCOUNT_NO = (select account_no from customer_id_acct_map c where C.INACTIVE_DATE is null and C.EXTERNAL_ID_TYPE = 1 and G.EXTERNAL_ID = c.external_id)



                      customer_id_acct_map c
                      where G.EXTERNAL_ID = C.EXTERNAL_ID
                        and C.INACTIVE_DATE is null
                        and C.EXTERNAL_ID_TYPE = 1

select * 
  from  