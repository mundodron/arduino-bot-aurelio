            Conta: 999991682921
           Fatura: 145797708

select * from cmf_balance where bill_ref_no =  145797708 --in (140209709,142867113,145828712,137367509,145797708,145797710,145797709)

select * from customer_id_acct_map where account_no = 1729370

select * from GVT_CONTA_INTERNET where account_no = 1729370 and bill_ref_no is null and trunc(DATA_PROCESSAMENTO) > trunc(sysdate - 90)

select * from GVT_CONTA_INTERNET where bill_ref_no = 140209709

select * from GVT_CONTA_INTERNET where account_no = 1729370 order by Data_processamento