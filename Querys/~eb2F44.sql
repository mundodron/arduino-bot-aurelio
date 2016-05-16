SET VERIFY                     OFF;
SET SERVEROUT                  ON SIZE 1000000
SET FEED                       OFF;
SET SPACE                      0;
SET PAGESIZE                   0;
SET LINE                       500;
SET WRAP                       ON;
SET HEADING                    OFF;

/*********************************************************************************************/
-- Variaveis
DECLARE   
         
        rDirArq                                 VARCHAR2(110) := '&2';
        rFileArq                                VARCHAR2(110) := '&1';
        hFileArq                                utl_file.file_type;                     
        vLinhaArquivo VARCHAR2(200);
        
BEGIN
 dbms_output.put_line('Inicio : '|| TO_CHAR(SYSDATE,'YYYYMMD HH24:MI:SS'));
 
 DELETE FROM arborgvt_billing.gvt_contafacil_arquivos; 
 
  hFileArq  := utl_file.fopen(rDirArq,rFileArq,'r');
 
    BEGIN
        LOOP        
            utl_file.get_line(hFileArq, vLinhaArquivo);  
            INSERT INTO arborgvt_billing.gvt_contafacil_arquivos VALUES(vLinhaArquivo);
       END LOOP;
            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           null;
    END; 
 
 COMMIT;
 
  dbms_output.put_line('Fim : '|| TO_CHAR(SYSDATE,'YYYYMMD HH24:MI:SS')); 

END;
/
EXIT; 