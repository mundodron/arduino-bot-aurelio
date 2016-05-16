set serverout on size 1000000;
declare
  --
    qtde_fat number(10) := 0;    qtde_cdr number(10) := 0;   iAccount_no number(10);
  --
    Cursor q1 is
      Select /*+ INDEX (HIS GRC_HIST_SERV_PREST_IDX2) */
               count(1) qtde_cdr,
                     sequencial_arrecadacao  fatura, 
                     grc.parceiro,
                     decode(grc.parceiro, 2, 7, 5, 9, 6, 10, 33, 11, 35, 14, 36, 4, 37, 12, 38, 13, 39, 5, 40, 14) open_item
      from GRC_HISTORICOS_SERV_PRESTADOS  HIS, GRC_SERVICOS_PRESTADOS GRC
     where status_para in ('RI','RA','RP') and DATA_ENVIO_CONTESTADOS is null
           and grc.sequencial_chave = his.servico_prestado
             and grc.nro_nf is null
            group by sequencial_arrecadacao, 
                         grc.parceiro, 
                         decode(grc.parceiro, 2, 7, 5, 9, 6, 10, 33, 11, 35, 14, 36, 4, 37, 12, 38, 13, 39, 5, 40, 14);
  rx q1%rowtype;
  --
    Cursor q2 is
      Select /*+ INDEX (HIS GRC_HIST_SERV_PREST_IDX1) */
               count(1) qtde_cdr,
                     sequencial_arrecadacao  fatura, 
                     grc.parceiro, 
                     decode(grc.parceiro, 2, 7, 5, 9, 6, 10, 33, 11, 35, 14, 36, 4, 37, 12, 38, 13, 39, 5, 40, 14) open_item
      from GRC_HISTORICOS_SERV_PRESTADOS  HIS, GRC_SERVICOS_PRESTADOS GRC
     where status_para in ('F') and DATA_ENVIO_PARCEIRO is null
           and grc.sequencial_chave = his.servico_prestado
             and grc.nro_nf is null
            group by sequencial_arrecadacao, 
                         grc.parceiro, 
                         decode(grc.parceiro, 2, 7, 5, 9, 6, 10, 33, 11, 35, 14, 36, 4, 37, 12, 38, 13, 39, 5, 40, 14);
  --
    Cursor qBill is
      Select account_no
          from bill_invoice
         where bill_ref_no = rx.fatura;
    rxBil qBill%rowtype;
    --
    Cursor qNF is
    Select sin_seq_ref_no nro_nf,
           substr(full_sin_seq,-2,2) uf_nf
      from sin_seq_no
     where bill_ref_no     = rx.fatura
       and bill_ref_resets = 0
       and open_item_id    = rx.open_item;
  rxNF  qNF%rowtype;
    --
    Cursor qSerie is
    Select serie,
           subserie
      from gvt_sinseqno_series sis,
           cmf
     where cmf.account_no   = iAccount_no
       and sis.mkt_code     = cmf.mkt_code
       and sis.open_item_id = rx.open_item;
    rxSerie qSerie%rowtype;
--------------------------------------------------------------------------------
Procedure atualiza is
Begin
      Update grc_servicos_prestados set  nro_nf = rxNF.nro_nf,  uf_nf = rxNF.uf_nf,  serie_nf = rxSerie.serie,  subserie_nf = rxSerie.subserie
             where sequencial_arrecadacao = rx.fatura;
            
            qtde_fat := qtde_fat + 1;
            qtde_cdr := qtde_cdr + rx.qtde_cdr;
            
      -- Drop table vrcx;
            -- Truncate table vrcx;
      -- Create table vrcx (fatura number(10), parceiro number(3), qtde_cdr number(10), nro_nf number(10), uf_nf  varchar2(2), serie varchar2(2), subserie varchar2(2), open_item_id number(2) );
      -- insert into vrcx values (rx.fatura, rx.parceiro, rx.qtde_cdr, rxNF.nro_nf, rxNF.uf_nf, rxSerie.serie, rxSerie.subserie, rx.open_item );
            
End atualiza;
--------------------------------------------------------------------------------
Procedure busca_registros is
Begin

    iAccount_no := null;
        rxNF    := null;
        rxSerie := null;
      Open  qBill;
        Fetch qBill into iAccount_no;
        Close qBill;
        if iAccount_no is null then
          return;
        end if;
        
    --------------------------------------------------------------------------
    -- NOTA FISCAL
        rxNF := null;
    Open  qNF;
    Fetch qNF into rxNF;
    Close qNF;
        if rxNF.nro_nf is null then
          return;
      end if;
        
    --------------------------------------------------------------------------
    -- SÉRIE E SUB-SÉRIE
        rxSerie := null;
    Open  qSerie;
    Fetch qSerie into rxSerie;
    Close qSerie;
        if rxSerie.serie is null then
          return;
      end if;
        
        
    Atualiza;
        
End busca_registros;
--------------------------------------------------------------------------------
begin
  dbms_output.put_line('Inicio do Update da Nota Fiscal na grc_servicos_prestados   --   '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
    --
    FOR r1 in q1 Loop
      rx := r1;
    busca_registros;
  END LOOP;
  
  dbms_output.put_line('qtde_cdr.: '||qtde_cdr || '   -- qtde_fat.: '||qtde_fat);
  COMMIT;
    
    qtde_fat := 0;
    qtde_cdr := 0;
  
  FOR r1 in q2 Loop
      rx := r1;
    busca_registros;
  END LOOP;
  
  dbms_output.put_line('qtde_cdr.: '||qtde_cdr || '   -- qtde_fat.: '||qtde_fat);
  COMMIT;
end;
/
