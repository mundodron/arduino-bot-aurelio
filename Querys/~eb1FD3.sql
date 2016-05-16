
--Levantamento no Kenan
DROP TABLE PAC_002;
DROP TABLE PAC_002_siebel;

CREATE TABLE PAC_002
AS
   SELECT   DISTINCT
            parent_account_no,
            (SELECT   external_id
               FROM   customer_id_acct_map map
              WHERE   MAP.ACCOUNT_NO = parent_account_no
                      AND EXTERNAL_ID_TYPE = 1)
               CONTA
     FROM   product p, cmf
    WHERE       p.component_id = 25978
            AND p.product_inactive_dt IS NULL
            AND cmf.account_no = p.parent_account_no
            AND cmf.no_bill = 0
            AND cmf.bill_period = 'M??'                                --CICLO
            AND NOT EXISTS
                  (SELECT   1
                     FROM   product p2
                    WHERE       p2.PARENT_ACCOUNT_NO = p.PARENT_ACCOUNT_NO
                            AND p2.component_id = 25977
                            AND p2.billing_inactive_dt IS NULL)
            AND NOT EXISTS
                  (SELECT   1
                     FROM   product p2
                    WHERE   p2.parent_account_no IN
                                  (SELECT   c2.account_no
                                     FROM   cmf c2
                                    WHERE   c2.parent_id = cmf.parent_id)
                            AND cmf.parent_id IS NOT NULL
                            AND p2.component_id IN (25977, 28443)
                            AND (p2.billing_inactive_dt IS NULL
                                 OR (p2.billing_inactive_dt IS NOT NULL
                                     AND p2.billing_inactive_dt >
                                           cmf.prev_cutoff_date
                                     AND p2.billing_inactive_dt <>
                                           p.billing_active_dt)))
            AND EXISTS
                  (SELECT   1
                     FROM   product p2
                    WHERE       p2.PARENT_ACCOUNT_NO = p.PARENT_ACCOUNT_NO
                            AND p2.component_id NOT IN (28443, 25977, 25978)
                            AND p2.billing_inactive_dt IS NULL)
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gvt_log_cmf g
                    WHERE       g.account_no = p.parent_account_no
                            AND old_no_bill = 1
                            AND new_no_bill = 0
                            AND UPPER (g.old_remark) LIKE '%INADIMP%'
                            AND NVL (cmf.prev_cutoff_date,
                                     TO_DATE ('01011990', 'ddmmyyyy')) <
                                  g.quando);

--Verificação no Siebel 5

CREATE TABLE PAC_002_siebel
AS
   SELECT   Soe.X_Acct_Id_Num AS Conta_Cobranca,
            soe.row_id,
            TRUNC (sqi.eff_end_dt) AS data_ativacao,
            c.parent_id,
            c.account_no
     FROM   /*+ use_nl(t,c,ciam)*/

            s_org_ext soe,
            s_quote_item sqi,
            PAC_002 t,
            cmf c,
            customer_id_acct_map ciam
    WHERE       soe.row_id = sqi.inv_accnt_id
            AND sqi.prod_id = '3-NNPIJ9'
            AND sqi.stat_cd = 'Ativo'
            AND TO_CHAR (soe.x_acct_id_num) = ciam.external_id
            AND c.account_no = t.parent_account_no
            AND ciam.account_no = t.parent_account_no
            AND ciam.EXTERNAL_ID_TYPE = 1
            AND Bill_Period IN ('M??');                                          -- Ciclo

DELETE   PAC_002_Siebel
 WHERE   Account_No IN
               (SELECT   Tmp.account_no
                  FROM   PAC_002_Siebel Tmp
                 WHERE   Tmp.Parent_Id IS NOT NULL
                         AND Data_Ativacao <=
                               (SELECT   MAX (Tmp2.Data_Ativacao)
                                  FROM   PAC_002_Siebel Tmp2
                                 WHERE   Tmp2.Parent_Id = Tmp.Parent_Id)
                         AND Account_No <>
                               (SELECT   MAX (Account_No)
                                  FROM   PAC_002_Siebel Tmp3
                                 WHERE   Tmp3.Parent_Id = Tmp.Parent_Id
                                         AND Tmp3.Data_Ativacao =
                                               (SELECT   MAX(Tmp2.Data_Ativacao)
                                                  FROM   PAC_002_Siebel Tmp2
                                                 WHERE   Tmp2.Parent_Id =
                                                            Tmp.Parent_Id)));

COMMIT;

UPDATE   PAC_002_Siebel tmp
   SET   data_ativacao =
            (SELECT   MAX (cutoff_date)
               FROM   bill_cycle bc, cmf
              WHERE       bc.bill_period = cmf.bill_period
                      AND cmf.account_no = tmp.account_no
                      AND cutoff_date <= TRUNC (data_ativacao))
 WHERE   EXISTS
            (SELECT   1
               FROM   s_quote_item sqi
              WHERE       inv_accnt_id = tmp.row_id
                      AND prod_id = '1-783C67'
                      AND TRUNC (shipped_dt) = TRUNC (tmp.data_ativacao));

COMMIT;



-- RELATORIO (Não precisa esperar o Sautorot rodar para gerá-lo)

--Large

