DROP TABLE ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS;

CREATE TABLE ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS
(
  SERVICE_NUMBER  VARCHAR2(15 BYTE),
  ACTIVE_DATE     DATE,
  INACTIVE_DATE   DATE,
  RANKING         NUMBER(10),
  DESCRIPTION     VARCHAR2(55 BYTE)
);

CREATE INDEX ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS_MP_idx1 on ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS(RANKING, SERVICE_NUMBER, ACTIVE_DATE);

DROP PUBLIC SYNONYM GVT_CAMPANHAS_EPECIAIS;

CREATE PUBLIC SYNONYM GVT_CAMPANHAS_EPECIAIS FOR ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS;

GRANT SELECT ON ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS TO R_ITBILLING_RO;

GRANT SELECT ON ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS TO R_ARBOR_PROD;

GRANT SELECT ON ARBORGVT_BILLING.GVT_CAMPANHAS_EPECIAIS TO ARBOR;
