SELECT LOG.CHAMADO,
       LOG.DATA,
       TIPO.TIPO,
       DESCR.DESCRICAO,
       DET.DETALHE,
       SUB.SUBDETALHE,
       log.solucao_usuario 
FROM   AUTOMIDIA_WEB_OWNER.AUTOMIDIA_WEB_LOG LOG,
       automidia_web_owner.tipo TIPO, 
       automidia_web_owner.descricao DESCR, 
       automidia_web_owner.detalhe DET, 
       automidia_web_owner.subdetalhe SUB
WHERE LOG.id_tipo = tipo.id
  AND LOG.id_desc = DESCR.ID
  AND LOG.ID_DETALHE = DET.ID
  AND LOG.ID_SUBDETALHE = SUB.ID
  and upper(LOG.SOLUCAO_USUARIO) like '%EIF%'
  
  --AND LOG.id_usuario IN (SELECT * FROM AUTOMIDIA_WEB_OWNER.USUARIOS WHERE AREA = 'SUPORTE-BILLING')--IT-INTEGRACAO /SUPORTE-BILLING
  --AND DATA BETWEEN TO_DATE('01/07/2012 00:00','DD/MM/RRRR HH24:MI') AND SYSDATE ;
  AND LOG.chamado in('GVT413220873');
