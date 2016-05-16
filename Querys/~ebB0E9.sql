 set serverout on size 10000;
declare
    qt   number(8):=0;
BEGIN
  dbms_output.put_line('INICIO - INC823731');
  --
  execute immediate 'ALTER TRIGGER GRCOWN.TRG_SERV_PRESTADOS DISABLE';
    --
    for r1 in ( Select sequencial_chave, status from VRC_ALTERA_MOTIVO )
    loop
      --
      delete grc_historicos_serv_prestados where servico_prestado = r1.sequencial_chave and status_para <> 'AF';
      --
      Update grc_servicos_prestados set status = 'AF', informacao = rtrim(informacao||'; ','; ')||'INC823731 (Voltou status de "RJ" para "AF")' 
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
