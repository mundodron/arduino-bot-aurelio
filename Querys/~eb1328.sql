      SELECT DISTINCT (gci.nome_arquivo) AS nome_arquivo,
                      TO_NUMBER (TO_CHAR (bi.payment_due_date, 'yyyymm')) AS mes,
                      bi.payment_due_date AS data_processamento,
                      bi.bill_ref_no
                 FROM gvt_conta_internet gci,
                      bill_invoice bi
                WHERE bi.account_no IN (SELECT account_no
                                          FROM customer_id_acct_map
                                         WHERE external_id = '999991682930')
                  AND bi.account_no = gci.account_no
                  AND bi.bill_ref_no = gci.bill_ref_no
                  --AND bi.payment_due_date > (SYSDATE - 3)
             ORDER BY bi.payment_due_date DESC;
             
             select * from gvt_conta_internet where account_no = bill_ref_no in (143525527,140454325)
             
             select * from cmf_balance where bill_ref_no = 143525527 