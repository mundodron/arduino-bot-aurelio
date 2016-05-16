/*
select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR where to_date(SUBSTR(CDR_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190

-- Retirar do processo select *  from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE_TRACK where to_date(SUBSTR(SOURCE_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190  

select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL where PROCESSING_DATE < sysdate - 190 

select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE where PROCESSED_DATE < sysdate - 190
*/

SET SERVEROUT ON SIZE 1000000;
SET LINESIZE 180;
SET FEED OFF;
SET TIMING ON;

DECLARE

PROCEDURE EXCLUI_CDR_GVT_PMED_CDR (v_dia varchar2 default null)IS
   type tid_buck is table of PRE_MEDIATION_OWNER.GVT_PMED_CDR.id%TYPE index by binary_integer;
   id_BUCK tid_buck;

   Cursor qCDR_PMED IS
   select ID
     from PRE_MEDIATION_OWNER.GVT_PMED_CDR
    where id < (select max(id)
                  from PRE_MEDIATION_OWNER.GVT_PMED_CDR
                 where to_date(SUBSTR(CDR_FILE_NAME,23,8),'YYYYMMDD') < sysdate -190
                   and PARTITION_TABLE = v_dia);

  i_qt_Write number := 0;   

    
BEGIN
  OPEN qCDR_PMED;
  LOOP
    FETCH qCDR_PMED BULK COLLECT INTO id_BUCK limit 10000; --(limitar o numero de registros)

    exit when id_BUCK.count < 1;

    FORALL r1 IN 1..id_BUCK.count
      Delete from PRE_MEDIATION_OWNER.GVT_PMED_CDR cdw where ID = id_BUCK(r1);

    i_qt_Write := i_qt_Write + id_BUCK.count;

    COMMIT;
    id_BUCK.delete;
  END LOOP;
  CLOSE qCDR_PMED;
  dbms_output.put_line ('Quantidade de cdrs excluidos.: '|| trim(to_char(i_qt_Write, '999g999g990')));
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Erro na execucao >>> '||replace(sqlerrm, chr(10), '; ') );
    if qCDR_PMED%ISOPEN THEN
      CLOSE qCDR_PMED;
    end if;
    RAISE;
END EXCLUI_CDR_GVT_PMED_CDR;

--------------------------
BEGIN
  FOR indice IN 1..31 LOOP
      EXCLUI_CDR_GVT_PMED_CDR(indice);
  END LOOP;
    dbms_output.put_line('Processo Finalizado.' );
END;
/
exit;