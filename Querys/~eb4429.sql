
      SELECT C.ACCOUNT_NO, C.BILL_REF_NO, C.PAYMENT_DUE_DATE
      FROM   CDC_PROCESSAR_BACKLOG C
      WHERE  C.account_category not in (9,10,11)
       and   C.processo = 1;
       
       select * from GVT_CONTAS_CONTAFACIL where account_no = 3858364
       
         SELECT *--C.ACCOUNT_NO
      FROM   CMF C , 
             GVT_CONTAS_CONTAFACIL G
      WHERE  C.ACCOUNT_NO = G.ACCOUNT_NO 
       AND   C.ACCOUNT_TYPE = 1
       and   C.ACCOUNT_NO = 3858364
       AND   G.account_category in (&5)
       and   G.processo = &6;

select * from GVT_CONTA_INTERNET where account_no = 3858364 and bill_ref_no in (144714550,141811211,138842913,136203175)

--delete GVT_CONTA_INTERNET where account_no = 3858364 and bill_ref_no in (144714550,141811211,138842913,136203175);

commit;


insert into CDC_PROCESSAR_BACKLOG
select ACCOUNT_NO, BILL_REF_NO, PAYMENT_DUE_DATE, 1 processo, ( select ACCOUNT_CATEGORY from cmf c where c.account_no = b.account_no ) account_category 
from bill_invoice b
where bill_ref_no in (144714550,141811211,138842913,136203175);