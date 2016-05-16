select * from cmf_balance where bill_ref_no = 14207756

select * from cmf_balance where bill_ref_no = 14207756

create table GVT_CDBARRAS
  ( EXTERNAL_ID  VARCHAR2(12),
    BILL_REF_NO  NUMBER(12),
    VALOR        NUMBER(10),
    STATUS       NUMBER(2),
    MSG          VARCHAR2(120))