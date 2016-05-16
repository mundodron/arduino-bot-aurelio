declare 
   v_bill_period             VARCHAR2 (16) := null;
   v_mes                     VARCHAR2 (16) := null;
   v_quant                   NUMBER := null;
   
 cursor c1 is 
                  SELECT *
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE 1=1 --external_id = v_external_id
                     AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND origem IS NULL;
                     
                     
 cursor c2 is
 
                   SELECT *
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE 1 =1 --external_id = v_external_id
                     AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND origem IS NULL
                   group by external_id,status_evento
                   having count(status_evento)>10;

    
 begin 
   for i in C1 loop
       
           dbms_output.put_line(i.external_id);
           
   end loop;
 end;