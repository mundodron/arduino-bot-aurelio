 select c.CLOSED_DATE, b.trans_amount, b.account_no, b.orig_bill_ref_no , b.tracking_id
    from bmf b,
            cmf_balance  c
where b.account_no = 1982210 -- in (2100394)--,1982210,897004)
and b.trans_amount = 54236 -- in (14990) --,54236,17399,24694)
and b.account_no = c.account_no
and C.CLOSED_DATE is null
and b.DISTRIBUTED_AMOUNT = 0

and b.bmf_trans_type <>90

select * from customer_id_acct_map where account_no = 2100394

select * from all_tables where table_name like '%TRAN%' 

select to_date ('15/10/2011','DD/MM/YYYY') from dual

select * from cmf_balance 

select * from bmf where ACTION_CODE = 'API'

update bmf set ACTION_CODE = 'APP' where source_id in (8259734,8260020,8259665)
and orig_bill_ref_no in (94351552,94351593,94351958)
and ACTION_CODE = 'API'

select * from bmf where source_id in (8259734,8260020,8259665)
and orig_bill_ref_no in (94351552,94351593,94351958)
and ACTION_CODE = 'API'

http://extra.globo.com/noticias/celular-e-tecnologia/carrinho-de-controle-remoto-mais-rapido-mundo-vai-de-0-100-kmh-em-23-segundos-3399818.html


GVT_ONBILL_ACCOUNT_CUTOFF


    select count(*) from gvt_rajadas where status = 99 and account_no is not null
    
    
       select * from gvt_rajadas where status = 77
       
       
                  select * from gvt_rajadas where status in (99,77) and account_no is not null
                  
                   select * from gvt_rajadas where status in (99,77) and account_no is not null
                   
                