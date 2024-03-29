E TABLE
CREATE TABLE ARBOR.GVT_NO_BILL_AUDIT
(
  ACCOUNT_NO   NUMBER(10),
  BILL_PERIOD  VARCHAR2(3),
  OLD_REMARK   VARCHAR2(240),
  NEW_REMARK   VARCHAR2(240),
  CHG_WHO      CHAR(30),
  CHG_DATE     DATE,
  OLD_NO_BILL  NUMBER(1),
  NEW_NO_BILL  NUMBER(1),
  CREATED      DATE
);

--CRIA��O INDICES
CREATE INDEX ARBOR.IDX_ACCOUNT_NO ON ARBOR.GVT_NO_BILL_AUDIT (ACCOUNT_NO);
CREATE INDEX ARBOR.IDX_CHG_DATE ON ARBOR.GVT_NO_BILL_AUDIT (CHG_DATE);
CREATE INDEX ARBOR.IDX_CREATED ON ARBOR.GVT_NO_BILL_AUDIT (CREATED);

--SYNONIM
CREATE PUBLIC SYNONYM GVT_NO_BILL_AUDIT FOR ARBOR.GVT_NO_BILL_AUDIT ;

--GRANT SELECT PARA GRUPO IT
GRANT SELECT ON GVT_NO_BILL_AUDIT  TO R_ITBILLING_RO;


--GRANT SELECT, INSERT PARA BILLING PRODU��O
GRANT SELECT, INSERT, UPDATE ON GVT_NO_BILL_AUDIT  TO R_ARBOR_PROD;