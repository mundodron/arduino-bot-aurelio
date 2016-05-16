              select * from cmf_balance
                where bill_ref_no in (1610161442)
                
              select * from cmf_balance where account_no = 290983
                
                select * from customer_id_acct_map where external_id in ('290983')
                
                select * from payment_trans where account_no in (4422710,290983)
                
                
                
                              select * from cmf_balance
                where bill_ref_no in (1610161442,101044712)
                
                select * from customer_id_acct_map where account_no in (4422710,290983)
                
                select * from cmf_balance where account_no in (4422710,290983)
                
                
                                              select * from cmf_balance
                where bill_ref_no in (101044712)
                
-- 999999032971    1610161442    20120125    756    119,45    26/01/2012    Erro - Não há faturas para o cliente SAP 
-- 999997025563    101044712    20120125    104    144,90    26/01/2012    Erro - Não há faturas para o cliente SAP 

select * from payment_trans where bill_ref_no in (1610161442,101044712)


select * from bmf where account_no in (4422710,290983)


select * from payment_trans where account_no in (4422710,290983)

              select * from cmf_balance
                where bill_ref_no in (1610161442,101044712)
                
                
                select * from payment_trans where account_no in (4422710,290983)
                
                
                select * from bmf where bill_ref_no in (1610161442,101044712) and account_no in (4422710,290983)