            Conta: 999991682926
           Fatura: 145797710

select * from cmf_balance where bill_ref_no =  145797710 --in (140209709,142867113,145828712,137367509,145797708,145797710,145797709)

select * from customer_id_acct_map where account_no = 1729370

select * from GVT_CONTA_INTERNET where account_no = 1729370 and bill_ref_no is null and trunc(DATA_PROCESSAMENTO) > trunc(sysdate - 90)

select * from GVT_CONTA_INTERNET where bill_ref_no is null and DATA_PROCESSAMENTO > trunc(sysdate - 90)

select * from GVT_CONTA_INTERNET where account_no = 145797710 order by Data_processamento