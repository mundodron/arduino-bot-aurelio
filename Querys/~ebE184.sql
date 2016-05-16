CREATE OR REPLACE PROCEDURE grcown.proc_envia_parceiro_gv2eotag
   (
     p_parceiro      IN    NUMBER,
     p_nome_arq_log  IN    VARCHAR2
   )
IS
/******************************************************************************
 NAME: PROC_ENVIA_PARCEIRO_GRUPO
 PURPOSE: Realizar o processo de Envio dos CDR's que tiveram alteracao de status para os
 parceiros no layout do Grupo de Co-Billing atualizado em 06/07/03.
 Esta versao da Proc agrupa todas as chamadas peloe grupo definido na tabela GRC_EOT_OPERADORAS
 a partir do codigo do parceiro, gerando um arquivo por EOT agrupador.
 REVISIONS:
-----------------------------------------------------------------------------------------------------
VERSÃO  AUTOR:               DATA:       DOC:        RDM       MOTIVO:
------  -------------------- ----------- ----------- --------- --------------------------------------
 1.0    Dalton               10/03/2004                        Criacao do procedimento.
 1.1    Valter Rogério       19/07/2010  RFC 234249            Para a Embratel, o nome do arquivo é diferente.
 1.2    Jhony Cardoso        19/01/2012  RFC 339927            Correção no preenchimento da UF da Nota Fiscal.
 1.3    Jhony Cardoso        15/06/2012  RFC 364933            Correção de arquivos enviados apenas com Header e Trailler.
 1.4    Valter Ciolari       19/11/2013  PROB251507            GVTPM-50250 - Acrescentado o nro de protocolo
 1.5    Valter Ciolari       20/10/2014  PROB697803  RDM11708  Ignorar o status "RA" nas querys.
 1.6    Aurelio Avanzi       05/03/2015  RDM16716              Enviar nome do arquivo completo (TCOE) e troca da View GRCOWN.GRC_V_ENVIA_PARCEIRO pelas tabelas fisicas.
 ******************************************************************************/

 v_seq_remessa       NUMBER; -- Sequencial da remessa
 v_seq_interface     NUMBER; -- Sequencial de interface
 v_data_envio_parc   DATE := TRUNC(SYSDATE);
 erro                NUMBER := 0;
 p_reclamacao        VARCHAR2(8) ;
 p_remessa           VARCHAR2(26) ;
 v_nome_cliente      VARCHAR2(200);
 v_cpf_cnpj          VARCHAR2(200);
 v_motivo            VARCHAR2(5) ;
 v_nro_reclamacao    VARCHAR2(8) ;
 v_tipo_arq          VARCHAR2(3) ;
 v_nome_arquivo      VARCHAR2(100);
 v_eot               VARCHAR2(3);

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
CURSOR C_HEADER(p_eot_filial VARCHAR2)
IS
 SELECT TO_CHAR(min(DATA_SERVICO),'DDMMYYYY') ||
        TO_CHAR(max(DATA_SERVICO),'DDMMYYYY') LINHA --(44,250)- Filler
   FROM GRC_V_ENVIA_PARCEIRO
  WHERE PARCEIRO = p_parceiro
    AND STATUS_PARA NOT IN ('RI','RP','RA','DE','RJ','P','EF')
    AND DATA_ENVIO_PARCEIRO IS NULL
    AND EOT_FILIAL in ( SELECT EOT
                          FROM GRC_EOT_OPERADORAS
                         WHERE EOT_AGRUPADOR = p_eot_filial
                           AND PARCEIRO = p_parceiro
                           AND (DATA_INATIVACAO IS NULL OR DATA_INATIVACAO >= SYSDATE)
                      );

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
-- O Tamanho da linha retornada pelo cursor deverá ser de 251
CURSOR C_DETAIL (p_eot_filial VARCHAR2)
IS
SELECT 'SP' TABELA,
       SP.TELEFONE_ORIGEM,
       SP.DATA_SERVICO,
       HI.STATUS_PARA,
       HI.MOTIVO,
       SP.CSP,
       SP.COD_SEQ_TFI,
       SP.SEQUENCIAL_ARRECADACAO,
       decode(trim(SP.PAIS_DESTINO),null,'1','2') || -- Cod. Registro
       RPAD(NVL(SP.TELEFONE_ORIGEM,' '),21,' ') || -- Assinate A
       RPAD(NVL(SP.PAIS_DESTINO,' '),3,' ') || -- Cód. do País
       RPAD(NVL(SP.TELEFONE_DESTINO,' '),21,' ') || -- Assinate B
       RPAD(NVL(SP.TELEFONE_ORIGEM,' '),21,' ') || -- Terminal de cobrança
       RPAD(NVL(TO_CHAR(SP.DATA_SERVICO,'DDMMYYYY'),'0'),8,'0') || -- Data da chamada
       LPAD(nvl(SP.HORA_INICIO,'0'),6,'0') || -- Hora início da chamada
       LTRIM(NVL(TO_CHAR(SP.duracao*10,'09999'),'00000')) || -- Duração da chamada
       NVL(FUNC_CONV_STATUS(SP.PARCEIRO,HI.STATUS_PARA),' ') || -- Motivo do Evento
       rpad(' ',3,' ') || -- Cód. motivo do evento
       DECODE(HI.STATUS_PARA,'AF',NVL(TO_CHAR(HI.DATA_ALTERACAO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'EF',NVL(TO_CHAR(SP.DATA_ENVIO_FAT, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'F' ,NVL(TO_CHAR(SP.DATA_EMISSAO_FATURA,'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'A' ,NVL(TO_CHAR(SP.DATA_RECEBIMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RI',NVL(TO_CHAR(SP.DATA_COBRANCA_RI, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RP',NVL(TO_CHAR(SP.DATA_COBRANCA_RI, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'R' ,NVL(TO_CHAR(SP.DATA_REPASSE, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'DE',NVL(TO_CHAR(SP.DATA_CANCELAMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'RJ',NVL(TO_CHAR(SP.DATA_CANCELAMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       'PA',NVL(TO_CHAR(SP.DATA_RECEBIMENTO, 'DDMMYYYY'),TO_CHAR(sysdate,'DDMMYYYY')),
       TO_CHAR(SYSDATE,'DDMMYYYY')) || -- Data do Evento
       rpad(' ',15,' ') || -- Numero da reclamação
       lpad('0',18,'0') || -- Nro contrato parcelamento
       rpad(' ',10,' ') || -- Numero da Nota Fiscal
       rpad(' ',02,' ') || -- Serie da Nota Fiscal
       LTRIM(REPLACE(TO_CHAR(NVL(SP.VALOR_FATURADO, '0'),'09999.00000'),'.',''))|| -- Valor Liquido
       LTRIM(REPLACE(TO_CHAR(NVL(SP.VALOR_BRUTO/100,'0'),'09999.00000'),'.',''))|| -- Valor Bruto
       NVL(TO_CHAR(SP.DATA_VENCIMENTO,'DDMMYYYY'),'00000000') || -- Data Vcto da Chamada
       rpad(' ',02,' ') || -- UF emissor da Nota Fiscal
       RPAD(NVL(TO_CHAR(SP.DATA_EMISSAO_FATURA,'DDMMYYYY'),'0'),08,'0') || -- Data Emissão da conta
       RPAD(NVL(substr(SP.tcoe,5),SP.lote || '.NC'),35,' ') || -- Dsname (nome arq. remessa)
       LPAD(SP.COD_SEQ_TFI,7,'0') || -- Identificador do Reg. no Lote
       LPAD(' ',27,' ') || -- Filler
       '0' linha_arq,
       SP.SEQUENCIAL_CHAVE,
       SP.LOTE,
       HI.ROWID CHAVE,
       SP.VALOR_FATURADO
     FROM   GRC_SERVICOS_PRESTADOS SP, GRC_HISTORICOS_SERV_PRESTADOS HI
    WHERE   SP.SEQUENCIAL_CHAVE = HI.SERVICO_PRESTADO
      AND   SP.PARCEIRO = p_parceiro
      AND   HI.STATUS_PARA NOT IN ('RI','RP','RA','DE','RJ','P','EF') --Restrição para contest external_id Rejeit. irem em arq. separados
      AND   HI.DATA_ENVIO_PARCEIRO IS NULL
      AND   SP.EOT_FILIAL in ( SELECT EOT
                                 FROM GRC_EOT_OPERADORAS
                                WHERE EOT_AGRUPADOR = p_eot_filial
                                  AND PARCEIRO = p_parceiro
                                  AND (DATA_INATIVACAO IS NULL OR DATA_INATIVACAO >= SYSDATE)
                             );

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
-- Cursor lista todas as EOTs_AGRUPADORAS da operadora para particionar o arquivo por EOTs Origem(GVT)/Destino(Contratante).
CURSOR C_LISTA_EOT_AGRUPADOR
IS
SELECT DISTINCT EOT_AGRUPADOR
  FROM GRC_EOT_OPERADORAS
 WHERE PARCEIRO = p_parceiro
   AND (DATA_INATIVACAO IS NULL OR DATA_INATIVACAO >= SYSDATE);


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
-- Busca dados relativos ao processo, para efeito de envio de mensagem e caminhos dos arquivos
CURSOR c_Processo IS
SELECT responsavel, dir_unix, dir_nt
FROM grc_processos
WHERE processo = 'PAR'; -- PAR = Envio de serviços ao parceiro.


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
CURSOR curProcesso_LOG IS
SELECT dir_unix
FROM grc_processos
WHERE processo = 'LOG';


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
-- Busca dados do administrador do sistema, caso o cursor acima nao obtenha sucesso
CURSOR curParametro IS
SELECT administrador
FROM grc_parametros;


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
-- Busca o CSP e as eots do parceiro.
CURSOR C_DADOS_PARC IS
SELECT TO_CHAR(CSP) CSP, EOTS
FROM GRC_PARCEIROS
WHERE CODIGO = p_parceiro;


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
--Variaveis
 v_csp VARCHAR2(2);
-- v_eot VARCHAR2(3);
 v_header C_HEADER%rowtype;
 v_data_inicio_proc DATE;
 v_data_fim_proc DATE;
 v_eots grc_parceiros.eots%type;
 cResponsavel grc_processos.responsavel%TYPE;
 cDirUnix grc_processos.dir_unix%TYPE;
 cDirNT grc_processos.dir_nt%TYPE;
 cDirUnix_log grc_processos.dir_unix%TYPE;
 arq_envio UTL_FILE.FILE_TYPE;
 arq_log UTL_FILE.FILE_TYPE;
 v_linha_arq VARCHAR2(400);
 v_nro_lidos NUMBER := 0;
 v_nro_gravados NUMBER := 0;
 v_nro_erros NUMBER := 0;
 v_obs VARCHAR2(300);
 v_status_exec VARCHAR2(1) := 'S';
 v_nro_nf VARCHAR2(10);
 v_serie_nf varchar2(10);
 v_subserie_nf varchar2(3);
 v_valor_chamadas FLOAT;
 v_seq_arquivo NUMBER(2) := 0 ; -- Sequencial de geração do arquivo.
 v_open_item_id grc_providers.open_item_id%TYPE;
 c_data_arquivo VARCHAR2(16) := TO_CHAR(SYSDATE,'DDMMYY')||'.H'||TO_CHAR(SYSDATE,'HH24MISS');
 v_existe_eot_destino NUMBER;
 V_EXISTE_REG BOOLEAN := FALSE;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷--
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ I N I C I O ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷--
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷--
BEGIN
    -- parametros do processo
 OPEN c_Processo;
 FETCH c_Processo INTO cResponsavel, cDirUnix, cDirNT;
 CLOSE c_Processo;

 IF (cResponsavel IS NULL) THEN
     OPEN curParametro;
     FETCH curParametro INTO cResponsavel;
     CLOSE curParametro;
 END IF;

 OPEN curProcesso_log;
 FETCH curProcesso_log INTO cDirUnix_log;
 CLOSE curProcesso_log;

 OPEN C_DADOS_PARC;
 FETCH C_DADOS_PARC INTO v_csp,v_eots;
 CLOSE C_DADOS_PARC;

 -- v_data_inicio_proc := SYSDATE;
 cDirUnix := cDirUnix;-- || v_csp;
 Arq_log := utl_file.fopen(cDirUnix_Log , p_nome_arq_log, 'A');
 utl_file.put_line(Arq_log, 'Arquivo de Log do processo de envio de retorno para o Parceiro...');
 utl_file.put_line(Arq_log, 'Hora e data da criacao: ' || TO_CHAR(SYSDATE, 'HH24:MI:SS DD/MM/YYYY'));
 utl_file.put_line(Arq_log, '');

    --Verifica se existe EOTs destino cadastrados na tabela GRC_EOT_OPERADORAS para o parceiro corrente.
 open C_LISTA_EOT_AGRUPADOR;
 fetch C_LISTA_EOT_AGRUPADOR into v_existe_eot_destino;

     if C_LISTA_EOT_AGRUPADOR%notfound then
        v_existe_eot_destino := 0;
        utl_file.put_line(Arq_log, 'Nao foi encontrado cadastro de EOT_DESTINO em GRC_EOT_OPERADORAS para o parceiro '||p_parceiro );
        utl_file.FClose(Arq_log);
        RAISE_APPLICATION_ERROR (-21020, ' EOT nao encontrado na tabela GRC_EOT_OPERADORAS para o parceiro ' || p_parceiro);
     else
        v_existe_eot_destino := 1;
     end if;
 close C_LISTA_EOT_AGRUPADOR;

 utl_file.FClose(Arq_log);

 --Retorna o sequqncial de geração do arquivo ( Um sequencial/dia)
 -- RFC 234249
 if p_parceiro = 38 then -- EMBRATEL
    v_seq_arquivo := FUNC_NEXT_SEQUENCE(p_parceiro,'ART',3); -- sequencial começa com 1.
 else
    v_seq_arquivo := FUNC_NEXT_SEQUENCE(p_parceiro,'ART',2); -- sequencial começa com 0.
 end if;

 -- Seleciona as EOTs agrupadoras
 FOR v_lista_eot_agrup in C_LISTA_EOT_AGRUPADOR LOOP
     v_data_inicio_proc := SYSDATE;
     --Retorna o sequqncial de geração de Header (Um sequencial/Arquivo(Header))
     v_seq_remessa := FUNC_NEXT_SEQUENCE(p_parceiro,'RET',1);
     Arq_log := utl_file.fopen(cDirUnix_Log , p_nome_arq_log, 'A');
     v_eot := '141';
     -- Define o nome do arquivo ('TCOR.T'|| lpad(v_eot,3,'0') || lpad(v_list_eot.EOT,3,'0') ||'.S'|| lpad( v_seq_arquivo,2,0) ||'.D' ||c_data_arquivo||'.REP')
     ---------------------------------v_nome_arquivo := 'TCOR.T'|| lpad(v_lista_eot_agrup.eot_agrupador,3,'0') || lpad(v_eot,3,'0') || '.S'|| lpad( v_seq_arquivo,2,0) ||'.D' ||c_data_arquivo||'.NC.REP';

     OPEN C_HEADER(v_lista_eot_agrup.eot_agrupador);
     FETCH C_HEADER INTO v_header;
           v_status_exec := 'S';
           v_nro_lidos := 0;
           v_nro_gravados := 0;
           v_nro_erros := 0;
           v_valor_chamadas := 0;

           --IF C_HEADER%notfound THEN -- RFC-364933

           IF V_HEADER.linha IS NULL THEN

               -- RFC-364933 Não há necessidade de gravar Header quando não existe Detail
               /*
               Arq_envio := utl_file.fopen(cDirUnix ,v_nome_arquivo , 'W');
               utl_file.put_line(Arq_envio, '0' || lpad(v_lista_eot_agrup.eot_agrupador,3,'0') ||lpad(v_eot,3,'0') || to_char(sysdate,'ddmmyyyyhh24miss') || to_char(sysdate,'ddmmyyyy') || to_char(sysdate,'ddmmyyyy') || LPAD(v_seq_remessa,6,'0') || LPAD(' ',207,' '));
               */

               V_EXISTE_REG := FALSE;

           ELSE
               /*
               Arq_envio := utl_file.fopen(cDirUnix , v_nome_arquivo, 'W');
               utl_file.put_line(Arq_envio, '0' || lpad(v_lista_eot_agrup.eot_agrupador,3,'0') || SUBSTR(v_header.linha,2,3) || SUBSTR(v_header.linha,8,30)|| LPAD(v_seq_remessa,6,'0') || SUBSTR(v_header.linha,44));
               */
               -- Define o nome do arquivo ('TCOR.T'|| lpad(v_eot,3,'0') || lpad(v_list_eot.EOT,3,'0') ||'.S'|| lpad( v_seq_arquivo,2,0) ||'.D' ||c_data_arquivo||'.REP')
               v_nome_arquivo := 'TCOR.T'
                                || lpad(v_lista_eot_agrup.eot_agrupador,3,'0')
                                || lpad(v_eot,3,'0')
                                || '.S'
                                || lpad( v_seq_arquivo,2,0)
                                || '.D'
                                || c_data_arquivo
                                || '.NC.REP';


               Arq_envio := utl_file.fopen(cDirUnix , v_nome_arquivo, 'W');
               utl_file.put_line(Arq_envio, '0'
                                            || lpad(v_lista_eot_agrup.eot_agrupador,3,'0')
                                            || lpad(v_eot,3,'0')
                                            || to_char(SYSDATE,'ddmmyyyyhh24miss')
                                            || v_header.linha
                                            || lpad(v_seq_remessa,6,'0')
                                            || rpad(' ',207,' '));


               V_EXISTE_REG := TRUE;

               IF V_EXISTE_REG THEN

                  FOR v_detail IN C_DETAIL(v_lista_eot_agrup.eot_agrupador) LOOP
                      BEGIN

                           v_nro_lidos := v_nro_lidos + 1;

                           IF v_detail.status_para IN ('RI','RP') THEN
                              PROC_RETORNA_RECLAMACAO(v_detail.sequencial_chave,v_motivo,v_nro_reclamacao);
                              v_motivo := FUNC_CONV_MOTIVO(p_parceiro,NVL(v_detail.status_para,'RI'),v_detail.motivo );
                           ELSIF NVL(v_detail.status_para,'DE') IN ('RJ','DE','P') THEN
                              v_nro_reclamacao := LPAD('0',8,'0');
                              v_motivo := FUNC_CONV_MOTIVO(p_parceiro,NVL(v_detail.status_para,'DE'),v_detail.motivo );
                           ELSE
                              v_nro_reclamacao := LPAD('0',8,'0');
                              v_motivo := LPAD(' ',5,' ');
                           END IF;

                           --So retorna informacoes do cliente dos status que nao esteja criticados
                           --IF NVL(v_detail.status_para,'DE') NOT IN ('RJ','DE','P') THEN
                           --   PROC_RETORNA_CLIENTE(v_detail.telefone_origem,v_detail.data_servico,v_cpf_cnpj,v_nome_cliente);
                           --END IF;

                           -- IF v_detail.sequencial_arrecadacao is not null THEN
                           v_open_item_id := FUNC_RETORNA_OPEN_ITEM(p_parceiro);
                           PROC_RETORNA_REGISTRO_FISCAL(v_detail.sequencial_arrecadacao ,v_open_item_id ,v_nro_nf ,v_serie_nf, v_subserie_nf );
                           -- END IF;

                           utl_file.put_line(Arq_envio,  SUBSTR(v_detail.linha_arq,1,87) || -- ...Motivo do evento
                                                         LPAD(NVL(TRIM(v_motivo),' '),3,' ') || -- Cód. Motivo do evento
                                                         SUBSTR(v_detail.linha_arq,91,8) || -- Data do evento
                                                         LPAD(NVL(TRIM(v_nro_reclamacao),'0'),15,'0') || -- Nro Reclamacao
                                                         SUBSTR(v_detail.linha_arq,114,18) || -- Nro contrato parcelamento
                                                         -- LPAD(NVL(v_nro_nf,'0'),10,'0') || -- Nro Nota Fiscal
                                                         LPAD(NVL(TRIM(SUBSTR(v_nro_nf,1,INSTR(v_nro_nf,'-')-1)),'0'),10,'0')|| -- Nro Nota Fiscal
                                                         RPAD(NVL(SUBSTR(v_serie_nf,1,2),' '),2,' ') || -- Serie nota fiscal
                                                         SUBSTR(v_detail.linha_arq,144,28) || -- Valor liquido.. Dt vcto chamada
                                                         --nvl(SUBSTR(v_nro_nf,instr(v_nro_nf,'-')+1,2),' ') || -- RFC-339927
                                                         LPAD(NVL(SUBSTR(v_nro_nf,INSTR(v_nro_nf,'-')+1,2),' '),2,' ')    || -- Dt emissão Fatura ... -- RFC-339927
                                                         SUBSTR(v_detail.linha_arq,174,77) ); -- .

                           IF v_detail.tabela = 'SP' THEN
                              UPDATE GRC_HISTORICOS_SERV_PRESTADOS
                                 SET DATA_ENVIO_PARCEIRO = sysdate,
                                     REMESSA = v_seq_remessa
                               WHERE ROWID = v_detail.chave;

                              UPDATE GRC_SERVICOS_PRESTADOS
                                 SET arquivo_tcor        = v_nome_arquivo,
                                     informacao          = rtrim(informacao||'; ','; ')|| 'proc_envia_parceiro ('||to_char(sysdate,'dd/mm/rr hh24:mi')||').'
                               WHERE SEQUENCIAL_CHAVE = v_detail.SEQUENCIAL_CHAVE;
                           ELSE
                              UPDATE GRC_ERROS_BMP
                                 SET DATA_ENVIO_PARCEIRO = sysdate
                               WHERE ROWID = v_detail.chave;
                           END IF;

                           v_valor_chamadas := v_valor_chamadas + v_detail.valor_faturado;
                           v_nro_gravados := v_nro_gravados + 1;

                           EXCEPTION
                           WHEN OTHERS THEN
                           utl_file.put_line(Arq_log,'Erro ' || SQLCODE || ' ' || SQLERRM ||
                           ' ao tentar gravar a linha abaixo do arquivo ' || v_nome_arquivo);
                           utl_file.put_line(Arq_log,v_linha_arq);
                           V_NRO_ERROS := V_NRO_ERROS + 1;
                           v_status_exec := 'E';
                      END;

                  END LOOP;

                  utl_file.put_line(Arq_envio,
                             '9'
                          || LPAD(v_nro_gravados,7,'0')
                          || replace(translate(trim(to_char(v_valor_chamadas,'0000000000000d00000')),',.',' '),' ','')
                          || RPAD(' ',224,' ')); -- Trailler
                  utl_file.FClose(Arq_envio);

               END IF;

           END IF;

     CLOSE C_HEADER;

     utl_file.put_line(Arq_log, 'SUCESSO ARQUIVO_' || v_eot || ': ' || v_nome_arquivo);
     utl_file.put_line(Arq_log, 'Total de registros gravados: ' || v_nro_gravados);
     utl_file.put_line(Arq_log, '');
     utl_file.FClose(Arq_log);
     V_DATA_FIM_PROC := SYSDATE;

     IF v_status_exec = 'E'
     THEN erro := erro + 1;
        v_obs := 'O arquivo foi gerado com ' || v_nro_erros || ' registros com problemas. Maiores detalhes veja o arquivo de LOG.';
        PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,
        'O arquivo ' ||
        v_nome_arquivo || ' foi gerado com ' ||
        v_nro_erros || ' registros com problemas. ' || CHR(10) ||
        'Maiores detalhes veja o arquivo de LOG ' ||
        cDirUnix_log || '/' || p_nome_arq_log);
     END IF;

     SELECT SEQ_INTERFACE.NEXTVAL
       INTO v_seq_interface
       FROM SYS.DUAL;

     BEGIN

     INSERT INTO GRC_INTERFACES (codigo,processo,data_inclusao,usuario,path_arquivo,nome_arquivo,data_inic_exec,
                                data_fim_exec,status_exec,obs,atrib1,atrib2,atrib3,atrib4,parceiro)
     VALUES(v_seq_interface,
            'PAR',
            SYSDATE,
            'GRC',
            cDirUnix ,
            v_nome_arquivo,
            V_DATA_INICIO_PROC,
            V_DATA_FIM_PROC,
            v_status_exec,
            v_obs,
            v_nro_lidos,
            v_nro_gravados,
            v_nro_erros,
            v_seq_remessa,p_parceiro);
     COMMIT;

     EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
          PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,
          'Erro de chave primaria em GRC_INTERFACES');
     WHEN OTHERS THEN
          PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,
          'Erro ao inserir o log do proceso em GRC_INTERFACES' || CHR(10) ||
          SQLCODE || ' ' || SQLERRM);
     END;

                       COMMIT;

 END LOOP;

     Arq_log := utl_file.fopen(cDirUnix_Log , p_nome_arq_log, 'A');
     utl_file.put_line(Arq_log, 'Fim do processo: ' || TO_CHAR(SYSDATE, 'HH24:MI:SS DD/MM/YYYY'));

 IF ERRO > 0 THEN
    utl_file.put_line(Arq_log, 'OCORREU ERRO NA GERACAO DE '|| erro ||' ARQUIVOS.');
 ELSE
    utl_file.put_line(Arq_log, 'COMPLETADO COM SUCESSO');
 END IF;

 utl_file.FClose(Arq_log);

EXCEPTION
 WHEN sys.UTL_FILE.INVALID_PATH THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> INVALID PATH');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.INVALID_MODE THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> INVALID MODE');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.INVALID_FILEHANDLE THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> INVALID FILE HANDLE');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.INVALID_OPERATION THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> INVALID OPERATION');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.READ_ERROR THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> READ ERROR');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.WRITE_ERROR THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> WRITE ERROR');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN sys.UTL_FILE.INTERNAL_ERROR THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'ERRO DE UTL_FILE -> INTERNAL ERROR');
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
 WHEN OTHERS THEN
   PROC_GERA_MENSAGENS(cResponsavel,'ERRO! Processo de Envio de CDRs ao Parceiro.',NULL,   'Erro ' || SQLCODE || ' ' || SQLERRM);
   utl_file.put_line(arq_log, 'Erro na execucao do procedimento.');
   utl_file.put_line(arq_log, 'Segue o erro: '|| SQLERRM);
   utl_file.FClose(arq_log);
END PROC_ENVIA_PARCEIRO_GV2EOTAG;
/
