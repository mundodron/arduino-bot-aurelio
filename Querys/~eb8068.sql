CREATE OR REPLACE PROCEDURE ARBOR.sql_get_seq_num(
   v_table_name CHAR,
   v_seqnum     OUT NUMBER,
   v_server_id  OUT NUMBER,
   v_seq_num_type NUMBER := 0) /* DENqa13075 */
IS
   d_use_sequence NUMBER(10);
   d_seq_num NUMBER(18);
   d_server_id NUMBER(3);
   d_stmt_count NUMBER;
BEGIN
   /* Initialize return values */
   v_seqnum := NULL;
   v_server_id := NULL;

  BEGIN
    SELECT int_value
    INTO   d_use_sequence
    FROM  SYSTEM_PARAMETERS
    WHERE module = 'DB'
    AND parameter_name = 'USE_SEQUENCES';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    d_use_sequence := 0;
  END;

  /* Determine server_id */
  SELECT COUNT(*)
  INTO d_stmt_count
  FROM LOCAL_SERVER_ID;

  IF (d_stmt_count != 1) THEN
      raise_application_error(-20033, '55556, No row found in LOCAL_SERVER_ID table.');
  END IF;

  SELECT server_id
  INTO d_server_id
  FROM  LOCAL_SERVER_ID;

  IF (d_server_id IS NULL) THEN
      raise_application_error(-20033, '55557, No valid server id found in LOCAL_SERVER_ID table.');
  END IF;

  /* Modified to use Oracle next seq rather than table generated */


    /* DENqa13075 */
  IF (d_use_sequence != 0 AND v_table_name = 'CUSTOMER_CONTRACT_VIEW') THEN
    select CUSTOMER_CONTRACT_VIEW_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'NRC_VIEW') THEN
    select NRC_VIEW_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'PRODUCT_VIEW') THEN
    select PRODUCT_VIEW_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'SERVICE_VIEW') THEN
    select SERVICE_VIEW_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'CUSTOMER_ID_EQUIP_MAP_VIEW') THEN
    select CUSTOMER_ID_EQUIP_MAP_VIEW_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'ORD_ORDER') THEN
        select ORD_ORDER_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'ORD_SERVICE_ORDER') THEN
        select ORD_SERVICE_ORDER_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'ORD_ITEM') THEN
        select ORD_ITEM_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'CUSTOMER_CONTRACT') THEN
        select CUSTOMER_CONTRACT_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'NRC') THEN
        select NRC_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'PRODUCT') THEN
        select PRODUCT_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'ADJ') THEN
        select ADJ_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'CMF_PACKAGE') THEN
        select CMF_PACKAGE_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'CMF_PACKAGE_COMPONENT') THEN
        select CMF_PACKAGE_COMPONENT_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'HISTORIC_CONTRIBUTION') THEN
        select HISTORIC_CONTRIBUTION_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'HISTORIC_DISCOUNT_TRANS_MAP') THEN
        select HISTORIC_DISCOUNT_TRANS_MAP_se.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'HISTORIC_THRESHOLDS') THEN
         select HISTORIC_THRESHOLDS_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'RATE_DISCOUNT_OVERRIDES') THEN
        select RATE_DISCOUNT_OVERRIDES_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'RATE_UNIT_CR_OVERRIDES') THEN
        select RATE_UNIT_CR_OVER_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'NOTE') THEN
        select NOTE_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (v_table_name = 'WFM_WORKFLOW_INST') THEN
        select WFM_WORKFLOW_INST_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (v_table_name = 'WFM_MILESTONE_INST_HSTRY') THEN
        select WFM_MILESTONE_INST_HSTRY_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'ADR_ADDRESS') THEN
        select ADR_ADDRESS_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'SERVICE_ADDRESS_ASSOC') THEN
        select SERVICE_ADDRESS_ASSOC_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'UNIT_CREDIT_PROFILES') THEN
        select UNIT_CREDIT_PROFILES_seq.NEXTVAL into d_seq_num from DUAL;
  ELSIF (d_use_sequence != 0 AND v_table_name = 'BMF') THEN
        select BMF_seq.NEXTVAL into d_seq_num from DUAL;
  ELSE

       SELECT COUNT(*)
          INTO d_stmt_count
          FROM SEQ_NUM
          WHERE table_name = v_table_name;

          IF (d_stmt_count != 1) THEN
             raise_application_error(-20033, '55555, No row for table_name in SEQ_NUM table.');
          END IF;


    UPDATE SEQ_NUM
    SET seq_num = seq_num + 1
    WHERE table_name = v_table_name;

    SELECT seq_num
    INTO d_seq_num
    FROM SEQ_NUM
    WHERE table_name = v_table_name;
  END IF;

  IF (v_seq_num_type = 1) THEN
    d_seq_num := (d_seq_num * 1000) + d_server_id;
  END IF; /* v_seq_num_type = 1 */

       /* Verify that return data is valid */

       IF (d_seq_num IS NULL) THEN
            raise_application_error(-20033, '55557, No valid sequence number found in SEQ_NUM table.');
       END IF;


  v_seqnum := d_seq_num;
  v_server_id := d_server_id;

END;
/
