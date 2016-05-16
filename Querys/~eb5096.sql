SELECT un.account_no,bill_ref_no,
       c.CORRIDOR_PLAN_ID corridor,
       c.TYPE_ID_USG tipo_uso,
       d2.DESCRIPTION_text desc_tipo_uso,
       c.JURISDICTION jurisdicao,  
       c.ELEMENT_ID,
       d3.DESCRIPTION_text desc_element_id,
       c.POINT_ORIGIN numero_origem,
       c.POINT_TARGET numero_destino,
       c.RATE_DT,
       c.TRANS_DT data_hora,
       c.SECOND_UNITS segundos,
       c.RATED_UNITS unidades_tarifarias,
       c.AMOUNT/100 valor
FROM   cdr_data c
        cdr_billed un
WHERE un.bill_ref_no =132765510 
  AND c.MSG_ID=un.MSG_ID 
  AND c.MSG_ID2=un.MSG_ID2 
  AND c.MSG_ID_SERV=un.MSG_ID_SERV
  AND c.SPLIT_ROW_NUM=un.SPLIT_ROW_NUM
  AND c.CDR_DATA_PARTITION_KEY=un.CDR_DATA_PARTITION_KEY
  AND c.NO_BILL=0 
  AND d2.DESCRIPTION_CODE=16||c.TYPE_ID_USG 
  AND d3.DESCRIPTION_CODE=c.ELEMENT_ID 
  AND d2.LANGUAGE_CODE = 2
  AND d3.LANGUAGE_CODE = 2
  
  select * from bill_invoice where bill_ref_no = 132765510 
  
  select * from cmf_balance 
  
  select * from cdr_data where 

select * from bill_invoice where account_no in (4273196,4434714)