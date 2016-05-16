truncate table VRC_ALTERA_MOTIVO

CREATE TABLE VRC_ALTERA_MOTIVO
(
  SEQUENCIAL_CHAVE  VARCHAR2(32 BYTE)           NOT NULL,
  STATUS            VARCHAR2(2 BYTE)            NOT NULL,
  TELEFONE_ORIGEM   VARCHAR2(21 BYTE),
  TELEFONE_DESTINO  VARCHAR2(21 BYTE),
  DATA_SERVICO      DATE,
  HORA_INICIO       VARCHAR2(6 BYTE),
  DURACAO           NUMBER(6,1),
  DURACAO_          VARCHAR2(8 BYTE),
  DURACAO_REAL      VARCHAR2(20 BYTE),
  DATA_INSERCAO     DATE,
  TCOE              VARCHAR2(60 BYTE)
);



delete VRC_ALTERA_MOTIVO a where exists (select 1 from grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao
                 and b.status <> 'RJ')
