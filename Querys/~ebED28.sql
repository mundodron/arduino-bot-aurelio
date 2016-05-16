select * from GVT_CONTA_INTERNET where trunc(DATA_PROCESSAMENTO) > trunc(sysdate - 30) and NOME_ARQUIVO is null


select trunc(sysdate - 30) from dual

select * from cmf_balance where bill_ref_no = 157956114

select * from cmf_balance where account_no in (3201972,4506412,7894035)

select * from GVT_CONTA_INTERNET where account_no in (3201972,4506412,7894035) and trunc(DATA_PROCESSAMENTO) = trunc(sysdate)