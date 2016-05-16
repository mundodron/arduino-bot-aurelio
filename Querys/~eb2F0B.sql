select count(1) from (
SELECT account_no
 FROM cmf
WHERE no_bill = 0
  AND account_status != -2
  AND account_category IN (9, 10, 11)
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  AND UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P09'))
  AND  next_bill_date >= sysdate
  AND EXISTS (
         SELECT 1
           FROM service
          WHERE service.parent_account_no = cmf.account_no
            -- AND (service_inactive_dt IS NULL)) --seleção antiga!
            and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active)))  
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL)                   
UNION
SELECT account_no --account_no, bill_period, 0 "PROCESSO", 0 "DURACAO"
 FROM cmf
WHERE 
      UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P09'))
  AND account_category IN (9, 10, 11)
  AND child_count >= 1
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  AND no_bill = 0
  AND NOT EXISTS (
         SELECT 1
           FROM service
          WHERE cmf.account_no = service.parent_account_no
            --AND (service_inactive_dt IS NULL)) --seleção antiga!
            and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active)))  
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL)
 )

select 192025 - 189338 from dual

select account_category, no_bill, date_active, date_inactive from cmf where account_no in (8456551,6708492,8418796,7350136,7560764,6437573,4527142)

