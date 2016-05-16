Drop table GVT_CDBARRAS;

CREATE TABLE GVT_CDBARRAS
(
  EXTERNAL_ID  VARCHAR2(12 BYTE),
  BILL_REF_NO  NUMBER(12),
  VALOR        VARCHAR2(10),
  STATUS       VARCHAR2(2),
  MSG          VARCHAR2(120 BYTE)
);

truncate table GVT_CDBARRAS

select * from GVT_CDBARRAS where bill_ref_no in (select bill_ref_no from cmf_balance where bill_ref_no = 141593951)

update GVT_CDBARRAS set status = 1 where external_id in (select external_id from customer_id_acct_map where inactive_date is null)

select count(*) from GVT_CDBARRAS where status = '1' and bill_ref_no in (select bill_ref_no from cmf_balance where closed_date is not null)