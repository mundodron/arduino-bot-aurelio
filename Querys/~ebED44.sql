set verify               off;                                               
set serverout            on size 1000000;                                             
set feed                 off;                                                 
set space                0;                                                  
set pagesize             0;                                               
set line                 500;
set wrap                 on;                                                  
set heading              off;

DECLARE

   v_file          UTL_FILE.FILE_TYPE; --Variavel que recebera o status de retorno - Arquivo de LOG
   v_file_type_log UTL_FILE.FILE_TYPE; --Variavel que recebera o status de retorno - Arquivo de LOG
   v_logdir        VARCHAR(100) := '&1';
   v_lognom        VARCHAR(100) := '&2';
   v_nome          VARCHAR(100) := '&3';
   wProc           varchar2(20); -- controle erro: nome proced. em execucao
   v_cont          number(3) := 0;



   --*************************************************************************************
   --Variáveis
   --*************************************************************************************


   CURSOR c IS
      select distinct rtrim(c.file_name) as file_name
        from GVT_FEBRABAN_BILL_FILES d,
             cmf,
             GVT_FEBRABAN_BILL_INVOICe c,
             gvt_febraban_accounts g
       where c.account_no = g.account_no
         and g.account_no = cmf.account_no
         and c.file_name = d.filename
         and d.creation_date >= trunc(sysdate)
         and cmf.bill_lname like '%&3%';



BEGIN

   --dbms_output.put_line('inicio: caminho ' || v_caminho_arquivo_log || ' nome arq ' || v_nome_arquivo_log); 
   v_file := UTL_FILE.FOPEN(v_logdir, v_lognom, 'W');


   select count(*)
     into v_cont
     from GVT_FEBRABAN_BILL_FILES d,
          cmf,
          GVT_FEBRABAN_BILL_INVOICE c,
          GVT_FEBRABAN_ACCOUNTS G
    where c.account_no = g.account_no
      and g.account_no = cmf.account_no
      and c.file_name = d.filename
      and d.creation_date >= trunc(sysdate)
      and cmf.bill_lname like '%&3%';


   dbms_output.put_line(' Contador de Arquivos -> ' || v_cont);

   if v_cont > 0 then
      FOR x IN c LOOP
         BEGIN

         

            utl_file.put_line(v_file,
                             'uuencode ' || x.file_name || '.gz ' ||
                              x.file_name || '.gz ');

         

         EXCEPTION
            WHEN NO_DATA_FOUND then
               dbms_output.put_line('Erro Loop - Não encontrado dados');
            WHEN OTHERS then
               dbms_output.put_line('Erro Loop ->' || sqlerrm || wproc);
         END;
      END LOOP;
   else
      utl_file.put_line(v_file, 'SEM OCORRENCIA');
   end if;

   UTL_FILE.FCLOSE(v_file);

EXCEPTION
   WHEN UTL_FILE.INVALID_PATH then
      dbms_output.put_line('Erro 6 -> UTL_FILE.INVALID_PATH');
   WHEN UTL_FILE.INVALID_OPERATION then
      dbms_output.put_line('Erro 7 -> INVALID_OPERATION');
   WHEN UTL_FILE.WRITE_ERROR then
      dbms_output.put_line('Erro 8 -> WRITE_ERROR');
   when OTHERS then
      dbms_output.put_line('Erro 9 ->' || sqlerrm || wproc);

END;
/

EXIT;
