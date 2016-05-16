-- Consulta para avaliar falhas
SELECT PAYMENT_DUE_DATE, COUNT(*)
  FROM BILL_INVOICE A, 
       bipp02_corp B
 WHERE A.ACCOUNT_NO = B.ACCOUNT_NO
   AND A.PREP_DATE >= TO_DATE ('2015090319:51:01','YYYYMMDDHH24:MI:SS')
   AND A.PREP_ERROR_CODE IS NULL
   AND A.PREP_STATUS = 4
   AND B.ACCOUNT_NO NOT IN (select account_no from GVT_LAYOUT_FATURAS_CORP
                             where flag =5
                               and status = 'Ativo')
GROUP BY PAYMENT_DUE_DATE;

--Apresentando o seguinte retorno
--01-SEP-15 2
--01-AUG-14 2
--01-MAR-14 2
--01-OCT-15 2223
--(criado a partir do incidente INC1119978)

-- Casos tratados no ciclo P02/Set
update bill_invoice 
   set statement_date = to_date('02092015','ddmmyyyy'), 
       payment_due_date = to_date('20092015','ddmmyyyy') 
 where bill_ref_no in (279247508,279247708);
 
update SIN_SEQ_NO 
   set statement_date = to_date('02092015','ddmmyyyy'), 
       payment_due_date = to_date('20092015','ddmmyyyy') 
 where bill_ref_no in (279247508,279247708); 

-- Consulta no job que resulta no ABORT
SELECT /*+ PARALLEL (A 12) FULL(A) */ COUNT(*)
  FROM BILL_INVOICE A
 WHERE PREP_DATE <= sysdate
   AND FORMAT_STATUS IN (0,3)
   AND PREP_STATUS IN (1,4)
   AND BACKOUT_STATUS = 0
   AND ACCOUNT_NO IN (SELECT ACCOUNT_NO FROM CMF WHERE ACCOUNT_CATEGORY IN (12,13,14,15,21,22)
                      UNION ALL
                      SELECT ACCOUNT_NO FROM bipp02_corp
                      UNION ALL
                      SELECT ACCOUNT_NO FROM CONTRACT_ASSIGNMENTS_HQ WHERE TRACKING_ID IN (SELECT TRACKING_ID FROM ARBORGVT_BILLING.CONTA_CORPORATE_HQ)) 
                      
select * from CONTRACT_ASSIGNMENTS_HQ

select * from CONTA_CORPORATE_HQ

select account_no from cmf_balance where bill_ref_no in (267751480,274724578,260728180,275796602,276008247,261814597,276146958)