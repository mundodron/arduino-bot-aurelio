declare 

iULTIMA_EXECUCAO     date := null;
  
PROCEDURE BUSCA_ULTIMA_EXECUCAO IS
BEGIN

  
  Select max(data_fim)
    into iULTIMA_EXECUCAO
    from CONTROLE_EXECUCAO_COBILLING
     where status in ('Y','S'); -- status com sucesso RDM9657
     
  
  if iULTIMA_EXECUCAO is null then
     iULTIMA_EXECUCAO := sysdate-14;
  else
     iULTIMA_EXECUCAO := iULTIMA_EXECUCAO-7;
  end if;  
 
     dbms_output.put_line('Ultima execucao deste programa ('||to_char(iULTIMA_EXECUCAO, 'DD/MM/YYYY')||').' );
  

END BUSCA_ULTIMA_EXECUCAO;


    BEGIN

    BUSCA_ULTIMA_EXECUCAO;

    END;