DECLARE 
  P_NOME_ARQUIVO VARCHAR2(256);

BEGIN 
  P_NOME_ARQUIVO := 'REM.TCOE.T401100.S01.D010815.H070515.NC.TIM.drbolgr.GO';

  GRCOWN.PROC_CARGA_SP ( P_NOME_ARQUIVO );
  COMMIT; 
END; 


select * from CONTROLE_EXECUCAO_COBILLING order by data_inicio desc

select * from GRC_SERVICOS_PRESTADOS where DATA_INSERCAO > sysdate -1

SELECT dir_unix  FROM grc_processos WHERE processo = 'CAR';


REM.TCOE.T061389.S01.D130914.H084346.NC.BRT.dafoqhj.GO

select * from GRCOWN.GRC_NAOFATURACONJUNTO