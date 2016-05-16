/*

select * from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE where PROCESSED_DATE < sysdate - 190
*/

SET SERVEROUT ON SIZE 1000000;
SET LINESIZE 180;
SET FEED OFF;
SET TIMING ON;

DECLARE

PROCEDURE EXCLUI_CDR IS
   type tid_buck is table of PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE.rowid%TYPE index by binary_integer;
   id_BUCK tid_buck;

   Cursor qCDR IS
   select rowid
     from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE
    where rowid < (select max(rowid)
                  from PRE_MEDIATION_OWNER.GVT_PMED_CDR_PARTIAL
                 where PROCESSING_DATE < sysdate - 190);

  i_qt_Write number := 0;   

    
BEGIN
  OPEN qCDR;
  LOOP
    FETCH qCDR BULK COLLECT INTO id_BUCK limit 10000; --(limitar o numero de registros)

    exit when id_BUCK.count < 1;

    FORALL r1 IN 1..id_BUCK.count
      Delete from PRE_MEDIATION_OWNER.GVT_PMED_CDR_FILE cdw where rowid = id_BUCK(r1);

    i_qt_Write := i_qt_Write + id_BUCK.count;

    COMMIT;
    id_BUCK.delete;
  END LOOP;
  CLOSE qCDR;
  dbms_output.put_line ('Quantidade de cdrs excluidos.: '|| trim(to_char(i_qt_Write, '999g999g990')));
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Erro na execucao >>> '||replace(sqlerrm, chr(10), '; ') );
    if qCDR%ISOPEN THEN
      CLOSE qCDR;
    end if;
    RAISE;
END EXCLUI_CDR;

--------------------------
BEGIN
      EXCLUI_CDR;
    dbms_output.put_line('Processo Finalizado.' );
END;
/
exit;