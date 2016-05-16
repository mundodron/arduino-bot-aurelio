select external_id,account_no from customer_id_acct_map where external_id in ('777777746383','999985074903','999980014348','999983162696','999985077366')
        
        select * from GVT_CONTA_INTERNET where account_no in (select account_no from customer_id_acct_map where external_id in ('777777746383','999985074903','999980014348','999983162696','999985077366'))
        and bill_ref_no in (153413727)
        and data_processamento > (sysdate - 73)
               
select * from cmf_balance where account_no = 3857518
       
select * from CONTAFACIL_CORP

truncate tabe CONTAFACIL_CORP;

select B.account_no, B.BILL_REF_NO  
from cmf_balance B,
     customer_id_acct_map A
where A.ACCOUNT_NO = B.ACCOUNT_NO
and B.BILL_REF_NO in (145079727,145818906,145828743,145819718,145819102,148846911,148846914,148846929,145079727,148846925,148846922,148846913,148846521,148846927,148846919,148846931,148846916,148846910,148846930,148846928,148846921,148846918,148846924,148846525,148846920,148846529,148846917,148846910,148846913,148834502,148846528,148846502,148832507,148846920,153413743,153413726,153399351,153413727,153413742)
and A.external_id_type = 1
and A.INACTIVE_DATE is null