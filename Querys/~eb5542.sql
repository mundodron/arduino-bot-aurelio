Conta: 999991316826    Fatura: 140010542
Conta: 999991682926    Fatura: 140011914
Conta: 999991682921    Fatura: 140011912
Conta: 999991682930    Fatura: 140011913
Conta: 999980014348    Fatura: 141811210

select * from customer_id_acct_map where external_id in ('777777746383','999980014348','999985074950','999985075065','999985075150','999985075276','999985075310','999985075569','999985075780','999985075934','999985075976','999980014348','999991682921','999991682930','999991682926','999991316826')

select * from cmf_balance where bill_ref_no = 141811210

select * from cmf_balance where bill_ref_no = 141811211

select * from cmf_balance where bill_ref_no = 141811210 

select * from gvt_conta_internet where account_no = 3858364 and bill_ref_no = 133294572--141811211

select * from gvt_conta_internet where account_no = 7374426 order by DATA_PROCESSAMENTO desc

select * from gvt_conta_internet where nome_arquivo is not null
and data_processamento > sysdate - 30 

Marco/3/2013Marco999985074903_250.cdc

Maio/3/2013Maio999985074903_250.cdc
Abril/3/2013Abril999985074903_250.cdc


delete GVT_CONTA_INTERNET where account_no in () and data_processamento > sysdate - 50;

commit;


Insert into GVT_CONTA_INTERNET
   (ACCOUNT_NO, EXTERNAL_ID, BILL_REF_NO, DATA_PROCESSAMENTO, NOME_ARQUIVO, EXISTE_FATURA)
 Values
   (3858364, '999985074903', 141811211, TO_DATE('06/04/2013 23:29:45', 'MM/DD/YYYY HH24:MI:SS'), 'Maio/3/2013Maio999985074903_250.cdc', '1');
Insert into GVT_CONTA_INTERNET
   (ACCOUNT_NO, EXTERNAL_ID, BILL_REF_NO, DATA_PROCESSAMENTO, NOME_ARQUIVO, EXISTE_FATURA)
 Values
   (3858364, '999985074903', 138842913, TO_DATE('08/03/2013 05:17:31', 'MM/DD/YYYY HH24:MI:SS'), 'Abril/3/2013Abril999985074903_250.cdc', '1');
COMMIT;



select sysdate - 50 from dual

08/03/2013 05:17:31