select * 
  from gvt_rajadas_bill g,
       bmf b
 where g.account_no is not null and g.status = 99
 and   G.ACCOUNT_NO = B.ACCOUNT_NO
 and   G.BILL_REF_NO = B.BILL_REF_NO
 and   B.BILL_REF_RESETS = 

select * from bmf 