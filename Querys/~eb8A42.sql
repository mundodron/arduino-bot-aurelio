CREATE OR REPLACE FORCE VIEW DBAREM.GRC_NAOFATURACONJUNTO
(
  TELEFONE,
  OPERADORA,
  ACTIVE_DT,
  INACTIVE_DT,
  DESCRICAO
)
AS
   SELECT  TELEFONE,
           OPERADORA,
           ACTIVE_DT,
           INACTIVE_DT,
           DESCRICAO
     FROM  GRC_NAOFATURACONJUNTO@DBAREM_DB4CT1;

DROP PUBLIC SYNONYM GRC_NAOFATURACONJUNTO;

CREATE PUBLIC SYNONYM GRC_NAOFATURACONJUNTO FOR DBAREM.GRC_NAOFATURACONJUNTO;

GRANT SELECT, INSERT, UPDATE, DELETE ON DBAREM.GRC_NAOFATURACONJUNTO to COBILLING;

GRANT SELECT ON DBAREM.GRC_NAOFATURACONJUNTO TO R_COBILLING_RO;

GRC_NAOFATURACONJUNTO