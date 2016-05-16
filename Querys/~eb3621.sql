 set serverout on size 10000;
declare
    qt   number(8):=0;
BEGIN
  dbms_output.put_line('INICIO - INC730408');
  --
  execute immediate 'ALTER TRIGGER GRCOWN.TRG_SERV_PRESTADOS DISABLE';
    --
    for r1 in ( Select sequencial_chave, status from VRC_ALTERA_MOTIVO )
    loop
      --
      --
      Update grc_servicos_prestados set status = r1.status_de, informacao = rtrim(informacao||'; ','; ')||'INC730408 (Voltou status de "RJ" "motivo nulo" para "EF")' 
       where sequencial_chave = r1.sequencial_chave;
      --
        qt := qt + 1;
        if mod(qt,500)=0 then
          COMMIT;
      end if;
  end loop;
  COMMIT;
    --
  dbms_output.put_line('chamadas atualizadas..:'||qt);
    --
  execute immediate 'ALTER TRIGGER GRCOWN.TRG_SERV_PRESTADOS ENABLE';
END;
/



