- Agendar a execu?ao do script abaixo no controlM para todos os proximos 31 dias at? que ele termine.

------------------------- Delete de tabelas do madiation
delete
from PRE_MEDIATION_OWNER.GVT_PMED_CDR where to_date(SUBSTR(CDR_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190
and PARTITION_TABLE = to_char(sysdate + 1, 'DD');

commit;

-- Retirar do processo select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE_TRACK where to_date(SUBSTR(SOURCE_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190 

delete
from PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL where PROCESSING_DATE < sysdate - 190 
and PARTITION_TABLE = to_char(sysdate + 1, 'DD');

commit;

delete from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE where PROCESSED_DATE < sysdate - 190;

commit;
------------------------ FIM
2- Em caso de aborte restartar o processo e enviar o sysout para o analista

3- apos o termino do da execu?ao do script solicitar ao DBA o rebuild das tabelas abaixo:

PRE_MEDIATION_OWNER.GVT_PMED_CDR
PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL
PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE
