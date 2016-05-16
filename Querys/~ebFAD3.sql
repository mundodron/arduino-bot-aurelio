-- Nome Arquivo : PLCAD_0.SQL 
-- Versão : 1.0
-- Autor : Igohr Schultz
-- Data: 14/03/2005
--
-- Função : Carregar tabela temporária para geração de cadastro.

SET SERVEROUTPUT ON;
SET SERVEROUT ON SIZE 1000000;

-- PARAMETROS
-- 1: DIRETORIO QUE VAI FICAR O LOG DE PROCESSAMENTO DO ARQUIVO

-- 	*** DECLARACAO DE VARIAVEIS ***
DECLARE

-- *** VARIAVEIS PARA TRATAMENTO DE ARQUIVOS
	V_NOME_ARQ_LOG		VARCHAR2(50);
	V_NOME_DIR_LOG		VARCHAR2(50) := '&1';
	V_LOG              	UTL_FILE.FILE_TYPE;
	V_ERRO             	VARCHAR2(120); -- IDENTIFICA O TIPO DE ERRO DO ORACLE

-- *** VARIAVEIS PARA TRUNCATE DE TABELA ***
	CURSOR_ 		INTEGER;
	RETORNO_ 		INTEGER;

	ACCOUNT_MIN		NUMBER(10);
	RAZAO			NUMBER(10);
	V_COUNT			NUMBER(1);
	V_COUNT_AUX		NUMBER(10);
	V_QTDE			NUMBER(10);
	V_ACCOUNT_AUX	NUMBER(10);
	V_ACCOUNT_NO	NUMBER(10);
	V_TELEFONE		VARCHAR2(48);
	V_QTDE_PROCESSOS NUMBER(2) := '&2';
	
TYPE TYPE_CURSOR IS REF CURSOR;

C_CLIENTE TYPE_CURSOR;

-- PROCEDURE CARREGA CLIENTES TEMPORARIOS
--
PROCEDURE CARGA_TABELA_TEMPORARIA IS
BEGIN
	BEGIN

	DECLARE
	 CURSOR s_cur IS 
	  select  /*+ no_merge(a) */ 
    a.cliente, a.subscr_no,
    a.nome_assinante,
    a.tipo_doc,
    a.numero_documento,
    a.insc_estadual,
    a.categoria,
    a.tipo_terminal,
    a.ind_retencao_tributos,
    a.dia_venc_fatura,
    a.cobr_logradouro,
    a.cobr_complemento,
    a.cobr_bairro,
    a.cobr_municipio, 
    a.cobr_uf, 
    a.cobr_cep,  
    a.inst_logradouro,
    a.inst_complemento,
    a.inst_bairro, a.inst_municipio,
    a.inst_uf, a.inst_cep,
    a.dt_ativacao, a.dt_desativacao,
    a.account_no, a.telefone,
    a.rpon, 
    b.cnl, 
    b.eot_origem,
    a.chg_date
