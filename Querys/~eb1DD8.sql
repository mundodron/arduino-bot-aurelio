select * from gvt_rajadas where external_id in ('999985180922','999985565819','999987077251','999987756342','999988319670','999989393026','999989498156','999989517477','999990535694','999990791857')
and account_no is not null

select * from bmf where account_no = 1769357 and orig_bill_ref_no = 98628688

select * from gvt_rajadas_bill where external_id = '999993143149'

select ci.external_id conta,
                            c.account_no,
                            c.bill_ref_no fatura,
                            b.valor,
                            to_date ('14/09/2011','dd/mm/yyyy') dt_baixa
                      from  gvt_rajadas b, 
                            cmf_balance c, 
                            customer_id_acct_map ci
                     where  b.BILL_REF_NO = c.BILL_REF_NO
                       and  c.account_no = ci.account_no
                       and  ci.external_id_type = 1


select G.account_no,
       G.bill_ref_no,
       B.TRANS_AMOUNT,
       to_date ('14/09/2011','dd/mm/yyyy') dt_baixa,
       g.*
  from bmf b,
       gvt_rajadas g
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = G.BILL_REF_NO
   and external_id in ('999985180922','999985565819','999987077251','999987756342','999988319670','999989393026','999989498156','999989517477','999990535694','999990791857')
