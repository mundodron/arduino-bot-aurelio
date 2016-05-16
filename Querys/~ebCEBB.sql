update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Agosto/4/2013Agosto777777775034_250.cdc', BILL_REF_NO = 152225726, external_id = '777777775034', existe_fatura = 1 where ACCOUNT_NO = 2856019 and trunc(DATA_PROCESSAMENTO) = to_date('27/07/2013','dd/mm/yyyy');

commit;