from (select UP.point_class cnl,
    SUBSTR (TRIM (UP.point_zip), 1, 3) eot_origem
    , point
    from usage_points UP
   where UP.inactive_dt IS NULL 
   and UP.point_type = 0
   and point_category = 0) b
 , (SELECT /*+ ordered use_hash(saa e) index_ffs(eiem CIEM_SUBSCR_NO_PK) full(eiam) full(c) full(la) */  
    eiam.external_id cliente, e.subscr_no subscr_no,
    c.bill_lname nome_assinante,
    DECODE (TRIM (SUBSTR (c.ssn, 1, 2)),
            '1', '1',
            '2', '21',
            '99') tipo_doc,
    SUBSTR (c.contact1_phone, 1, 16) numero_documento,
    SUBSTR (NVL (c.contact1_name, ' '), 1, 20) insc_estadual,
    c.account_category categoria,
    DECODE (c.account_category, 15, 'F', 16, 'C', 'A') tipo_terminal,
    DECODE (c.account_category, 21, 'S', 'N') ind_retencao_tributos,
    SUBSTR (c.bill_period, 2, 2) dia_venc_fatura,
    c.cust_address1 cobr_logradouro,
    SUBSTR (c.cust_address2, 1, 20) cobr_complemento,
    SUBSTR (c.cust_address3, 1, 40) cobr_bairro,
    c.cust_city cobr_municipio
  , SUBSTR (LTRIM (c.cust_state), 1, 2) cobr_uf
  , c.cust_zip cobr_cep,  
    la.address_1 inst_logradouro,
    SUBSTR (la.address_2, 1, 20) inst_complemento,
    SUBSTR (la.address_3, 1, 40) inst_bairro, la.city inst_municipio,
    SUBSTR (LTRIM (la.state), 1, 2) inst_uf, la.postal_code inst_cep,
    e.service_active_dt dt_ativacao, e.service_inactive_dt dt_desativacao,
    c.account_no account_no, eiem.external_id telefone,
    TRIM (e.sim_serial_number) rpon, 
    SYSDATE chg_date
FROM service_address_assoc saa,
    service e,
    customer_id_equip_map eiem,
    customer_id_acct_map eiam,
    cmf c,
    local_address la
WHERE eiam.external_id_type = 1
AND c.account_no = eiam.account_no
AND e.parent_account_no = eiam.account_no
AND eiem.subscr_no = e.subscr_no
AND eiem.subscr_no_resets = e.subscr_no_resets
AND eiem.external_id_type = 1
AND la.address_id = saa.address_id
AND e.parent_account_no = saa.account_no
AND e.subscr_no = saa.subscr_no
AND e.subscr_no_resets = saa.subscr_no_resets
AND SUBSTR (eiem.external_id, 3, 3) <> '000'
AND c.account_category NOT IN (17, 18, 19, 20)
AND (   e.emf_config_id BETWEEN 401 AND 410
     OR e.emf_config_id BETWEEN 441 AND 460
     OR e.emf_config_id BETWEEN 471 AND 490
     OR e.emf_config_id BETWEEN 561 AND 570
     OR e.emf_config_id BETWEEN 611 AND 620
     OR e.emf_config_id BETWEEN 633 AND 642
     OR e.emf_config_id BETWEEN 663 AND 673
     OR e.emf_config_id BETWEEN 677 AND 678
     OR e.emf_config_id BETWEEN 680 AND 681
     OR e.emf_config_id BETWEEN 694 AND 695
     OR e.emf_config_id BETWEEN 698 AND 699
     OR e.emf_config_id BETWEEN 703 AND 704
     OR e.emf_config_id BETWEEN 706 AND 707
     OR e.emf_config_id BETWEEN 720 AND 721
     OR e.emf_config_id BETWEEN 724 AND 725
     OR e.emf_config_id BETWEEN 729 AND 730
     OR e.emf_config_id BETWEEN 732 AND 733
     OR e.emf_config_id BETWEEN 746 AND 747
     OR e.emf_config_id BETWEEN 750 AND 751
     OR e.emf_config_id BETWEEN 755 AND 756
     OR e.emf_config_id BETWEEN 758 AND 759
     OR e.emf_config_id BETWEEN 772 AND 773
     OR e.emf_config_id BETWEEN 792 AND 819
     OR e.emf_config_id IN (689, 715, 741, 767, 776))) a
WHERE b.point LIKE SUBSTR (a.telefone, 1, 6) || '%';

--	INSERT INTO GVT_CAD_CLIENTE_TEMP

	  TYPE fetch_array IS TABLE OF s_cur%ROWTYPE;
				 s_array fetch_array;
		BEGIN
	  	OPEN s_cur;
	  	LOOP
	    	FETCH s_cur BULK COLLECT INTO s_array LIMIT 100000;
	
	    	FORALL i IN 1..s_array.COUNT
	    	INSERT INTO GVT_CAD_CLIENTE_TEMP VALUES s_array(i);
	
	    	EXIT WHEN s_cur%NOTFOUND;
	  	END LOOP;
	  	CLOSE s_cur;
	  	COMMIT;
		END;
	EXCEPTION
		WHEN OTHERS THEN
			V_ERRO := 'ERRO AO INSERIR CLIENTES ' || SQLERRM(SQLCODE); 
	END; 
	
END;
	

--
-- PROCEDURE
-- LIMPA_CLIENTES_TEMPORARIOS
--
--	*** LIMPA A TABELA TEMPORARIA DE CLIENTES ARBOR

PROCEDURE LIMPA_CLIENTES_TEMPORARIOS IS
BEGIN	 	


	BEGIN

	--	*** LIMPA A TABELA TEMPORARIA DE CLIENTES
        CURSOR_ := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(CURSOR_,'TRUNCATE TABLE GVT_CAD_CLIENTE_TEMP',0);
        RETORNO_ := DBMS_SQL.EXECUTE(CURSOR_);

	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			V_ERRO := 'ERRO AO APAGAR CLIENTES ' || SQLERRM(SQLCODE); 
	END; 


END;



-- LIMPA OS INDICES PARA PROCESSAMENTO DO CADASTRO
PROCEDURE LIMPA_CLIENTES_INDICES IS
BEGIN	 	


	BEGIN
		
	--	*** LIMPA A TABELA TEMPORARIA DE CLIENTES
        CURSOR_ := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(CURSOR_,'TRUNCATE TABLE GVT_CAD_CLIENTE_IND',0);
        RETORNO_ := DBMS_SQL.EXECUTE(CURSOR_);

	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			V_ERRO := 'ERRO AO APAGAR CLIENTES ' || SQLERRM(SQLCODE); 
	END; 


END;


