SET SERVEROUT ON SIZE 1000000;
SET LINESIZE 180;
SET FEED OFF;
SET TIMING ON;

DECLARE

--------------------------
BEGIN
  FOR indice IN 1..31 LOOP
      delete
        from PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL where PROCESSING_DATE < sysdate - 190 
         and PARTITION_TABLE = indice;
  END LOOP;
    dbms_output.put_line('Processo Finalizado.' );
END;
/
exit;


select * from cmf 