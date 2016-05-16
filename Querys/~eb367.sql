select * from bill_invoice

select * from 

CURSOR qCDR IS
SELECT /*+ ordered */
       cdr.msg_id,
       cdr.msg_id2,
       cdr.msg_id_serv,
       cdr.split_row_num,
       cdr.cdr_data_partition_key,
       cdr.account_no,
       cdr.subscr_no,
       cdr.type_id_usg,
       cdr.file_id,
       cdr.ext_tracking_id,
       cdr.provider_id,
       cdr.trans_dt,
       cdr.rate_dt,
       b.account_category
  FROM (SELECT /*+ parallel (cun 4 ) full (cun) index ( cmf cmf_pk)*/
               cun.msg_id,
               cun.msg_id2,
               cun.msg_id_serv,
               cun.subscr_no,
               cun.account_no,
               cun.split_row_num,
               cun.type_id_usg,
               cun.trans_dt,
               cun.rate_dt,
               cmf.account_category,
               cun.cdr_data_partition_key
          FROM cdr_unbilled cun
              ,cmf
              ,&2  bip
         WHERE MOD (cun.account_no, p_processo_total) = p_processo_atual
           AND cmf.account_no = bip.account_no
           AND cmf.account_category IN (9, 10, 11, 18)
           AND (   (    
                        --90 dias
                        (cun.trans_dt < TO_DATE ('&1', 'YYYYMMDD'))
                    AND (cun.type_id_usg NOT IN
                            (100, 101, 103, 104, 150, 151, 152, 153, 154, 925)
                        )
                   )

               )
           -- Ignora usos de TV
           -- Será utilizada a mesma regra de 90 dias para VDR PJ1072 - RGC
         --  AND cun.type_id_usg NOT IN ( SELECT usage_types.type_id_usg 
         --                                     FROM usage_types 
         --                                    WHERE usage_types.product_line_id = 11982
          --                                     AND usage_types.type_id_usg = cun.type_id_usg )
           AND cun.account_no = cmf.account_no) b,
       cdr_data cdr
 WHERE cdr.msg_id = b.msg_id
   AND cdr.msg_id2 = b.msg_id2
   AND cdr.msg_id_serv = b.msg_id_serv
   AND cdr.split_row_num = b.split_row_num
   AND cdr.cdr_data_partition_key = b.cdr_data_partition_key
   AND cdr.no_bill = 0;
   
   
   select * from BIPP15_TESTE