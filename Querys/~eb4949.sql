     SELECT DISTINCT BD.bmf_trans_type, D.description_code, GOC.open_item_id, GOC.cod_operadora, SUM( BD.amount)
        FROM GVT_OPERADORAS_COBILLING GOC, DESCRIPTIONS D,BMF_TRANS_DESCR BTD, BMF_DISTRIBUTION BD
       WHERE 1=1 
         AND BD.account_no = 10394380                        /*Gambeta: para caso de credito pagamento parcial (-316), a proc BMF_SCRN_INSERT */
         AND BD.status = 1                                                        /* insere open_item_id = 0 na bmf_distribution, como esse open_item_id */
                  AND BTD.bmf_trans_type = BD.bmf_trans_type        /* nao existe na tabela gvt_operadoras_cobilling, a query nao retorna nada. */
                  AND D.description_code = BTD.description_code
                  AND D.language_code = 2
                  --AND GOC.open_item_id = decode(BD.BMF_TRANS_TYPE ,-316, 1, BD.OPEN_ITEM_ID) 
       GROUP BY BD.bmf_trans_type, D.description_code, GOC.open_item_id, GOC.cod_operadora 
             ORDER BY GOC.open_item_id, GOC.cod_operadora, D.description_code; 
             
             
            -- select * from GVT_BILL_INVOICE_TOTAL_TAX where bill_ref_no in (282875286,283502801)
             
            -- select * from GVT_OPERADORAS_COBILLING
             
             