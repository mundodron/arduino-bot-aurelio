1) Validar se o relat�rio est� ok na SVCPGEN pois ele ser� carregado desta base para DGRC para restante das cargas.
Rodar a query na SVCPGEN:
select tipo_erro, count(*) 
from cdrs_work group by tipo_erro order by count(*) desc;
E comparar com as informa��es do e-mail "Relat�rio - Cen�rio CDW_CONTROLE - R - Relat�rio de CDRs em erro"

Caso tenha alguma suspeita de problema (duplicidade de informa��es, faltar de informa��es) solicitar que a produ��o re-execute a cadeia do relat�rio de CDRs em erro (URGENTE).

Caso o relat�rio esteja atualizado Ok na SVCPGEN:

2) Efetua c�pia do relat�rio para DGRC (Workflow: TMP_CDR_EM_ERRO_COPIA_PGEN_TO_DGRC)

3) Java BSS_PERIODOS_NOBILL (10 minutos)

4) Procedure: CDRS_WORK_ATUALIZA_NOBILL   (AVISAR AO FINAL PARA O CLIENTE QUE O RELAT�RIO EST� ATUALIZADO)

5) Procedure: CDRS_WORK_REDE_E_SEGMENTO (15 minutos)

6) Procedure: CDRS_WORK_ATUALIZA_CENARIO_VLR (30 minutos)

7) Procedure: CDRS_WORK_BACKUP_HISTORICO   (1 minuto)

8) Procedure: CDRS_WORK_ATUALIZA_HISTORICO (15 minutos)

para executar procedures na DGRC usar

SET SERVEROUTPUT ON
begin
CDRS_WORK_REDE_E_SEGMENTO ('tmp');
end;
/

