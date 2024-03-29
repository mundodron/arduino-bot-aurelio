

CREATE TABLE GRCOWN.GRC_NAOFATURACONJUNTO
(
  TELEFONE     VARCHAR2(10 BYTE),
  OPERADORA    VARCHAR2(3 BYTE),
  ACTIVE_DT    DATE,
  INACTIVE_DT  DATE,
  DESCRICAO    VARCHAR2(70 BYTE)
);

CREATE INDEX GRCOWN.NAOFATURACONJUNTO_PK ON GRCOWN.GRC_NAOFATURACONJUNTO
(ACTIVE_DT)
LOGGING
TABLESPACE ARBOR_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

