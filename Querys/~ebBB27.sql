set serverout     on size 1000000;
DECLARE
  SEQUENCIA      NUMBER;
  QTDE           NUMBER := 0;
    UF_ANT         VARCHAR2(3) := 'X';
    OPEN_ITEM_ANT  NUMBER(3) := 0;
    DIFERENCA      NUMBER(5) := 0;
    DIFERENCA_TOT  NUMBER(5) := 0;
    operadora      varchar2(20);
    iSerie         varchar2(2);
    iSubSerie      varchar2(2);
    

  
  CURSOR Q1 IS 
    Select *
          from VRC_NOTAS_FURO_SEQ_BILL
         --where prep_date > '28-feb-2011'
         ORDER BY OPEN_ITEM_ID, UF, SIN_SEQ_REF_NO;
    --
  
  CURSOR Q2 (p_open_item_id NUMBER) IS 
    Select replace(display_value,'GVT Co-billing ',null)
          from open_item_id_values
         where language_code = 2
           and open_item_id = p_open_item_id;
  --
  
  Cursor Q3 (p_uf varchar2, p_open_item_id number) is
   Select  --m.short_display uf, 
           --m.display_value estado, 
                 --replace(v.display_value,'GVT Co-billing ',null) operadora,
                 --s.open_item_id,
                 s.serie,
                 s.subserie
    from mkt_code_values m, 
         open_item_id_values v, 
             gvt_sinseqno_series s
    where v.open_item_id  = s.open_item_id
      and v.language_code = 2
        and m.mkt_code      = s.mkt_code
        and m.language_code = 2
            and m.short_display = p_uf
            and s.open_item_id  = p_open_item_id
     order by s.open_item_id, m.display_value;
  
BEGIN
  SEQUENCIA := 0;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE VRC_FURO_SEQ_COB';
    
  DBMS_OUTPUT.PUT_LINE('INICIO  :  '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') );
  DBMS_OUTPUT.PUT_LINE('------------------------');
    DBMS_OUTPUT.PUT_LINE('SEQ.INI    SEQ.FIM    UF   QTDE.NOTAS   OPEN_ITEM_ID   OPERADORA'||CHR(10)||
                            '--------   --------   --   ----------   ------------   ------------');
    
  FOR R1 IN Q1
  LOOP
      IF UF_ANT <> R1.UF  OR  OPEN_ITEM_ANT <> R1.OPEN_ITEM_ID THEN
          SEQUENCIA := 0;
            UF_ANT := R1.UF;
            OPEN_ITEM_ANT := R1.OPEN_ITEM_ID;
        END IF;
    SEQUENCIA := SEQUENCIA + 1;
    IF SEQUENCIA <> R1.SIN_SEQ_REF_NO THEN
          DIFERENCA  := R1.SIN_SEQ_REF_NO - SEQUENCIA;
            DIFERENCA_TOT := DIFERENCA_TOT + DIFERENCA;
            -------------
            begin
              Open  q2 (r1.open_item_id);
              Fetch q2 into operadora;
              Close q2;
            exception when others then
              DBMS_OUTPUT.PUT_LINE('Erro ao abrir cursor q2');
                DBMS_OUTPUT.PUT_LINE('Oracle..: '||sqlerrm(sqlcode));
                exit;
            end;
            -------------
            begin
              Open  q3 (r1.uf,  r1.open_item_id);
              Fetch q3 into iSerie, iSubSerie;
              Close q3;
            exception when others then
              DBMS_OUTPUT.PUT_LINE('Erro ao abrir cursor q3');
                DBMS_OUTPUT.PUT_LINE('Oracle..: '||sqlerrm(sqlcode));
                exit;
            end;
        -------------
      DBMS_OUTPUT.PUT_LINE(to_char(SEQUENCIA,'999g990')||'   '||
                             to_char(R1.SIN_SEQ_REF_NO-1,'999g990')||'   '||
                             R1.UF||'   '||
                                                         to_char(DIFERENCA,'99999g990')||'   '||
                                                         to_char(r1.open_item_id,'90')||RPAD(' ',12,' ')||
                                                         operadora);
          /*
          CREATE TABLE VRC_FURO_SEQ_COB
            (
              SEQ_INI       NUMBER(10),
              SEQ_FIM       NUMBER(10),
              UF            CHAR(2 BYTE),
              QTDE_NOTAS    NUMBER(10),
              OPEN_ITEM_ID  NUMBER(4),
              OPERADORA     VARCHAR2(50 BYTE),
                serie         VARCHAR2(2),
                subserie      VARCHAR2(2)
            );
            */
      INSERT INTO VRC_FURO_SEQ_COB VALUES (SEQUENCIA, R1.SIN_SEQ_REF_NO-1, R1.UF, DIFERENCA, R1.OPEN_ITEM_ID, OPERADORA, iSerie, iSubSerie);
            
            SEQUENCIA := R1.SIN_SEQ_REF_NO;
      QTDE := QTDE + 1;
    END IF;
  END LOOP;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('=================================');
  DBMS_OUTPUT.PUT_LINE('TOTAL DE NOTAS: '||DIFERENCA_TOT);
  DBMS_OUTPUT.PUT_LINE('FIM');
END;

