drop table GVT_ERRO_CEF;

CREATE TABLE GVT_ERRO_CEF
(
  CNPJ        VARCHAR2(20),
  DATA        VARCHAR2(20),
  VALOR       VARCHAR2(20),
  CONTA       VARCHAR2(40),
  FATURA      VARCHAR2(20),
  STATUS      VARCHAR2(20)
);

grant all on GVT_ERRO_CEF to public;