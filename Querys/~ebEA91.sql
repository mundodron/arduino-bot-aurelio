CREATE TABLE GVT_VAL_LOG_EIF
(
  EIF      VARCHAR2(10 BYTE),
  INICIO   VARCHAR2(30 BYTE),
  FIM      VARCHAR2(30 BYTE),
  BILL_REF_NO   NUMBER(12)
); 

select * from GVT_VAL_LOG_EIF


select * from grc_motivos where codigo = '361'

delete from GRCOWN.grc_motivos where codigo = '361';

commit;

select * from grc_motivos

select * from grc_motivos_arbor where codigo = '361'