SELECT   DISTINCT tmp.CONTA,
                  c.ACCOUNT_NO,
                  c.account_category,
                  c.bill_period,
                  c.bill_lname,
                  siebel.data_ativacao,
                  (SELECT   * FROM global_name) AS customer
  FROM   PAC_002 TMP, PAC_002_siebel SIEBEL, cmf c
 WHERE       TMP.CONTA = SIEBEL.conta_cobranca
         AND c.ACCOUNT_NO = tmp.PARENT_ACCOUNT_NO
         AND c.account_category NOT IN (9, 10, 11, 16, 18)
         AND NOT EXISTS (SELECT   1
                           FROM   PAC_151
                          WHERE   conta = tmp.conta);

--SME

SELECT   DISTINCT tmp.CONTA,
                  c.ACCOUNT_NO,
                  c.account_category,
                  c.bill_period,
                  c.bill_lname,
                  siebel.data_ativacao,
                  (SELECT   * FROM global_name) AS customer
  FROM   PAC_002 TMP, PAC_002_siebel SIEBEL, cmf c
 WHERE       TMP.CONTA = SIEBEL.conta_cobranca
         AND c.ACCOUNT_NO = tmp.PARENT_ACCOUNT_NO
         AND c.account_category = 9
         AND NOT EXISTS (SELECT   1
                           FROM   PAC_151
                          WHERE   conta = tmp.conta);

-- Tratamento

--Sautorot -- provisiona o cm nivel conta
INSERT

INTO gvt_prov_charges

  (
    ELEMENT_ID,
    EXTID_ACCTNO,
    EXT_ID_TYPE,
    PACKAGE_ID,
    COMPONENT_ID,
    START_DATE,
    FLAG,
    RUN_STATUS
  );
SELECT DISTINCT ' ' AS ELEMENT_ID,

  TMP.CONTA         AS EXTID_ACCTNO,

  '1' ,                    -- nivel conta = 1

  '24203' AS PACKAGE_ID

  '25977' AS COMPONENT_ID,

  CASE

    WHEN siebel.data_ativacao <= to_date('??/??/????','dd/mm/yyyy')
      -- data do corte anterior

    THEN to_date('??/??/????','dd/mm/yyyy')
      -- data do corte anterior

    ELSE to_date('??/??/????','dd/mm/yyyy')
      -- data do corte atual

  END DT

  '1', -- 0 nivel instancia e 1 nivel conta

  '99'

FROM PAC_002 TMP,

  PAC_002_siebel SIEBEL,

  cmf

WHERE TMP.CONTA           = SIEBEL.conta_cobranca

AND TMP.PARENT_ACCOUNT_NO = CMF.ACCOUNT_NO;
COMMIT;

-- VALIDACAO

SELECT   extid_acctno,
         run_status,
         error_message,
         sauto_id
  FROM   gvt_prov_charges
 WHERE   extid_acctno IN
               (SELECT   DISTINCT tmp.conta
                  FROM   PAC_002 TMP, PAC_002_siebel SIEBEL, cmf
                 WHERE   TMP.CONTA = SIEBEL.conta_cobranca
                         AND TMP.PARENT_ACCOUNT_NO = CMF.ACCOUNT_NO);

--Depois do sautorot ter rodado, inserir valores pros casos de SME
DROP TABLE PAC_002_VALORES;CREATE TABLE PAC_002_VALORES AS

SELECT

  (SELECT external_id

  FROM customer_Id_acct_map

  WHERE account_no    =p.parent_account_no

  AND external_id_type=1

  AND inactive_date  IS NULL

  ) conta,

  tracking_id,

  tracking_id_serv

FROM product p,

  cmf

WHERE component_id = 25977

AND NOT EXISTS

  (SELECT 1

  FROM product_rate_override

  WHERE tracking_id   =p.tracking_id

  AND tracking_id_serv=p.tracking_id_serv

  AND inactive_dt    IS NULL

  )

AND cmf.account_no         =p.parent_account_no

AND cmf.bill_period        ='M15' --Ciclo

AND p.billing_inactive_dt IS NULL

AND p.billing_active_dt   <=to_date('27-feb-2013') – Data do Corte Anterior

AND account_category =9;


SELECT      'insert into Product_Rate_Override values ('
         || P2.Tracking_Id
         || ','
         || P2.Tracking_Id_serv
         || ',''19-feb-2013'','
         || (SELECT   SUM (override_rate)
               FROM   product p, product_rate_override pro3
              WHERE   billing_account_no IN
                            ( (SELECT   c.account_no
                                 FROM   cmf c, cmf c2
                                WHERE   c2.account_no = p2.billing_account_no
                                        AND c.parent_id = c2.parent_id)
                             UNION ALL
                             (SELECT   p2.billing_account_no FROM DUAL))
                      AND component_id IN (25978)
                      AND p.product_inactive_dt IS NULL
                      AND pro3.tracking_id = p.tracking_id
                      AND pro3.tracking_id_serv = p.tracking_id_serv
                      AND pro3.active_dt =
                            (SELECT   MAX (active_dt)
                               FROM   product_rate_override pro2
                              WHERE   pro2.tracking_id = pro3.tracking_Id
                                      AND pro2.tracking_id_serv =
                                            pro3.tracking_Id_serv
                                      AND TO_DATE (pro2.active_dt) <=
                                            (TO_DATE ('19-???-2013'))))
         || ',1,null);'
  FROM   product p2
 WHERE   (p2.tracking_id, p2.tracking_id_serv) IN
               (SELECT   tracking_id, tracking_id_serv FROM PAC_002_VALORES)
         AND p2.component_id = 25977
         AND p2.billing_inactive_dt IS NULL;