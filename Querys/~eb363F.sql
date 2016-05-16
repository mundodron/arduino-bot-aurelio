-- update gvt_itau g set g.account_no = (select account_no from customer_id_acct_map where external_id = G.EXTERNAL_ID and inactive_date is null)

select count(*) from gvt_itau where account_no is not null

-- update gvt_itau g set g.status = (select BILL_PERIOD from cmf where account_no = G.account_no)


   select * from customer_id_acct_map where external_id in ('999984877725','999988141323','999989740490','999989831748','999984122421','999999098364','999984349521','999989745103','999993402583','999984788762','999990881393','999987919840','999987759158','999983022632','999987849620','999985280987','999983075008','999983606675','999987936772','999987166728','999985968492');

   select * from customer_id_acct_map where external_id = '999982598050'
   
   
      select * from bmf where account_no = 2901896
      and ACTION_CODE = 'APP'
         and TRANS_DATE = to_date('2012/04/20', 'yyyy/mm/dd')
         
      select * from bmf where bill_ref_no = 106723828 and account_no = 2901896
      
      
      select * from bmf where bill_ref_no = 109037558 and account_no = 4584324
        