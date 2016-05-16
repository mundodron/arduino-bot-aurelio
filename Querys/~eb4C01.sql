-- ALTERACAO: 17/06/2003 - FERNANDO BRUNER GOMES
--            Incluido tratamento para dividir 2a Fatura
-- 21/06/2003 - Fernando Bruner Gomes
--              Removido pl para distrib. contas para o cria_view, 
--              para abrangir disc_req e discreq_nrc
--
-- 27/01/2006 - Bortolo Bornancin Neto
--                            Comentado o drop table e o create table.
--                            Colocado uma funcai para truncar a tabela no shell.
--
-- 31/10/2012 - Paulo G. Schultz.
--                             Adequada pl a partir da seleção do retail production
--              para inserir somente SME em tabela de retail para proforma full.


set feedback off

insert into &1

SELECT account_no, bill_period, 0 "PROCESSO", 0 "DURACAO"
 FROM cmf
WHERE no_bill = 0
  AND account_status != -2
  AND account_category = 9
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  AND bill_period = UPPER ('M02')
  AND  next_bill_date >= sysdate
  AND EXISTS (
         SELECT 1
           FROM service
          WHERE service.parent_account_no = cmf.account_no
            AND service.service_inactive_dt IS NULL)
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL)
                     
                     
UNION

SELECT account_no, bill_period, 0 "PROCESSO", 0 "DURACAO"
 FROM cmf
WHERE bill_period = UPPER ('M02')
  AND account_category = 9
  AND child_count >= 1
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  AND no_bill = 0
  AND NOT EXISTS (
         SELECT 1
           FROM service
          WHERE cmf.account_no = service.parent_account_no
            AND (service_inactive_dt IS NULL))
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL);
                     
  select * from sin_group_ref
                     
                     
  commit;
  /
  exit;
  
  
  select * from bill_invoice 