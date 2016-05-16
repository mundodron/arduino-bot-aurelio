

CREATE TABLE GVT_ERRO_SANTANDER
(
  EXTERNAL_ID       VARCHAR2(14),
  ACCOUNT_NO        NUMBER(10),
  BILL_REF_NO       NUMBER(12),  
  VALOR             NUMBER(10),
  CPF               VARCHAR2(15),
  STATUS            NUMBER(1),
  MSG               VARCHAR2(150)
);



select * from GVT_ERRO_SANTANDER where BILL_PERIOD = 'M28'

--- truncate table GVT_ERRO_SANTANDER

select * from customer_id_acct_map where external_id = '999986225950'

update GVT_ERRO_SANTANDER S set S.CPF = (select CONTACT1_PHONE from GVT_LOTERICA_CONSULTA_CPFCNPJ where S.EXTERNAL_ID = external_id)

update GVT_ERRO_SANTANDER S set S.BILL_PERIOD = (select BILL_PERIOD from cmf where S.account_no = account_no)

select * from GVT_ERRO_SANTANDER where account_no is not null

select * from GVT_LOTERICA_CONSULTA_CPFCNPJ

select * from GVT_ERRO_SANTANDER

ALTER TABLE GVT_ERRO_SANTANDER 
ADD (TELEFONE VARCHAR2(20));


select S.ACCOUNT_NO, S.BILL_REF_NO, sum(B.GL_AMOUNT), count(*)
  from GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
      and external_id = '999984786425'
 group by S.ACCOUNT_NO, S.BILL_REF_NO
 
 select S.*
  from GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   and external_id = '999984786425'