-- LIMPA OS INDICES PARA PROCESSAMENTO DO CADASTRO
PROCEDURE CARGA_CLIENTES_INDICES IS
BEGIN	 	

	BEGIN
		
		SELECT MIN(ACCOUNT_NO) MIN_ACCOUNT_NO, 
			COUNT(*)/V_QTDE_PROCESSOS RAZAO, --TRUNC((MAX(ACCOUNT_NO)-MIN(ACCOUNT_NO))/5) RAZAO,
			COUNT(*) QTDE --TRUNC(MAX(ACCOUNT_NO)-MIN(ACCOUNT_NO)) QTDE 
		INTO ACCOUNT_MIN, RAZAO, V_QTDE
		FROM GVT_CAD_CLIENTE_TEMP;
		
		V_COUNT := 1;
		V_COUNT_AUX := 1;
		V_ACCOUNT_AUX := 0;
		
		OPEN C_CLIENTE FOR
		SELECT ACCOUNT_NO, TELEFONE
		FROM GVT_CAD_CLIENTE_TEMP
		ORDER BY ACCOUNT_NO;

		LOOP
		BEGIN           
			
			FETCH C_CLIENTE INTO v_Account_No, v_Telefone;
			EXIT WHEN C_CLIENTE%NOTFOUND;
			
			IF (V_COUNT_AUX > RAZAO) AND (V_ACCOUNT_AUX != v_Account_No) THEN
				
				INSERT INTO GVT_CAD_CLIENTE_IND 
				VALUES (V_COUNT, ACCOUNT_MIN, V_ACCOUNT_AUX, SYSDATE);
				
				COMMIT;

				V_COUNT := V_COUNT + 1;
				ACCOUNT_MIN := v_Account_No;
				V_COUNT_AUX := 0;
				
			END IF;
			
			V_ACCOUNT_AUX := v_Account_No;
			V_COUNT_AUX := V_COUNT_AUX + 1;
		
		
		END;    
		END LOOP; 
		
		IF V_COUNT = V_QTDE_PROCESSOS THEN

			INSERT INTO GVT_CAD_CLIENTE_IND 
			VALUES (V_COUNT, ACCOUNT_MIN, V_ACCOUNT_AUX, SYSDATE);

			COMMIT;
			
		END IF;

	EXCEPTION
		WHEN OTHERS THEN

			V_ERRO := 'ERRO AO INCLUIR INDICES ' || SQLERRM(SQLCODE); 
	END; 


END;



-- INICIANDO PROGRAMA PRINCIPAL
BEGIN

-- INICIO DO PROCESSAMENTO
	DBMS_OUTPUT.PUT_LINE('INICIO DE PROCESSAMENTO: ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

-- GERANDO ARQUIVO DE LOG
	V_NOME_ARQ_LOG := 'GERANDO_TAB_TMP_' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') || '.log';
	V_LOG      := UTL_FILE.FOPEN(V_NOME_DIR_LOG, V_NOME_ARQ_LOG, 'W'); 

-- LIMPANDO TABELA TEMPORÁRIA
	V_ERRO := NULL;

	LIMPA_CLIENTES_TEMPORARIOS;

	DBMS_OUTPUT.PUT_LINE('LIMPOU TMP : ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

	IF V_ERRO IS NOT NULL THEN
	BEGIN
        UTL_FILE.PUT_LINE(V_LOG, V_ERRO); 
	END;
	END IF;

-- CARREGANDO TABELA TEMPORÁRIA
	V_ERRO := NULL;

	CARGA_TABELA_TEMPORARIA;
	
	DBMS_OUTPUT.PUT_LINE('CARREGOU TMP : ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

	IF V_ERRO IS NOT NULL THEN
	BEGIN
        UTL_FILE.PUT_LINE(V_LOG, V_ERRO); 
	END;
	END IF;

-- LIMPANDO INDICES
	V_ERRO := NULL;

	LIMPA_CLIENTES_INDICES;

	DBMS_OUTPUT.PUT_LINE('LIMPOU INDICES : ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

	IF V_ERRO IS NOT NULL THEN
	BEGIN
        UTL_FILE.PUT_LINE(V_LOG, V_ERRO); 
	END;
	END IF;

-- CARREGANDO INDICES
	V_ERRO := NULL;

	CARGA_CLIENTES_INDICES;

	DBMS_OUTPUT.PUT_LINE('CARREGOU INDICES : ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

	IF V_ERRO IS NOT NULL THEN
	BEGIN
        UTL_FILE.PUT_LINE(V_LOG, V_ERRO); 
	END;
	END IF;

	-- FECHANDO ARQUIVO DE LOG
	UTL_FILE.FCLOSE(V_LOG);
	DBMS_OUTPUT.PUT_LINE('ARQUIVO DE LOG: ' || V_NOME_ARQ_LOG);
	DBMS_OUTPUT.PUT_LINE('FIM DE PROCESSAMENTO: ' || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
	DBMS_OUTPUT.PUT_LINE('Execução encerrada com Sucesso!!!');


END;
/