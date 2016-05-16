SET SERVEROUT ON SIZE 1000000;
SET LINESIZE 180;
SET FEED OFF;
SET TIMING ON;

DECLARE
--------------------------
BEGIN
  FOR R IN (select SUBSCR_NO from SERVICE_BILLING where PARENT_ACCOUNT_NO = 4273196) LOOP
      delete
        from SERVICE_ADDRESS_ASSOC where SUBSCR_NO = R.SUBSCR_NO 
           and INACTIVE_DT is not null;
           
        commit;  
        
  END LOOP;
    dbms_output.put_line('Processo Finalizado.' );
END;
/
exit;