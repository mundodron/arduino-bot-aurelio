SELECT account_no, bill_period, 0 "PROCESSO", 0 "DURACAO"
 FROM cmf
WHERE no_bill = 0
  AND account_status != -2
  AND account_category IN (10, 11)
  AND contact1_phone IS NOT NULL
  AND cust_zip IS NOT NULL
  --AND bill_period = UPPER ('M28')
  AND UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P09'))
  AND  next_bill_date >= sysdate
  AND next_bill_date = TO_DATE ('28/09/2015', 'DD/MM/YYYY')
  AND EXISTS (
         SELECT 1
           FROM service
          WHERE service.parent_account_no = cmf.account_no
            AND service.service_inactive_dt IS NULL)
            --AND (service.service_inactive_dt IS NULL or (service.service_inactive_dt + 7) > nvl(cmf.prev_cutoff_date,cmf.date_active)))
  AND EXISTS (
              SELECT 1
                FROM sin_group_ref SIN
               WHERE SIN.GROUP_ID = cmf.mkt_code
                     AND SIN.inactive_date IS NULL)
                     
                     
                     
                     
                     
select CMF.DATE_ACTIVE,
       (CMF.DATE_ACTIVE + 7),
       CMF.DATE_INACTIVE
  from cmf